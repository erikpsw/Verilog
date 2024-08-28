module Digitron_TimeDisplay_module
(
	CLK,times,data,tries, Digitron_Out, DigitronCS_Out
);
	 input CLK;
	 input [1:0]times;
	 input [11:0]data;	
	 input [3:0]tries;	
	 output [7:0]Digitron_Out; 
	 output [3:0]DigitronCS_Out; 

     parameter T1MS = 16'd50000;
	 reg [17:0]Count;
	 reg [3:0]SingleNum;
	 reg [7:0]W_Digitron_Out;
	 reg [7:0]W_DigitronCS_Out;
	 reg cnt ;
     parameter _0 = 8'b0011_1111, _1 = 8'b0000_0110, _2 = 8'b0101_1011,
			 	  _3 = 8'b0100_1111, _4 = 8'b0110_0110, _5 = 8'b0110_1101,
			 	  _6 = 8'b0111_1101, _7 = 8'b0000_0111, _8 = 8'b0111_1111,
				  _9 = 8'b0110_1111, _Ri= 8'b0111_1111;
				 	
	
	always @ ( posedge CLK )
		Count <= Count+1'b1;				
			
	 always@(Count[17:16])   //片选不同的数码
	 begin
			case (Count[17:16])			//所以时钟需要跳2的16次方
			2'b00:
				W_DigitronCS_Out = 4'b1110 ;
			2'b01:
				W_DigitronCS_Out = 4'b1101 ;		
			2'b10:
				W_DigitronCS_Out = 4'b1011 ;
			2'b11:
				W_DigitronCS_Out = 4'b0111 ;	
			endcase
	 end
	 
	 always@(W_DigitronCS_Out)
	 begin

			case(W_DigitronCS_Out)
			4'b1110: SingleNum = data[3:0];
			4'b1101: SingleNum = data[7:4];
			4'b1011: SingleNum = data[11:8];
			4'b0111: if(data==12'b101111001100) //输入密码正确，显示PASS
                        SingleNum = 4'ha;
            		 else if(data!=12'b101111001100) //输入密码错误
                     	if(tries<4'h6)   //次数小于六次，显示次数
            				SingleNum = tries;	
                     	else if(tries>=4'h6)  //次数等于六次，显示0000
                     		SingleNum = 4'h0;
			endcase						
			case(SingleNum)
            	4'h0 : W_Digitron_Out = 8'h3f;
            	4'h1 : W_Digitron_Out = 8'h06;	
            	4'h2 : W_Digitron_Out = 8'h5b;
            	4'h3 : W_Digitron_Out = 8'h4f;
            	4'h4 : W_Digitron_Out = 8'h66;
            	4'h5 : W_Digitron_Out = 8'h6d;
            	4'h6 : W_Digitron_Out = 8'h7d;
            	4'h7 : W_Digitron_Out = 8'h07;
            	4'h8 : W_Digitron_Out = 8'h7f;
            	4'h9 : W_Digitron_Out = 8'h6f;
                4'ha : W_Digitron_Out = 8'h73; //显示P
                4'hb : W_Digitron_Out = 8'h77; //显示A
                4'hc : W_Digitron_Out = 8'h6d; //显示S
				4'hd : W_Digitron_Out = 8'h40; //显示S
            	default : W_Digitron_Out = 8'h00;
			endcase
	 end
	 
	 assign Digitron_Out = W_Digitron_Out;
	 assign DigitronCS_Out = W_DigitronCS_Out;
	 
endmodule