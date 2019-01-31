`ifndef mod_comparator
`define mod_comparator

module comparator #(parameter dw = 8) (
        input wire [dw - 1:0] a,
        input wire [dw - 1:0] b,

        output reg [7:0] out
    );

    always @ (a or b) begin
        if (a < b)  out = 1;
        if (a == b) out = 2;
        if (a > b)  out = 3;
    end
    
endmodule

`endif