module IF_ID(
    input         clk_i,
    input         rst_i,
    input         flush_i,
    input         stall_i,
    input  [31:0] instr_i,
    input  [31:0] PC_i,
    input  [31:0] PC_next_i,
    output [31:0] instr_o,
    output [31:0] PC_o,
    output [31:0] PC_next_o
);

reg [31:0] instr_reg;
reg [31:0] PC_reg;
reg [31:0] PC_next_reg;
assign instr_o = instr_reg;
assign PC_o = PC_reg;
assign PC_next_o = PC_next_reg;

always @ (posedge clk_i or negedge rst_i) begin
    if (~rst_i | flush_i) 
    begin
        instr_reg <= 32'b0;
        PC_reg <= 32'b0;
        PC_next_reg <= 32'b0;
    end
    else if (stall_i) 
    begin
        instr_reg <= instr_reg;
        PC_reg <= PC_reg;
        PC_next_reg <= PC_next_reg;
    end
    else 
    begin
        instr_reg <= instr_i;
        PC_reg <= PC_i;
        PC_next_reg <= PC_next_i;
    end
end 

endmodule