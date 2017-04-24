`define END_COUNT 25

`include "Sign_Extend.v"
module TestBench;

    //Internal Signals
    reg         CLK = 1;

    //Create tested modle

    reg [16-1:0] x;
    wire [32-1:0] y;
    Sign_Extend S(x, y);
    //Main function

    always #10 CLK = ~CLK;

    initial  begin
        x = 16'b10000000_00000000;

        #20 x = 16'b00000000_00000000;
        #20 x = 16'b10000000_00001000;
        #20 $finish;
    end

    //Print result to "CO_P2_Result.txt"
    always@(posedge CLK) begin

    end

    initial begin
        $dumpfile("result.vcd");
        $dumpvars;
    end

endmodule
