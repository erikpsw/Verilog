module top_module (    input clk, 
    input [7:0] d, 
    input [1:0] sel, 
    output [7:0] q );
    wire q1,q2;
    my_dff8 b1(clk,d,q1);
    my_dff8 b2(clk,q1,q2);
    my_dff8 b3(clk,q2,q);
    always @(*) begin
        case(sel)
			2'b00: q = d;
			2'b01: q = q1;
			2'b10: q = q2;
			2'b11: q = c;
		endcase
    end
endmodule
