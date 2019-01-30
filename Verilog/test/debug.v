`ifndef def_debug
`define def_debug

`define debug(a) \
    $write("%c[35m", 27);

`define endDebug(a) \
    $write("%c[0m", 27);

`endif