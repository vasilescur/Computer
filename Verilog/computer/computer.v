// Components
`include "../components/mux.v"
`include "../components/mux_thicc.v"
`include "../components/demux.v"
`include "../components/demux_thicc.v"

`include "../components/comparator.v"
`include "../components/adder.v"

`include "../components/ram.v"
`include "../components/rom.v"
`include "../components/register.v"

`include "../components/tty.v"

// Subassemblies
`include "../subassemblies/register_block.v"

module computer ();

    //* Registers
    reg [3:0] reg_read1_id = 0;
    wire [7:0] reg_read1_value;
    
    reg [3:0] reg_read2_id = 0;
    wire [7:0] reg_read2_value;

    reg [3:0] reg_write_id = 0;
    reg [7:0] reg_write_value;

    register_block regs (
        .read1_id (reg_read1_id),
        .read1_value (reg_read1_value),

        .read2_id (reg_read2_id),
        .read2_value (reg_read2_value),

        .write_id (reg_write_id),
        .write_value (reg_write_value)
    );


    //* ROM
    reg [7:0] rom_address = 0;
    wire [15:0] rom_data;

    rom program_rom (
        .address (rom_address),
        .data (rom_data)
    );


    //* RAM
    reg [7:0] ram_address = 0;
    wire [7:0] ram_data;

    reg ram_write = 0;
    reg [7:0] ram_write_data = 0;

    ram mem_ram (
        .address (ram_address),
        .data (ram_data),

        .write (ram_write),
        .write_data (ram_write_data)
    );


    //* Comparator
    reg [7:0] cmp_a = 0;
    reg [7:0] cmp_b = 0;

    wire [7:0] cmp_out;

    comparator #(8) cpm_boi (
        .a (cmp_a),
        .b (cmp_b),
        .out (cmp_out)
    );


    //* Instruction components and parsing
    // Parts of current instruction

    // 15 14 13 12    11 10 9  8     7  6  5  4     3  2  1  0
    // 0  0  0  0     0  0  0  0     0  0  0  0     0  0  0  0
    // ( opcode )     (  arg1  )     ((  arg2  )    or immed )

    wire [15:0] instr_current;
    assign instr_current = rom_data;
    
    wire [3:0] instr_opcode;
    assign instr_opcode = instr_current[15:12];

    wire [3:0] instr_arg1;
    assign instr_arg1 = instr_current[11:8];

    wire [3:0] instr_arg2;
    assign instr_arg2 = instr_current[7:4];

    wire [7:0] instr_middle_byte;
    assign instr_middle_byte = instr_current[11:4];

    wire [7:0] instr_last_byte;
    assign instr_last_byte = instr_current[7:0];


    //* Master clock
    reg clock = 0;
    reg clock_running = 0;
    reg [31:0] sys_time = 0;
    always #100 begin
        if (clock_running === 1) begin
            clock = ~clock;
            sys_time = sys_time + 1;
        end
    end


    //* TTY
    reg tty_clock = 0;
    reg [7:0] tty_data = 0;
    reg tty_enabled = 0;

    tty stdout (
        .clock (tty_clock),
        .data (tty_data),
        .enabled (tty_enabled)
    );

    
    // Temporary variables
    reg [7:0] temp_1 = 0;
    reg [7:0] temp_2 = 0;
    reg [7:0] temp_3 = 0;

    reg [3:0] temp_s_1 = 0;
    reg [3:0] temp_s_2 = 0;

    reg temp_xs_1 = 0;
    reg temp_xs_2 = 0;


    //* Jump controller
    reg pc_altered = 0;


    //* Setup procedure
    initial begin
        $display("Running...\n");

        clock_running = 1;
    end


    //* On Clock Tick
    always @ (clock) begin
        // Clock ticks last #100, so we can take up to #99 to process

        if (sys_time > 250) begin
            clock_running = 0;
            $display("\nExceeded 250 cycles. Stopping.");
            $finish;
        end

        #1;





        // $display("instr: %b", instr_current);
        // $display("arg1: %h, arg2: %h, mid: %h", instr_arg1, instr_arg2, instr_middle_byte);

        //* Determine what to do based on opcode
        case (instr_opcode)
            4'h0: begin //* nop
                // Do nothing.
                // Maybe pause, a little bit.
                #10;
            end

            4'h1: begin //* mov
                // Move value from arg2 overtop arg1
                reg_read1_id = instr_arg2;
                #1;
                reg_write_id = 0;
                reg_write_value = reg_read1_value;
                #1;
                reg_write_id = instr_arg1;
                
                #10;

                reg_write_id = 0;
                reg_write_value = 0;
                reg_read1_id = 0;
                #1;
            end

            4'h2: begin //* li
                // Load the immediate into the arg1 register
                reg_write_id = instr_arg1;
                reg_write_value = instr_last_byte;

                #10;

                //$display("    li-ed $%d <- 0x%h", reg_write_id, reg_write_value);

                reg_write_id = 0;
                #1;
            end

            4'h3: begin //* add
                // arg1 = arg1 + arg2
                reg_read1_id = instr_arg1;
                reg_read2_id = instr_arg2;
                #10;
                temp_1 = reg_read1_value + reg_read2_value;
                #10;
                reg_write_id = instr_arg1;
                reg_write_value = temp_1;
                #10;
                reg_write_id = 0;
                #1;
            end

            4'h4: begin //* addi
                reg_read1_id = instr_arg1;
                #10;
                temp_1 = reg_read1_value + instr_last_byte;
                #10;
                reg_write_id = instr_arg1;
                reg_write_value = temp_1;
                #10;
                reg_write_id = 0;
                #1;
            end

            4'h5: begin //* neg
                reg_read1_id = instr_arg1;
                #10;
                temp_1 = ~reg_read1_value + 1;  // 2's complement
                #10;
                reg_write_id = instr_arg1;
                reg_write_value = temp_1;
                #10;
                reg_write_id = 0;
                #1;
            end

            4'h6: begin //* lw
                reg_read1_id = instr_arg2;
                #10;
                ram_write = 0;
                #1;
                ram_address = reg_read1_value;
                #10;
                reg_write_id = instr_arg1;
                reg_write_value = ram_data;
                #10;
                reg_write_id = 0;
                #1;
            end

            4'h7: begin //* sw
                reg_read1_id = instr_arg1;
                reg_read2_id = instr_arg2;
                ram_write = 0;
                #10;
                ram_address = reg_read2_value;
                ram_write_data = reg_read1_value;
                #10;
                ram_write = 1;
                #10;
                ram_write = 0;
                reg_read1_id = 0;
                reg_read2_id = 0;
                #1;
            end

            4'h8: begin //* syscall
                // Get syscall number from register $8
                reg_read1_id = 8;
                #10;
                temp_1 = reg_read1_value;
                #1;
                
                // Process syscall
                case(temp_1)
                    8'h0: begin //* NOP
                        #10;
                    end

                    8'h1: begin //* Print (ascii) $1 to tty
                        reg_read2_id = 1;
                        #5;
                        tty_data = reg_read2_value;
                        tty_enabled = 1;
                        #5;
                        tty_clock = 1;
                        #10;
                        tty_clock = 0;
                        tty_enabled = 0;
                        #1;
                    end

                    8'hf: begin //* Halt
                        #10;
                        $display("\nExecution halted.");
                        $finish;
                    end

                    default: begin
                        $display("\nSyscall %d not yet implemented", temp_1);
                        #10;
                    end

                endcase
            end

            4'h9: begin //* j
                pc_altered = 1;

                reg_write_id = 12;  // $pc
                reg_write_value = instr_middle_byte;

                #10;

                reg_write_id = 0;
            end

            4'ha: begin //* ja
                pc_altered = 1;

                reg_read1_id = instr_arg1;
                #1;

                reg_write_id = 12;
                reg_write_value = reg_read1_value;
                #10;

                reg_read1_id = 0;
                reg_write_id = 0;
                #10;
            end

            4'hb: begin //* cmp
            
                reg_write_id = 6;
                reg_write_value = 8'b0000_0001;
                #20;

                reg_write_id = 0;

                reg_read1_id = 6;
                #10;
                $display("$6 is %b", reg_read1_value);

                // $display("In cmp");

                // reg_write_id = 4'ha;
                // reg_write_value = 1;
                // #10;

                // reg_read1_id = instr_arg1;
                // reg_read2_id = instr_arg2;
                // #10;

                // cmp_a = reg_read1_value;
                // cmp_b = reg_read2_value;
                // #10;

                // temp_1 = cmp_out;
                // #10;

                // reg_write_id = 9;   // $cmp
                // #10;
                // reg_write_value = temp_1;
                // #10;

                // $display("Just set $cmp = %d", reg_write_value);


                // #30;

                // reg_read1_id = 9;
                // #5;
                // $display(" --> Wrote: %d", reg_read1_value);
                // reg_read1_id = 0;

                // #1;

                // reg_write_id = 0;
            end

            4'hc: begin //* jeq
                reg_read1_id = 9;
                #1;

                if (reg_read1_value === 2) begin
                    pc_altered = 1;
                    reg_write_id = 12;
                    reg_write_value = instr_middle_byte;
                    #10;

                    reg_write_id = 0;
                end
            end

            4'hd: begin //* jlt
                $display("Should I jlt?");
                reg_read1_id = 4'ha;
                #50;

                $display("$cmp = %d", reg_read1_value);

                if (reg_read1_value === 1) begin
                    pc_altered = 1;
                    reg_write_id = 12;
                    reg_write_value = instr_middle_byte;
                    #10;

                    reg_write_id = 0;
                end 
            end

            4'he: begin //* jgt
                reg_read1_id = 9;
                #1;

                if (reg_read1_value === 3) begin
                    pc_altered = 1;
                    reg_write_id = 12;
                    reg_write_value = instr_middle_byte;
                    #10;

                    reg_write_id = 0;
                end
            end

            4'hf: begin //* jne
                reg_read1_id = 9;
                #1;

                if (reg_read1_value !== 2) begin
                    pc_altered = 1;
                    reg_write_id = 12;
                    reg_write_value = instr_middle_byte;
                    #10;

                    reg_write_id = 0;
                end
            end
        endcase

        //* Reset things
        // reg_read1_id = 0;
        // reg_read2_id = 0;
        // reg_write_id = 0;

        //* Advance one instruction
        if (pc_altered === 0) begin
            rom_address = rom_address + 1;
        end
        
        pc_altered = 0;

        #1;

    end

endmodule