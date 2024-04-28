module Hazard_Detection
(
    input       EX_MemRead_i,
    input [4:0] EX_RDaddr_i,
    input [4:0] ID_RS1addr_i,
    input [4:0] ID_RS2addr_i,
    output reg  PCWrite_o,
    output reg  Stall_o,
    output reg  NoOp_o
);

always @(*) 
begin
    if (EX_MemRead_i && (EX_RDaddr_i == ID_RS1addr_i || EX_RDaddr_i == ID_RS2addr_i)) 
    begin
        PCWrite_o = 1'b0;
        Stall_o = 1'b1;
        NoOp_o = 1'b1;
    end 
    else 
    begin
        PCWrite_o = 1'b1;
        Stall_o = 1'b0;
        NoOp_o = 1'b0;
    end
end
endmodule