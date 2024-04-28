module Imm_Gen
(
    input wire [31:0] instr_i,
    output reg [31:0] imm_o
);

wire [6:0] opcode;
wire [2:0] funct3;
assign opcode = instr_i[6:0];
assign funct3 = instr_i[14:12];

always @(*) 
begin
    case(opcode)
        7'b0010011:
            if (funct3 == 3'b101) 
            begin
                imm_o = {{27{instr_i[24]}}, instr_i[24:20]};
            end
            else 
            begin
                imm_o = {{20{instr_i[31]}}, instr_i[31:20]};
            end
        7'b0000011: imm_o = {{20{instr_i[31]}}, instr_i[31:20]};
        7'b0100011: imm_o = {{20{instr_i[31]}}, {instr_i[31:25], instr_i[11:7]}};
        7'b1100011: imm_o = {{21{instr_i[31]}}, {instr_i[7], instr_i[30:25], instr_i[11:8]}};
        default: imm_o = 32'b0; 
    endcase
end
endmodule