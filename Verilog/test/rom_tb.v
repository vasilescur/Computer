`include "assert.v"

`include "../components/rom.v"

module rom_tb ();

    integer pass, fail;

    reg [7:0] address;
    wire [15:0] data;

    rom dut (
        .address (address),
        .data (data)
    );

    integer i = 0;

    initial begin
        $display("Starting test suite: rom_tb");
        pass = 0;
        fail = 0;

        $display("  Printing contents of ROM...");

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