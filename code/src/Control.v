module Control
(
    input  [6:0]  opcode_i,
    input         NoOp_i,
    output        RegWrite_o,
    output        MemtoReg_o,
    output        MemRead_o,
    output        MemWrite_o,
    output [1:0]  ALUOp_o,
    output        ALUSrc_o,
    output        Branch_o
);

reg [7:0] control;
always @(*) 
begin
    if (NoOp_i) 
    begin
        control = 8'b00001100;
    end
    else begin
        case(opcode_i)
            7'b0110011: control = 8'b10001000;
            7'b0010011: control = 8'b10000010;
            7'b0000011: control = 8'b11100010;
            7'b0100011: control = 8'b00010010;
            7'b1100011: control = 8'b00000101;
            default: control = 8'b00000000;
        endcase
    end
end     

assign RegWrite_o = control[7];
assign MemtoReg_o = control[6];
assign MemRead_o = control[5];
assign MemWrite_o = control[4];
assign ALUOp_o = control[3:2];
assign ALUSrc_o = control[1];
assign Branch_o = control[0];
endmodule 

