module top_module ( input clk, input d, output q );
    wire q1,q2;
    my_dff8 b1(clk,d,q1);
    my_dff8 b2(clk,q1,q2);
    my_dff8 b3(clk,q2,q);
endmodule
