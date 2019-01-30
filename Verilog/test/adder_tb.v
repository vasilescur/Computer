`include "assert.v"

`include "../components/adder.v"

module template ();

    integer pass, fail;

    reg [7:0] a;
    reg [7:0] b;

    wire [7:0] out;

    adder dut (
        .a (a),
        .b (b),
        .out (out)
    );

    initial begin
        $display("Starting test suite: ");
        pass = 0;
        fail = 0;

        a = 0;
        b = 0;

        //*TEST
        #10; `assert(out, 0, "0 + 0");

        //*TEST
        a = 1;
        #10; `assert(out, 1, "1 + 0");

        //*TEST
        b = 1;
        #10; `assert(out, 2, "1 + 1");

        //*TEST
        a = 20;
        b = 6;
        #10; `assert(out, 26, "20 + 6");

        //*TEST
        a = 10;
        b = `neg(8'd3);
        #10; `assert(out, 7, "10 + (-3)");

        //*TEST
        a = 2;
        b = `neg(8'd5);
        #10; `assert(out, `neg(8'd3), "2 + (-5)");

        $display("Pass: %0d, Fail: %0d", pass, fail);
        $finish;
    end

endmodule