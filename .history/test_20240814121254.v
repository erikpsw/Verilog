module top_module(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] sum
);
    wire carry_out1, carry_out2;
    wire [15:0] sum1, sum2;

    // 前16位相加
    add16 add1(a[15:0], b[15:0], 0, sum[15:0], carry_out1);

    // 后16位相加的两个可能结果
    add16 add2(a[31:16], b[31:16], 0, sum1, carry_out2);
    add16 add3(a[31:16], b[31:16], 1, sum2, carry_out2);

    // 使用always块进行组合逻辑
    always @(*) begin
        case (carry_out1)
            0: sum[31:16] = sum1;
            1: sum[31:16] = sum2;
            default: sum[31:16] = 16'b0; // 处理所有可能情况
        endcase
    end
endmodule
