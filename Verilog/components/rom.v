`ifndef mod_rom
`define mod_rom

module rom (
        input wire [7:0] address,
        output wire [15:0] data
    );

    reg [15:0] internal[0:256]; // 256 possible slots, of 16 bytes each
    
    initial begin
        // Read ROM from an input file
        $readmemh("../romImage.rom", internal, 0);
    end

/*
    always @ (posedge clock) begin
        data <= internal[address];
    end
*/

    assign data = internal[address];
endmodule

`endif