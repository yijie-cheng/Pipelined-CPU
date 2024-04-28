module Forwarding_Unit
(
    input      [4:0] EX_RS1addr_i,
    input      [4:0] EX_RS2addr_i,
    input      [4:0] MEM_RDaddr_i,
    input            MEM_RegWrite_i,
    input      [4:0] WB_RDaddr_i,
    input            WB_RegWrite_i,
    output reg [1:0] select_A_o,
    output reg [1:0] select_B_o
);

initial 
begin
    select_A_o = 2'b00;
    select_B_o = 2'b00;
end

always @(*) 
begin
    if (MEM_RegWrite_i && MEM_RDaddr_i != 0 && (EX_RS1addr_i == MEM_RDaddr_i)) 
    begin
        select_A_o = 2'b10;  
    end
    else if (WB_RegWrite_i &&  WB_RDaddr_i != 0 && !(MEM_RegWrite_i && MEM_RDaddr_i != 0 && EX_RS1addr_i == MEM_RDaddr_i) && WB_RDaddr_i == EX_RS1addr_i) 
    begin
        select_A_o = 2'b01;
    end
    else 
    begin
        select_A_o = 2'b00;
    end

    if (MEM_RegWrite_i && MEM_RDaddr_i != 0 && (EX_RS2addr_i == MEM_RDaddr_i)) 
    begin
        select_B_o = 2'b10;  
    end
    else if (WB_RegWrite_i && WB_RDaddr_i != 0 && !(MEM_RegWrite_i && MEM_RDaddr_i != 0 && EX_RS2addr_i == MEM_RDaddr_i) && WB_RDaddr_i == EX_RS2addr_i) 
    begin
        select_B_o = 2'b01;
    end
    else 
    begin
        select_B_o = 2'b00;
    end
end
endmodule