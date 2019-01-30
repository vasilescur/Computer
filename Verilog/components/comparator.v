`ifndef mod_comparator
`define mod_comparator

module comparator #(parameter dw = 8) (
        input wire [dw - 1:0] a,
        input wire [dw - 1:0] b,

        output wire lt,
        output wire eq,
        output wire gt
    );

    assign lt = a < b ? 1 : 0;
    assign eq = a == b ? 1 : 0;
    assign gt = a > b ? 1 : 0;

endmodule

`endif