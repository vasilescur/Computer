`ifndef def_assert
`define def_assert

`define assert(signal, value, name) \
    if (signal !== value) begin \
        $write("%c[1;31m", 27); \
        $display("X   FAIL: [%s] Got: %b, Expected: %b", name, signal, value); \
        $write("%c[0m", 27); \
        fail++; \
    end else begin \
        $write("%c[32m", 27); \
        $display("    PASS: [%s]", name); \
        $write("%c[0m", 27); \
        pass++; \
    end

`endif