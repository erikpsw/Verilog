`default_nettype none
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   ); 
    wire w1,w2;
    assign w1=a&b,w2=c&d;
    assign out=
endmodule
