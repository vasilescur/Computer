`ifndef adder
`define adder

// Utility macro: two's complement negative
`define neg(number) ~number + 8'h01

module adder #(parameter dw = 8) (
        input wire [dw - 1:0] a,
        input wire [dw - 1:0] b,

        output [dw - 1:0] out
    );
    
    assign out = a + b;

endmodule

`endif