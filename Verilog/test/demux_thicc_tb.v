`include "assert.v"

`include "../components/demux_thicc.v"

module template ();

    integer pass, fail;

    reg [7:0] in;
    reg [3:0] select;

    wire [7:0] out_0;
    wire [7:0] out_1;
    wire [7:0] out_2;
    wire [7:0] out_3;
    wire [7:0] out_4;
    wire [7:0] out_5;
    wire [7:0] out_6;
    wire [7:0] out_7;
    wire [7:0] out_8;
    wire [7:0] out_9;
    wire [7:0] out_a;
    wire [7:0] out_b;
    wire [7:0] out_c;
    wire [7:0] out_d;
    wire [7:0] out_e;
    wire [7:0] out_f;

    demux_thicc #(8) dut (
        .in (in),
        .select (select),

        .out_0 (out_0),
        .out_1 (out_1),
        .out_2 (out_2),
        .out_3 (out_3),
        .out_4 (out_4),
        .out_5 (out_5),
        .out_6 (out_6),
        .out_7 (out_7),
        .out_8 (out_8),
        .out_9 (out_9),
        .out_a (out_a),
        .out_b (out_b),
        .out_c (out_c),
        .out_d (out_d),
        .out_e (out_e),
        .out_f (out_f)
    );

    initial begin
        $display("Starting test suite: demux_thicc");
        pass = 0;
        fail = 0;

        //*TEST
        select = 0;
        in = 8'b0101_1010;

        #10; `assert(out_0, 8'b0101_1010, "Selected out is correct");
        #10; `assert(out_1, 8'b0000_0000, "Unselected out is 0");
        #10; `assert(out_c, 8'b0000_0000, "Other unselected out is 0");

        //*TEST
        in = 8'b0000_1111;

        #10; `assert(out_0, 8'b0000_1111, "Selected out is correct");
        #10; `assert(out_1, 8'b0000_0000, "Unselected out is 0");
        #10; `assert(out_c, 8'b0000_0000, "Other unselected out is 0");

        //*TEST
        select = 4;

        #10; `assert(out_0, 8'b0000_0000, "Unselected out is back to 0");
        #10; `assert(out_4, 8'b0000_1111, "New selected out is correct");
        #10; `assert(out_b, 8'b0000_0000, "Other unselected out is 0");


        $display("Pass: %0d, Fail: %0d", pass, fail);
        $finish;
    end

endmodule