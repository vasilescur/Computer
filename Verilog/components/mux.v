`ifndef mod_mux
`define mod_mux

module mux #(parameter dw = 1) (
        input wire [dw - 1:0] a,
        input wire [dw - 1:0] b,
        input wire select,

        output [dw - 1:0] out
    );

    assign out = select ? b : a;

endmodule

`endif