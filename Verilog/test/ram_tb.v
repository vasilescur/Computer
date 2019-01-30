`include "assert.v"

`include "../components/ram.v"

module rom_tb ();

    integer pass, fail;

    reg [7:0] address;
    wire [7:0] data;

    reg write = 0;
    reg [7:0] write_data;

    ram dut (
        .address (address),
        .data (data),

        .write (write),
        .write_data (write_data)
    );

    integer i = 0;

    initial begin
        $display("Starting test suite: ram_tb");
        pass = 0;
        fail = 0;

        $display("  Printing contents of RAM...");

        for (i = 0; i < 256; i++) begin
            address = i;
            #10; 

            if (i % 8 == 0) begin
                $write("\n   %0h\t", address);
            end

            $write(" %h", data);
        end

        $write("\n");

        $display("  Done printing, assuming pass.");
        pass++;

        $display("  Starting test operations...");

        //*TEST
        address = 8'ha0;
        write = 0;
        #10; `assert(data, 8'h00, "Random data is 00");

        //*TEST
        write = 1;
        write_data = 8'hbe;
        #10;
        write = 0;
        #10; `assert(data, 8'hbe, "Written data");

        //*TEST
        address = address + 1;
        write_data = 8'hef;
        write = 1;
        #10;
        write = 0;
        #10; `assert(data, 8'hef, "Written more data");

        //*TEST
        address = address - 1;
        #10; `assert(data, 8'hbe, "First one is intact");

        $display("  Printing contents of RAM...");

        for (i = 0; i < 256; i++) begin
            address = i;
            #10; 

            if (i % 8 == 0) begin
                $write("\n   %0h\t", address);
            end

            $write(" %h", data);
        end

        $write("\n");

        $display("  Done printing, assuming pass.");
        pass++;


        $display("Pass: %0d, Fail: %0d", pass, fail);
        $finish;
    end

endmodule