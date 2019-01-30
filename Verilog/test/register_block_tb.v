`include "assert.v"

`include "../subassemblies/register_block.v"

module template ();

    integer pass, fail;

    reg [3:0] read1_id;
    wire [7:0] read1_value;

    reg [3:0] read2_id;
    wire [7:0] read2_value;

    reg [3:0] write_id;
    reg [7:0] write_value;

    reg clock = 0;
    always #10 begin
        clock = ~clock;
    end

    register_block dut (
        read1_id,
        read1_value,

        read2_id,
        read2_value,

        write_id,
        write_value
    );
    
    initial begin
        $display("Starting test suite: register_block");
        pass = 0;
        fail = 0;

        //*TEST
        read1_id = 3;
        #10; `assert(read1_value, 8'b0000_0000, "Reg is 0 at startup (read1)");

        //*TEST
        read2_id = 4;
        #10; `assert(read2_value, 8'b0000_0000, "Reg is 0 at startup (read2)");

        //*TEST
        read1_id = 14;
        #10; `assert(read1_value, 8'b0000_0000, "Nonexistent reg is 0");

        //*TEST
        read1_id = 0;
        #10; `assert(read1_value, 8'b0000_0000, "Reg_0 is 0");

        //*TEST
        write_id = 2;
        write_value = 8'b0101_0101;
        read1_id = 2;
        #10; `assert(read1_value, 8'b0101_0101, "Write to reg, read --> same value");

        //*TEST
        read1_id = 3;
        #10; `assert(read1_value, 8'b0000_0000, "Other reg is still 0");

        //*TEST
        write_id = 0;
        read1_id = 2;
        #10; `assert(read1_value, 8'b0101_0101, "Value is permanent");

        //*TEST
        read1_id = 0;
        #10; `assert(read1_value, 8'b0000_0000, "Writing to reg_0 fails");


        $display("Pass: %0d, Fail: %0d", pass, fail);
        $finish;
    end

endmodule