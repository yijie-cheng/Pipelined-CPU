module ALU
(
    input [31:0] data1_i,
    input [31:0] data2_i,
    input [2:0] opcode_i,
    output reg [31:0] data_o,
    output reg zero_o
);

always @(*) begin
    case (opcode_i)
        3'b111: data_o = data1_i & data2_i; //and
        3'b100: data_o = data1_i ^ data2_i; //xor
        3'b001: data_o = data1_i << data2_i; //sll
        3'b000: data_o = data1_i + data2_i; //add
        3'b010: data_o = data1_i - data2_i; //sub
        3'b011: data_o = data1_i * data2_i; //mul
        3'b101: data_o = data1_i >> data2_i[4:0]; //srai
        3'b110: data_o = 32'b0;
    endcase
    if(data_o == 32'b0)
    begin
        zero_o = 1'b1;
    end 
    else 
    begin 
        zero_o = 1'b0;
    end
end
endmodule
