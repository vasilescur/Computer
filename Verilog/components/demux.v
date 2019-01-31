`ifndef mod_demux
`define mod_demux

module demux #(parameter dw = 1) (
        input wire [dw - 1:0] in,
        input wire select,

        output [dw - 1:0] out_a,
        output [dw - 1:0] out_b
    );

    assign out_a = select ? 0 : in;
    assign out_b = select ? in : 0;

endmodule

`endif