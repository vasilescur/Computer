`ifndef mod_register_block
`define mod_register_block

`include "../components/register.v"
`include "../components/mux.v"
`include "../components/mux_thicc.v"
`include "../components/demux_thicc.v"

module register_block (
        input [3:0] read1_id,
        output [7:0] read1_value,

        input [3:0] read2_id,
        output [7:0] read2_value,

        input [3:0] write_id,
        input [7:0] write_value
    );

    wire [7:0] data;
    assign data = write_value;

    wire [7:0] value[0:12];

    wire enable[0:12];

    reg const_hi = 1;
    reg const_lo = 0;

    register reg_0 (data, value[0], const_lo);  // reg_0 is read-only
    register reg_1 (data, value[1], enable[1]);
    register reg_2 (data, value[2], enable[2]);
    register reg_3 (data, value[3], enable[3]);
    register reg_4 (data, value[4], enable[4]);
    register reg_5 (data, value[5], enable[5]);
    register reg_6 (data, value[6], enable[6]);
    register reg_7 (data, value[7], enable[7]);
    register reg_8 (data, value[8], enable[8]);
    register reg_cmp (data, value[9], enable[9]);
    register reg_sp (data, value[10], enable[10]);
    register reg_sf (data, value[11], enable[11]);
    register reg_pc (data, value[12], enable[12]);
    
    mux_thicc #(8) read1_mux (
        value[0], value[1], value[2], value[3], value[4], value[5], value[6], value[7], value[8],
        value[9], value[10], value[11], value[12], value[0], value[0], value[0],

        read1_id,   // .select
        read1_value // .out
    );

    mux_thicc #(8) read2_mux (
        value[0], value[1], value[2], value[3], value[4], value[5], value[6], value[7], value[8],
        value[9], value[10], value[11], value[12], value[0], value[0], value[0],

        read2_id,   // .select
        read2_value // .out
    );

    demux_thicc #(1) write_demux (
        .in (const_hi),
        .select (write_id),

        .out_0 (enable[0]),     .out_1 (enable[1]),
        .out_2 (enable[2]),     .out_3 (enable[3]),
        .out_4 (enable[4]),     .out_5 (enable[5]),
        .out_6 (enable[6]),     .out_7 (enable[7]),
        .out_8 (enable[8]),     .out_9 (enable[9]),
        .out_a (enable[10]),    .out_b (enable[11]),
        .out_c (enable[12]),    .out_d (enable[0]),
        .out_e (enable[0]),     .out_f (enable[0])
    );

    always @ (write_id or write_value) begin
        //if (write_id !== 0)
            //$display("    Set $%d to 0x%h", write_id, write_value);

        if (write_id === 9) begin
            $display("Writing to $cmp: %d", write_value);
        end

    end

endmodule

`endif