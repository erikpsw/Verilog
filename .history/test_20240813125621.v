module top_module (
    input a, b, c, d, e,
    output [24:0] out );//

    assign out = ~{ {5{a}} } ^ { {a,b,c,d,e} };

endmodule
