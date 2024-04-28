module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input      clk_i;
input      rst_i;

// MUX_PC
wire [31:0] PC_result;
wire        ID_FlushIF;
assign ID_FlushIF = (Branch & ID_Predict);
MUX32 MUX_PC
(
    .data1_i    (IF_pc_next),
    .data2_i    (PC_branch),
    .select_i   (ID_FlushIF),
    .data_o     (PC_result)
);

// MUX_FLUSH_PC
wire [31:0] PC_Mux;
wire        PC_Select;
assign PC_Select = (EX_Branch & ~(zero == EX_Predict));
MUX32 MUX_FLUSH_PC
(
    .data1_i    (PC_result),
    .data2_i    (EX_Correct_Branch),
    .select_i   (PC_Select),
    .data_o     (PC_Mux)
);

// PC
wire [31:0] IF_pc;
PC PC
(
    .rst_i      (rst_i),
    .clk_i      (clk_i),
    .PCWrite_i  (PCWrite),
    .pc_i       (PC_Mux),
    .pc_o       (IF_pc)
);

// Add_PC
wire [31:0] IF_pc_next;
Adder Add_PC
(
    .data1_i    (IF_pc),
    .data2_i    (32'd4),
    .data_o     (IF_pc_next)
);

// Instruction_Memory
wire [31:0] IF_instr;
Instruction_Memory Instruction_Memory
(
    .addr_i     (IF_pc), 
    .instr_o    (IF_instr)
);

// IF_ID
wire [31:0] ID_instr;
wire [31:0] ID_pc;
wire [31:0] ID_pc_next;
wire        IF_ID_FlushIF;
assign      IF_ID_FlushIF = (ID_FlushIF | PC_Select);
IF_ID IF_ID
(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .flush_i    (IF_ID_FlushIF),
    .stall_i    (Stall),
    .instr_i    (IF_instr),
    .PC_i       (IF_pc),
    .PC_next_i  (IF_pc_next),
    .instr_o    (ID_instr),
    .PC_o       (ID_pc),
    .PC_next_o  (ID_pc_next)
);

// Adder_branch
wire [31:0] PC_branch;
Adder Adder_branch
(
    .data1_i    (ID_imm << 1),
    .data2_i    (ID_pc),
    .data_o     (PC_branch)
);

// Registers
wire [4:0]  RS1addr;
wire [4:0]  RS2addr;
wire [31:0] ID_RS1data;
wire [31:0] ID_RS2data;
assign RS1addr = ID_instr[19:15];
assign RS2addr = ID_instr[24:20];
Registers Registers
(
    .rst_i      (rst_i),
    .clk_i      (clk_i),
    .RS1addr_i  (RS1addr),
    .RS2addr_i  (RS2addr),
    .RDaddr_i   (WB_RDaddr), 
    .RDdata_i   (RDdata),
    .RegWrite_i (WB_RegWrite), 
    .RS1data_o  (ID_RS1data), 
    .RS2data_o  (ID_RS2data) 
);

// Imm_Gen
wire [31:0] ID_imm;
Imm_Gen Imm_Gen
(
    .instr_i    (ID_instr),
    .imm_o      (ID_imm)
);

// Control
wire [6:0]  opcode;
wire        ID_RegWrite;
wire        ID_MemtoReg;
wire        ID_MemRead;
wire        ID_MemWrite;
wire [1:0]  ID_ALUOp;
wire        ID_ALUSrc;
wire        Branch;
assign opcode = ID_instr[6:0];
Control Control
(
    .opcode_i   (opcode),
    .NoOp_i     (NoOp),
    .RegWrite_o (ID_RegWrite),
    .MemtoReg_o (ID_MemtoReg),
    .MemRead_o  (ID_MemRead),
    .MemWrite_o (ID_MemWrite),
    .ALUOp_o    (ID_ALUOp),
    .ALUSrc_o   (ID_ALUSrc),
    .Branch_o   (Branch)
);

// ID_EX
wire [2:0] ID_func3;
wire [6:0] ID_func7;
wire [4:0] ID_RDaddr;
wire [1:0]  EX_ALUOp;
wire        EX_ALUSrc;
wire        EX_MemRead;
wire        EX_MemWrite;
wire        EX_RegWrite;
wire        EX_MemtoReg;
wire [4:0]  EX_RS1addr;
wire [4:0]  EX_RS2addr;
wire [31:0] EX_imm;
wire [2:0]  EX_func3;
wire [6:0]  EX_func7;
wire [4:0]  EX_RDaddr;
wire [31:0] EX_RS1data;
wire [31:0] EX_RS2data;
wire        EX_Branch;
wire        EX_Predict;
wire [31:0] EX_pc_next;
wire [31:0] EX_pc_branch;
assign ID_func3 = ID_instr[14:12];
assign ID_func7 = ID_instr[31:25];
assign ID_RDaddr  = ID_instr[11:7]; 
ID_EX ID_EX
(
    .clk_i               (clk_i),
    .rst_i               (rst_i),
    .flush_i             (PC_Select),
    .ID_RegWrite_i       (ID_RegWrite),
    .ID_MemtoReg_i       (ID_MemtoReg),
    .ID_MemRead_i        (ID_MemRead),
    .ID_MemWrite_i       (ID_MemWrite),
    .ID_ALUOp_i          (ID_ALUOp),
    .ID_ALUSrc_i         (ID_ALUSrc),
    .ID_RS1data_i        (ID_RS1data),
    .ID_RS2data_i        (ID_RS2data),
    .ID_imm_i            (ID_imm),
    .ID_func3_i          (ID_func3),
    .ID_func7_i          (ID_func7),
    .ID_RS1addr_i        (RS1addr),
    .ID_RS2addr_i        (RS2addr),
    .ID_RDaddr_i         (ID_RDaddr),
    .ID_Branch_i         (Branch),
    .ID_Predict_Branch_i (ID_Predict),
    .ID_PC_next_i        (ID_pc_next),
    .ID_PC_branch_i      (PC_branch),
    .EX_RegWrite_o       (EX_RegWrite),
    .EX_MemtoReg_o       (EX_MemtoReg),
    .EX_MemRead_o        (EX_MemRead),
    .EX_MemWrite_o       (EX_MemWrite),
    .EX_ALUOp_o          (EX_ALUOp),
    .EX_ALUSrc_o         (EX_ALUSrc),
    .EX_RS1data_o        (EX_RS1data),
    .EX_RS2data_o        (EX_RS2data),
    .EX_imm_o            (EX_imm),
    .EX_func3_o          (EX_func3),
    .EX_func7_o          (EX_func7),
    .EX_RS1addr_o        (EX_RS1addr),
    .EX_RS2addr_o        (EX_RS2addr),
    .EX_RDaddr_o         (EX_RDaddr),
    .Branch_o            (EX_Branch),
    .EX_Predict_Branch_o (EX_Predict),
    .EX_PC_next_o        (EX_pc_next),
    .EX_PC_branch_o      (EX_pc_branch)
);

// Hazard_Detection
wire        PCWrite;
wire        Stall;
wire        NoOp;
Hazard_Detection Hazard_Detection
(
    .EX_MemRead_i  (EX_MemRead),
    .EX_RDaddr_i   (EX_RDaddr),
    .ID_RS1addr_i  (RS1addr),
    .ID_RS2addr_i  (RS2addr),
    .PCWrite_o     (PCWrite),
    .Stall_o       (Stall),
    .NoOp_o        (NoOp)
);

// MUX_ALU_A
wire [31:0] MUX_ALU_AOut;
MUX32_4 MUX_ALU_A
(
    .data1_i    (EX_RS1data),
    .data2_i    (RDdata),
    .data3_i    (MEM_ALUOut),
    .data4_i    (32'b0),
    .select_i   (ForwardA),
    .data_o     (MUX_ALU_AOut)
);

// MUX_ALU_B
wire [31:0] MUX_ALU_BOut;
MUX32_4 MUX_ALU_B
(
    .data1_i    (EX_RS2data),
    .data2_i    (RDdata),
    .data3_i    (MEM_ALUOut),
    .data4_i    (32'b0),
    .select_i   (ForwardB),
    .data_o     (MUX_ALU_BOut)
);


// MUX_ALU_Src
wire [31:0] MuxOut;
MUX32 MUX_ALU_Src
(
    .data1_i   (MUX_ALU_BOut),
    .data2_i   (EX_imm),
    .select_i  (EX_ALUSrc),
    .data_o    (MuxOut)
);

// ALU_Control
wire [2:0] ALUCtrl;
ALU_Control ALU_Control
(
    .funct3_i   (EX_func3),
    .funct7_i   (EX_func7),
    .ALUOp_i    (EX_ALUOp),
    .ALUCtrl_o  (ALUCtrl)
);

// ALU
wire [31:0] EX_ALUOut;
wire        zero;
ALU ALU
(
    .data1_i   (MUX_ALU_AOut),
    .data2_i   (MuxOut),
    .opcode_i  (ALUCtrl),
    .data_o    (EX_ALUOut),
    .zero_o    (zero)
);

// EX_MEM
wire        MEM_RegWrite;
wire        MEM_MemtoReg;
wire        MEM_MemRead;
wire        MEM_MemWrite;
wire [31:0] MEM_ALUOut;
wire [31:0] MEM_RS2data;
wire [4:0]  MEM_RDaddr;
EX_MEM EX_MEM
(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .EX_RegWrite_i  (EX_RegWrite),
    .EX_MemtoReg_i  (EX_MemtoReg),
    .EX_MemRead_i   (EX_MemRead),
    .EX_MemWrite_i  (EX_MemWrite),
    .EX_ALUOut_i    (EX_ALUOut),
    .EX_RS2data_i   (MUX_ALU_BOut),
    .EX_RDaddr_i    (EX_RDaddr),
    .MEM_RegWrite_o (MEM_RegWrite),
    .MEM_MemtoReg_o (MEM_MemtoReg),
    .MEM_MemRead_o  (MEM_MemRead),
    .MEM_MemWrite_o (MEM_MemWrite),
    .MEM_ALUOut_o   (MEM_ALUOut),
    .MEM_RS2data_o  (MEM_RS2data),
    .MEM_RDaddr_o   (MEM_RDaddr)
);

// Forwarding_Unit
wire [1:0] ForwardA;
wire [1:0] ForwardB;
Forwarding_Unit Forwarding_Unit
(
    .EX_RS1addr_i   (EX_RS1addr),
    .EX_RS2addr_i   (EX_RS2addr),
    .MEM_RDaddr_i   (MEM_RDaddr),
    .MEM_RegWrite_i (MEM_RegWrite),
    .WB_RDaddr_i    (WB_RDaddr),
    .WB_RegWrite_i  (WB_RegWrite),
    .select_A_o     (ForwardA),
    .select_B_o     (ForwardB)
);

// Data_Memory
wire [31:0] MEM_MemOut;
Data_Memory Data_Memory
(
    .clk_i      (clk_i),
    .addr_i     (MEM_ALUOut),
    .MemRead_i  (MEM_MemRead),
    .MemWrite_i (MEM_MemWrite),
    .data_i     (MEM_RS2data),
    .data_o     (MEM_MemOut)
);

// MEM_WB
wire        WB_RegWrite;
wire        WB_MemtoReg;
wire [31:0] WB_ALUOut;
wire [31:0] WB_MemOut;
wire [4:0]  WB_RDaddr;
MEM_WB MEM_WB
(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .MEM_RegWrite_i (MEM_RegWrite),
    .MEM_MemtoReg_i (MEM_MemtoReg),
    .MEM_ALUOut_i   (MEM_ALUOut),
    .MEM_MemOut_i   (MEM_MemOut),
    .MEM_RDaddr_i   (MEM_RDaddr),
    .WB_RegWrite_o  (WB_RegWrite),
    .WB_MemtoReg_o  (WB_MemtoReg),
    .WB_ALUOut_o    (WB_ALUOut),
    .WB_MemOut_o    (WB_MemOut),
    .WB_RDaddr_o    (WB_RDaddr)
);

// WB_MUX
wire [31:0] RDdata;
MUX32 WB_MUX
(
    .data1_i     (WB_ALUOut),
    .data2_i     (WB_MemOut),
    .select_i    (WB_MemtoReg),
    .data_o      (RDdata)
);

// branch_predictor
wire ID_Predict;
Branch_Predictor branch_predictor
(
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .ifTaken_i   (zero),
    .branch_i    (EX_Branch),
    .predict_o   (ID_Predict)
);

// EX_branch_Mux
wire [31:0] EX_Correct_Branch;
MUX32 EX_branch_Mux
(
    .data1_i     (EX_pc_next),
    .data2_i     (EX_pc_branch),
    .select_i    (zero),
    .data_o      (EX_Correct_Branch)
);
endmodule

