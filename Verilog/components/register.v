`ifndef mod_register
`define mod_register

`include "../test/debug.v"

module register (
        input clock,
        input [7:0] data,
        output [7:0] out,
        input enable
    );

    //reg [7:0] data;
    wire enable;
    wire clock;
    reg [7:0] out;

    reg [7:0] internal;

    initial begin
        internal = 0;

        assign out = internal;
    end

    always @ (posedge clock) begin
        if (enable === 1) begin
            internal = data;
        end
    end
endmodule

`endif