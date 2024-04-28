module ID_EX
(
    input         clk_i,
    input         rst_i,
    input         ID_RegWrite_i,
    input         ID_MemtoReg_i,
    input         ID_MemRead_i,
    input         ID_MemWrite_i,
    input  [1:0]  ID_ALUOp_i,
    input         ID_ALUSrc_i,
    input  [31:0] ID_RS1data_i,
    input  [31:0] ID_RS2data_i,
    input  [31:0] ID_imm_i,
    input  [2:0]  ID_func3_i,
    input  [6:0]  ID_func7_i,
    input  [4:0]  ID_RS1addr_i,
    input  [4:0]  ID_RS2addr_i,
    input  [4:0]  ID_RDaddr_i,
    output        EX_RegWrite_o,
    output        EX_MemtoReg_o,
    output        EX_MemRead_o,
    output        EX_MemWrite_o,
    output [1:0]  EX_ALUOp_o,
    output        EX_ALUSrc_o,
    output [31:0] EX_RS1data_o,
    output [31:0] EX_RS2data_o,
    output [31:0] EX_imm_o,
    output [2:0]  EX_func3_o,
    output [6:0]  EX_func7_o,
    output [4:0]  EX_RS1addr_o,
    output [4:0]  EX_RS2addr_o,
    output [4:0]  EX_RDaddr_o,

    input         flush_i,
    input         ID_Branch_i,
    input         ID_Predict_Branch_i,
    input [31:0]  ID_PC_next_i,
    input [31:0]  ID_PC_branch_i,
    output        Branch_o,
    output        EX_Predict_Branch_o,
    output [31:0] EX_PC_next_o,
    output [31:0] EX_PC_branch_o
);

reg         ID_EX_RegWrite;
reg         ID_EX_MemtoReg;
reg         ID_EX_MemRead;
reg         ID_EX_MemWrite;
reg [1:0]   ID_EX_ALUOp;
reg         ID_EX_ALUSrc;
reg [31:0]  ID_EX_RS1data;
reg [31:0]  ID_EX_RS2data;
reg [31:0]  ID_EX_imm;
reg [2:0]   ID_EX_func3;
reg [6:0]   ID_EX_func7;
reg [4:0]   ID_EX_RS1addr;
reg [4:0]   ID_EX_RS2addr;
reg [4:0]   ID_EX_RDaddr;

reg         ID_EX_Branch;
reg         ID_EX_Predict_Branch;
reg [31:0]  ID_EX_PC_next;
reg [31:0]  ID_EX_PC_branch;

assign EX_ALUOp_o = ID_EX_ALUOp;
assign EX_ALUSrc_o = ID_EX_ALUSrc;
assign EX_MemRead_o = ID_EX_MemRead;
assign EX_MemWrite_o = ID_EX_MemWrite;
assign EX_RegWrite_o = ID_EX_RegWrite;
assign EX_MemtoReg_o = ID_EX_MemtoReg;
assign EX_imm_o = ID_EX_imm;
assign EX_func3_o = ID_EX_func3;
assign EX_func7_o = ID_EX_func7;
assign EX_RDaddr_o = ID_EX_RDaddr;
assign EX_RS1data_o = ID_EX_RS1data;
assign EX_RS2data_o = ID_EX_RS2data;
assign EX_RS1addr_o = ID_EX_RS1addr;
assign EX_RS2addr_o = ID_EX_RS2addr;
assign Branch_o = ID_EX_Branch;
assign EX_Predict_Branch_o = ID_EX_Predict_Branch;
assign EX_PC_next_o = ID_EX_PC_next;
assign EX_PC_branch_o = ID_EX_PC_branch;

// initial begin
//     ID_EX_ALUOp = 2'b0;
//     ID_EX_ALUSrc = 1'b0;
//     ID_EX_MemRead = 1'b0;
//     ID_EX_MemWrite = 1'b0;
//     ID_EX_RegWrite = 1'b0;
//     ID_EX_MemtoReg = 1'b0;
//     ID_EX_imm = 32'b0;
//     ID_EX_func3 = 3'b0;
//     ID_EX_func7 = 7'b0;
//     ID_EX_RDaddr = 5'b0;
//     ID_EX_RS1data = 32'b0;
//     ID_EX_RS2data = 32'b0;
//     ID_EX_RS1addr = 5'b0;
//     ID_EX_RS2addr = 5'b0;
//     ID_EX_Branch = 1'b0;
//     ID_EX_Predict_Branch = 1'b0;
// end

always @ (posedge clk_i or negedge rst_i) begin
    if (~rst_i | flush_i) 
    begin
        ID_EX_ALUOp <= 2'b11;
        ID_EX_ALUSrc <= 1'b0;
        ID_EX_MemRead <= 1'b0;
        ID_EX_MemWrite <= 1'b0;
        ID_EX_RegWrite <= 1'b0;
        ID_EX_MemtoReg <= 1'b0;
        ID_EX_imm <= 32'b0;
        ID_EX_func3 <= 3'b0;
        ID_EX_func7 <= 7'b0;
        ID_EX_RDaddr <= 5'b0;
        ID_EX_RS1data <= 32'b0;
        ID_EX_RS2data <= 32'b0;
        ID_EX_RS1addr <= 5'b0;
        ID_EX_RS2addr <= 5'b0;
        ID_EX_Branch <= 1'b0;
        ID_EX_Predict_Branch <= 1'b0;
        ID_EX_PC_next <= 32'b0;
        ID_EX_PC_branch <= 32'b0;

    end 
    else 
    begin
        ID_EX_ALUOp <= ID_ALUOp_i;
        ID_EX_ALUSrc <= ID_ALUSrc_i;
        ID_EX_MemRead <= ID_MemRead_i;
        ID_EX_MemWrite <= ID_MemWrite_i;
        ID_EX_RegWrite <= ID_RegWrite_i;
        ID_EX_MemtoReg <= ID_MemtoReg_i;
        ID_EX_imm <= ID_imm_i;
        ID_EX_func3 <= ID_func3_i;
        ID_EX_func7 <= ID_func7_i;
        ID_EX_RDaddr <= ID_RDaddr_i;
        ID_EX_RS1data <= ID_RS1data_i;
        ID_EX_RS2data <= ID_RS2data_i;
        ID_EX_RS1addr <= ID_RS1addr_i;
        ID_EX_RS2addr <= ID_RS2addr_i;
        ID_EX_Branch <= ID_Branch_i;
        ID_EX_Predict_Branch <= ID_Predict_Branch_i;
        ID_EX_PC_next <= ID_PC_next_i;
        ID_EX_PC_branch <= ID_PC_branch_i;

    end
end


endmodule