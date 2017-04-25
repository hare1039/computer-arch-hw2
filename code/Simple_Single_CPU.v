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
    wire [32-1:0] read_data_1, read_data_2;
    wire [32-1:0] mux_alusrc;

    wire reg_dst, zero;
    wire [2:0] alu_op;
    wire [3:0] alu_ctrl;
    wire [4:0] mux_write_reg;

    wire branch_result = branch & zero;

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
            .data0_i (instruction[20:16]),
            .data1_i (instruction[15:11]),
            .select_i(RegDst),
            .data_o  (mux_write_reg)
            );

    Reg_File RF(
            .clk_i     (clk_i),
    	    .rst_i     (rst_i),
            .RSaddr_i  (instruction[25:21]) ,
            .RTaddr_i  (instruction[20:16]) ,
            .RDaddr_i  (instruction[15:11]) ,
            .RDdata_i  (alu),
            .RegWrite_i(reg_dst),
            .RSdata_o  (read_data_1),
            .RTdata_o  (read_data_2)
            );

    Decoder Decoder(
            .instr_op_i(instruction[31:26]),
    	    .RegWrite_o(reg_dst),
    	    .ALU_op_o(alu_op),
    	    .ALUSrc_o(alu_src),
    	    .RegDst_o(reg_dst),
    		.Branch_o(branch)
    	    );

    ALU_Ctrl AC(
            .funct_i  (instruction[5:0]),
            .ALUOp_i  (alu_op),
            .ALUCtrl_o(alu_ctrl)
            );

    Sign_Extend SE(
            .data_i(instruction[15:0]),
            .data_o(se)
            );

    MUX_2to1 #(.size(32)) Mux_ALUSrc(
            .data0_i (read_data_2),
            .data1_i (se),
            .select_i(alu_src),
            .data_o  (mux_alusrc)
            );

    ALU ALU(
            .src1_i  (read_data_1),
    	    .src2_i  (read_data_2),
    	    .ctrl_i  (alu_ctrl),
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
            .select_i(branch_result),
            .data_o  (mux_pc_source)
            );

endmodule
`endif//SIMPLE_SINGLE_CPU
