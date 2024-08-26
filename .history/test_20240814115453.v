module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire count,count2,count3;
    add16 add1(a[15:0],b[15:0],0,sum[15:0],count);
    add16 add2(a[31:16],b[31:16],count,sum[31:16],count2);
    add16 add3(a[31:16],b[31:16],count,sum[31:16],count2);
endmodule
