`ifndef SIMPLE_SINGLE_CPU
`define SIMPLE_SINGLE_CPU
`include "ProgramCounter.v"
`include "Sign_Extend.v"
`include "Decoder.v"
`include "Adder.v"
`include "ALU_Ctrl.v"
`include "ALU.v"
`include "Instr_Memory.v"
`include "MUX_2to1.v"
`include "Reg_File.v"
`include "Shift_Left_Two_32.v"

module Simple_Single_CPU(
        clk_i,
		rst_i
		);
/*
Vars delcares: (pre_pc) => [PC] => (pc)
except some other good names
 */


    //I/O port
    input         clk_i;
    input         rst_i;

    //Internal Signles
    wire [32-1:0] mux_pc_source, pc; // ProgramCounter
    wire [32-1:0] adder1;
    wire [32-1:0] se;                // sign extended
    wire [32-1:0] shifter;
    wire [32-1:0] adder2;
    wire [32-1:0] instruction;
    wire [32-1:0] alu_result;

    //Greate componentes
    ProgramCounter PC(
            .clk_i   (clk_i),
    	    .rst_i   (rst_i),
    	    .pc_in_i (mux_pc_source),
    	    .pc_out_o(pc)
    	    );


    Adder Adder1(
            .src1_i(32'd4),
    	    .src2_i(pc),
    	    .sum_o (adder1)
    	    );

    Instr_Memory IM(
            .pc_addr_i(pc),
    	    .instr_o  (instruction)
    	    );

    MUX_2to1 #(.size(5)) Mux_Write_Reg(
            .data0_i (),
            .data1_i (),
            .select_i(RegDst),
            .data_o  ()
            );

    Reg_File RF(
            .clk_i     (clk_i),
    	    .rst_i     (rst_i),
            .RSaddr_i  (instruction[25:21]) ,
            .RTaddr_i  (instruction[20:16]) ,
            .RDaddr_i  (instruction[15:11]) ,
            .RDdata_i  (),
            .RegWrite_i(),
            .RSdata_o  (),
            .RTdata_o  ()
            );

    Decoder Decoder(
            .instr_op_i(instruction[31:26]),
    	    .RegWrite_o(),
    	    .ALU_op_o(),
    	    .ALUSrc_o(),
    	    .RegDst_o(),
    		.Branch_o()
    	    );

    ALU_Ctrl AC(
            .funct_i  (),
            .ALUOp_i  (),
            .ALUCtrl_o()
            );

    Sign_Extend SE(
            .data_i(),
            .data_o(se)
            );

    MUX_2to1 #(.size(32)) Mux_ALUSrc(
            .data0_i (),
            .data1_i (),
            .select_i(),
            .data_o  ()
            );

    ALU ALU(
            .src1_i  (),
    	    .src2_i  (),
    	    .ctrl_i  (),
    	    .result_o(alu),
    		.zero_o  (zero)
    	    );

    Adder Adder2(
            .src1_i(adder1),
    	    .src2_i(shifter),
    	    .sum_o (adder2)
    	    );

    Shift_Left_Two_32 Shifter(
            .data_i(se),
            .data_o(shifter)
            );

    MUX_2to1 #(.size(32)) Mux_PC_Source(
            .data0_i (adder1),
            .data1_i (adder2),
            .select_i(),
            .data_o  (mux_pc_source)
            );

endmodule
`endif//SIMPLE_SINGLE_CPU
