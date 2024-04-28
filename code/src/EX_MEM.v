module EX_MEM
(
    input          clk_i,
    input          rst_i,
    input          EX_RegWrite_i,
    input          EX_MemtoReg_i,
    input          EX_MemRead_i,
    input          EX_MemWrite_i,
    input [31:0]   EX_ALUOut_i,
    input [31:0]   EX_RS2data_i,
    input [4:0]    EX_RDaddr_i,
    output         MEM_RegWrite_o,
    output         MEM_MemtoReg_o,
    output         MEM_MemRead_o,
    output         MEM_MemWrite_o,
    output [31:0]  MEM_ALUOut_o,
    output [31:0]  MEM_RS2data_o,
    output [4:0]   MEM_RDaddr_o
);

reg         EX_MEM_RegWrite;
reg         EX_MEM_MemtoReg;
reg         EX_MEM_MemRead;
reg         EX_MEM_MemWrite;
reg [31:0]  EX_MEM_ALUOut;
reg [31:0]  EX_MEM_RS2data;
reg [4:0]   EX_MEM_RDaddr;

assign MEM_RegWrite_o = EX_MEM_RegWrite;
assign MEM_MemtoReg_o = EX_MEM_MemtoReg;
assign MEM_MemRead_o = EX_MEM_MemRead;
assign MEM_MemWrite_o = EX_MEM_MemWrite;
assign MEM_ALUOut_o = EX_MEM_ALUOut;
assign MEM_RS2data_o = EX_MEM_RS2data;
assign MEM_RDaddr_o = EX_MEM_RDaddr;

always @ (posedge clk_i or negedge rst_i) 
begin
    if (!rst_i) 
    begin
        EX_MEM_RegWrite <= 1'b0;
        EX_MEM_MemtoReg <= 1'b0;
        EX_MEM_MemRead <= 1'b0;
        EX_MEM_MemWrite <= 1'b0;
        EX_MEM_ALUOut <= 32'b0;
        EX_MEM_RS2data <= 32'b0;
        EX_MEM_RDaddr <= 4'b0;
    end 
    else 
    begin
        EX_MEM_RegWrite <= EX_RegWrite_i;
        EX_MEM_MemtoReg <= EX_MemtoReg_i;
        EX_MEM_MemRead <= EX_MemRead_i;
        EX_MEM_MemWrite <= EX_MemWrite_i;
        EX_MEM_ALUOut <= EX_ALUOut_i;
        EX_MEM_RS2data <= EX_RS2data_i;
        EX_MEM_RDaddr <= EX_RDaddr_i;
    end
end
endmodule