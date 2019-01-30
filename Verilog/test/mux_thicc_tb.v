`include "assert.v"

`include "../components/mux_thicc.v"

module mux_thicc_tb ();

    integer pass, fail;

    reg [7:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, ra, rb, rc, rd, re, rf;
    reg [3:0] select;
    wire [7:0] out;

    mux_thicc #(8) dut (
        .in_0 (r0),     .in_1 (r1),
        .in_2 (r2),     .in_3 (r3),
        .in_4 (r4),     .in_5 (r5),
        .in_6 (r6),     .in_7 (r7),
        .in_8 (r8),     .in_9 (r9),
        .in_a (ra),     .in_b (rb),
        .in_c (rc),     .in_d (rd),
        .in_e (re),     .in_f (rf),

        .select (select),
        .out (out)
    );

    initial begin
        $display("Starting test suite: mux_thicc_tb");
        pass = 0;
        fail = 0;

        // Set all values
        {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, ra, rb, rc, rd, re, rf} = {8{8'b0000_0000}};
        r1 = 8'b0001_0001;
        r2 = 8'b0001_0010;
        r3 = 8'b0001_0011;
        rf = 8'b0001_1111;

        //*TEST
        select = 0;
        #10; `assert(out, 8'b0000_0000, "Select = 0 --> Value is r0");

        //*TEST
        select = 1;
        #10; `assert(out, 8'b0001_0001, "Select = 1 --> Value is r1");

        //*TEST
        select = 3;
        #10; `assert(out, 8'b0001_0011, "Select = 3 --> Value is r3");

        //*TEST
        select = 4'hf;
        #10; `assert(out, 8'b0001_1111, "Select = 0xf --> Value is rf");


        $display("Pass: %0d, Fail: %0d", pass, fail);
        $finish;
    end

endmodule