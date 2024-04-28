module MEM_WB
(
    input          clk_i,
    input          rst_i,
    input          MEM_RegWrite_i,
    input          MEM_MemtoReg_i,
    input [31:0]   MEM_ALUOut_i,
    input [31:0]   MEM_MemOut_i,
    input [4:0]    MEM_RDaddr_i,
    output         WB_RegWrite_o,
    output         WB_MemtoReg_o,
    output [31:0]  WB_ALUOut_o,
    output [31:0]  WB_MemOut_o,
    output [4:0]   WB_RDaddr_o
);

reg          MEM_WB_RegWrite;
reg          MEM_WB_MemtoReg;
reg [31:0]   MEM_WB_ALUOut;
reg [31:0]   MEM_WB_MemOut;
reg [4:0]    MEM_WB_RDaddr;

assign WB_RegWrite_o = MEM_WB_RegWrite;
assign WB_MemtoReg_o = MEM_WB_MemtoReg;
assign WB_ALUOut_o = MEM_WB_ALUOut;
assign WB_MemOut_o = MEM_WB_MemOut;
assign WB_RDaddr_o = MEM_WB_RDaddr;

always @ (posedge clk_i or negedge rst_i) 
begin
    if (!rst_i) 
    begin
        MEM_WB_RegWrite <= 1'b0;
        MEM_WB_MemtoReg <= 1'b0;
        MEM_WB_ALUOut <= 32'b0;
        MEM_WB_MemOut <= 32'b0;
        MEM_WB_RDaddr <= 5'b0;
    end 
    else 
    begin
        MEM_WB_RegWrite <= MEM_RegWrite_i;
        MEM_WB_MemtoReg <= MEM_MemtoReg_i;
        MEM_WB_ALUOut <= MEM_ALUOut_i;
        MEM_WB_MemOut <= MEM_MemOut_i;
        MEM_WB_RDaddr <= MEM_RDaddr_i;
    end
end
endmodule