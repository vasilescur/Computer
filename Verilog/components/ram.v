`ifndef mod_ram
`define mod_ram

module ram (
        input wire [7:0] address,
        output wire [7:0] data,

        input wire write,
        input wire [7:0] write_data
    );

    reg [7:0] internal[0:256]; // 256 possible slots of 8 bits each
    
    integer i = 0;
    initial begin
        // Initialize RAM to zero
        for (i = 0; i < 256; i++) begin
            internal[i] = 0;
        end
    end

/*
    always @ (posedge clock) begin
        data <= internal[address];
    end
*/

    always @ (address or write or write_data) begin
        if (write === 1) begin
            internal[address] = write_data;
        end
    end

    assign data = internal[address];
endmodule

`endif