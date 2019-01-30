`ifndef mod_tty
`define mod_tty

module tty (
        input wire clock,
        input [7:0] data,
        input wire enabled
    );

    always @ (posedge clock) begin
        if (enabled === 1) begin
            $write("%c", data); // %c = character
        end
    end

endmodule

`endif