module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    add16 add1(a[15:0],b[15:0],0)

endmodule
