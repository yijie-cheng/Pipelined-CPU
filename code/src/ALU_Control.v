module ALU_Control
(
    input [2:0] funct3_i,
    input [6:0] funct7_i,
    input [1:0] ALUOp_i,
    output reg [2:0] ALUCtrl_o
);

always @(*) 
begin
    case (ALUOp_i)
        2'b10:
            case (funct3_i)
                3'b111: ALUCtrl_o = 3'b111;
                3'b100: ALUCtrl_o = 3'b100;
                3'b001: ALUCtrl_o = 3'b001;
                3'b101: ALUCtrl_o = 3'b101;
                3'b000: 
                    if (funct7_i[5] == 1'b1) 
                    begin
                        ALUCtrl_o = 3'b010;
                    end 
                    else if (funct7_i[0] == 1'b1) 
                    begin
                        ALUCtrl_o = 3'b011;
                    end 
                    else 
                    begin
                        ALUCtrl_o = 3'b000;
                    end
            endcase
        2'b00:
            if (funct3_i == 3'b101) 
            begin
                ALUCtrl_o = 3'b101;
            end 
            else 
            begin
                ALUCtrl_o = 3'b000;
            end 
        2'b01:
            ALUCtrl_o = 3'b010;
        default:
            ALUCtrl_o = 3'b110;
    endcase
end
endmodule