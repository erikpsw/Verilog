module keyboard_instance(clk_50M,buzzer,RSTn,col,row,Digitron_Out,DigitronCS_Out,light,leds);
    
    input clk_50M;
    input RSTn ;// SW0
    input [3:0] col;
    output [3:0] row;
    output [7:0] Digitron_Out;
    output [3:0] DigitronCS_Out;
    output light;
    output buzzer;
    output [6:0] leds;
    
    wire [15:0] key;

    keyboard_scan U1(
        .clk(clk_50M),
        .RSTn(RSTn),
        .col(col),
        .row(row),
        .light(light),
        .key(key)
    );
    
    wire [15:0] key_deb;
    key_filter U2(
        .clk(clk_50M),
        .RSTn(RSTn),
        .key_in(key),
        .key_deb(key_deb)
    );
     
    wire [11:0] data_disp; 
    wire [3:0] tries; 
    wire [1:0] times;

    onehot2binary U3(
        .clk(clk_50M),
        .onehot(key_deb),
        .binary(data_disp),
        .times(times),
        .tries(tries),
        .buzzer(buzzer),
        .secrect(secrect)
    );	    
        
    
    Digitron_TimeDisplay_module U5
    (
    	.CLK(clk_50M), 
    	.data(data_disp), 
        .secrect(secrect),
    	.Digitron_Out(Digitron_Out), 
    	.DigitronCS_Out(DigitronCS_Out),
        .times(times),
        .tries(tries)
    );

    Led_effect U6
    (
        .clk_50M(clk_50M),
        .leds(leds)
    );

endmodule

