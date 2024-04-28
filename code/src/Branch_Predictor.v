module Branch_Predictor (
    input       ifTaken_i,
    input       clk_i,
    input       rst_i,
    input       branch_i,
    output reg  predict_o
);

reg [1:0] state;

initial begin
    state = 2'b11;
    predict_o = 1'b1;
end

always @(posedge clk_i or negedge rst_i) begin
    predict_o = state[1];

    if (branch_i) begin
        case (state)
            2'b00: state = ifTaken_i ? 2'b01 : 2'b00;
            2'b01: state = ifTaken_i ? 2'b10 : 2'b00;
            2'b10: state = ifTaken_i ? 2'b11 : 2'b01;
            2'b11: state = ifTaken_i ? 2'b11 : 2'b10;
        endcase
    end
end

endmodule
