module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire count;
    add16 add1(a[15:0],b[15:0],cin:0,sum[15:0],count);

endmodule
