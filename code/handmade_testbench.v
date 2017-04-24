`define END_COUNT 25

`include "MUX_2to1.v"
module TestBench;

    //Internal Signals
    reg         CLK = 1;

    //Create tested modle

    wire [32-1:0] x;
    reg  [32-1:0] y, z;
    reg sel;
    MUX_2to1 #(.size(32)) M(
        .data0_i(y),
        .data1_i(z),
        .select_i(sel),
        .data_o(x)
        );
    //Main function

    always #10 CLK = ~CLK;

    initial  begin
        y = 1;
        z = 2;
        sel = 1;
        #20;
        sel = 0;
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
