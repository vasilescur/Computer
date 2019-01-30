`ifndef mod_demux_thicc
`define mod_demux_thicc

module demux_thicc #(parameter dw = 1) (

        input wire [dw - 1:0] in,
        input wire [3:0] select,

        output reg [dw - 1:0] out_0,
        output reg [dw - 1:0] out_1,
        output reg [dw - 1:0] out_2,
        output reg [dw - 1:0] out_3,
        output reg [dw - 1:0] out_4,
        output reg [dw - 1:0] out_5,
        output reg [dw - 1:0] out_6,
        output reg [dw - 1:0] out_7,
        output reg [dw - 1:0] out_8,
        output reg [dw - 1:0] out_9,
        output reg [dw - 1:0] out_a,
        output reg [dw - 1:0] out_b,
        output reg [dw - 1:0] out_c,
        output reg [dw - 1:0] out_d,
        output reg [dw - 1:0] out_e,
        output reg [dw - 1:0] out_f
    );

    task clearOuts; begin
        {out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7, out_8, out_9, out_a, out_b, out_c, out_d, out_e, out_f} = {16{8'b0000_0000}};
    end
    endtask

    initial begin
        clearOuts();
    end

    always @ (in or select) begin
        clearOuts();
        case (select)
            0: out_0 = in;
            1: out_1 = in;
            2: out_2 = in;
            3: out_3 = in;
            4: out_4 = in;
            5: out_5 = in;
            6: out_6 = in;
            7: out_7 = in;
            8: out_8 = in;
            9: out_9 = in;
            10: out_a = in;
            11: out_b = in;
            12: out_c = in;
            13: out_d = in;
            14: out_e = in;
            15: out_f = in;
            default: clearOuts();
        endcase
    end 

endmodule

`endif