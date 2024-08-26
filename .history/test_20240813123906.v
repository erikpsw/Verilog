module top_module( 
    input [7:0] in,
    output [7:0] out
);
    integer i;
    always@(*)begin
        for(i = 0; i <= 7; i = i + 1)begin
            out[i] = in[7-i];
        end
    end
endmodule
