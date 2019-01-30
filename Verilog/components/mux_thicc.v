`ifndef mod_mux_thicc
`define mod_mux_thicc

module mux_thicc #(parameter dw = 1) (

        input wire [dw - 1:0] in_0,
        input wire [dw - 1:0] in_1,
        input wire [dw - 1:0] in_2,
        input wire [dw - 1:0] in_3,
        input wire [dw - 1:0] in_4,
        input wire [dw - 1:0] in_5,
        input wire [dw - 1:0] in_6,
        input wire [dw - 1:0] in_7,
        input wire [dw - 1:0] in_8,
        input wire [dw - 1:0] in_9,
        input wire [dw - 1:0] in_a,
        input wire [dw - 1:0] in_b,
        input wire [dw - 1:0] in_c,
        input wire [dw - 1:0] in_d,
        input wire [dw - 1:0] in_e,
        input wire [dw - 1:0] in_f,

        input wire [3:0] select,

        output reg [dw - 1:0] out
    );

    always @ (in_0 or in_1 or in_2 or in_3 or in_4 or in_5 or in_6 or in_7 or in_8 or in_9 or in_a or in_b or in_c or in_d or in_e or in_f or select) 
        case (select) 
            0: out = in_0;
            1: out = in_1;
            2: out = in_2;
            3: out = in_3;
            4: out = in_4;
            5: out = in_5;
            6: out = in_6;
            7: out = in_7;
            8: out = in_8;
            9: out = in_9;
            10: out = in_a;
            11: out = in_b;
            12: out = in_c;
            13: out = in_d;
            14: out = in_e;
            15: out = in_f;
            default: out = in_0;
    endcase 

endmodule

`endif