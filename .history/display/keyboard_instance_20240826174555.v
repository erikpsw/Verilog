module keyboard_instance(clk_50M,RSTn,col,light,row,Digitron_Out_1,Digitron_Out_4,DigitronCS_Out);
    
    input clk_50M;
    input RSTn ;// SW0
    input [3:0] col;
    output light;
    output [3:0] row;
    output [7:0] Digitron_Out_1;
    output [7:0] Digitron_Out_4;
    output [3:0] DigitronCS_Out;
    
    reg [7:0]tries;
    wire [15:0] key;
  
    keyboard_scan U1(
        .clk(clk_50M),
        .RSTn(RSTn),
        .col(col),
        .light(light),
        .row(row),
        .key(key)
    );
    
    wire [15:0] key_deb;
    key_filter U2(
        .clk(clk_50M),
        .rstn(RSTn),
        .key_in(key),
        .key_deb(key_deb)
    );
     
    wire [3:0] data_disp;  
    onehot2binary U3(
        .clk(clk_50M),
        .onehot(key_deb),
        .binary(data_disp),
        .tries(tries)
    );	    
        
    
    Digitron_TimeDisplay_module U5
    (
    	.CLK(clk_50M), 
    	.data(data_disp), 
        .tries(tries)
    	.Digitron_Out(Digitron_Out), 
    	.DigitronCS_Out_1(DigitronCS_Out_1),
        .DigitronCS_Out_4(DigitronCS_Out_4)
    );
    
    
endmodule

