`include "assert.v"

`include "../components/"

module template ();

    integer pass, fail;

   

    initial begin
        $display("Starting test suite: ");
        pass = 0;
        fail = 0;

        

        $display("Pass: %0d, Fail: %0d", pass, fail);
        $finish;
    end

endmodule