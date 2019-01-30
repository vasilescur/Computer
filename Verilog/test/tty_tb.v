`include "assert.v"

`include "../components/tty.v"

module tty_tb ();

    integer pass, fail;

    reg [7:0] data;
    reg enabled = 0;

    reg clock = 0;
    always #10 begin
        clock = ~clock;
    end

    tty dut (
        .clock (clock),
        .data (data),
        .enabled (enabled)
    );

    integer i = 0;

    initial begin
        $display("Starting test suite: tty_tb");
        pass = 0;
        fail = 0;

        $display("  Should print \"12345\\n\"...");

        data = 8'd49;

        for (i = 0; i < 5; i++) begin
            enabled = 1;
            #20;
            enabled = 0;

            data++;
        end

        data = 8'd10;
        enabled = 1;
        #20;
        enabled = 0;

        $display("  Done printing, assuming pass.");
        pass++;

        $display("Pass: %0d, Fail: %0d", pass, fail);
        $finish;
    end

endmodule