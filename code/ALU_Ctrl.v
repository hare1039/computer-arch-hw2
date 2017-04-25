`ifndef ALU_CTRL_V
`define ALU_CTRL_V
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );

    //I/O ports
    input      [6-1:0] funct_i;
    input      [3-1:0] ALUOp_i;

    output     [4-1:0] ALUCtrl_o;

    //Internal Signals
    reg        [4-1:0] ALUCtrl_o;

    //Parameter


    //Select exact operation
    always @ ( * ) begin
        if (funct_i==6'b100000 && ALUOp_i==3'b010) begin  //add
            ALUCtrl_o=4'b0010;
        end

        else if(funct_i==6'b100010 && ALUOp_i==3'b010) begin  //sub
            ALUCtrl_o=4'b0110;
        end

        else if(funct_i==6'b100100 && ALUOp_i==3'b010) begin  //and
            ALUCtrl_o=4'b0000;
        end

        else if(funct_i==6'b100101 && ALUOp_i==3'b010) begin  //or
            ALUCtrl_o=4'b0001;
        end

        else if(funct_i==6'b101010 && ALUOp_i==3'b010) begin  //slt
            ALUCtrl_o=4'b0111;
        end

        else if(funct_i==6'bxxxxxx && ALUOp_i==3'b000) begin  //lw, sw
            ALUCtrl_o=4'b0010;
        end

        else if(funct_i==6'bxxxxxx && ALUOp_i==3'b001) begin  //beq
            ALUCtrl_o=4'b0110;
        end

        else begin
            ALUCtrl_o=4'bxxxx;
        end
    end
endmodule
`endif//ALU_CTRL_V
