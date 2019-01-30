`include "assert.v"

`include "../components/rom.v"

module rom_tb ();

    integer pass, fail;

    reg [7:0] address;
    wire [15:0] data;

    reg clock = 0;
    always #10 begin
        clock = ~clock;
    end

    rom dut (
        .clock (clock),
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
            #10; $display("    Addr: %h\tValue: %h", address, data);
        end

        $display("  Done printing, assuming pass.");
        pass++;

        $display("Pass: %0d, Fail: %0d", pass, fail);
        $finish;
    end

endmodule