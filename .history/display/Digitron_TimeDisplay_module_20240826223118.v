module Digitron_TimeDisplay_module
(
	CLK, data, tries,Digitron_Out,DigitronCS_Out
);
	 input CLK;
	 input [3:0]data;
	 input [7:0]tries;
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
			4'b1101: SingleNum = data;
			4'b1011: SingleNum = data;
			4'b0111: SingleNum = tries;	
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
            	default :W_Digitron_Out = 8'h00;
			endcase
	 end
	 
	 assign Digitron_Out = W_Digitron_Out;
	 assign DigitronCS_Out = W_DigitronCS_Out;
	 
endmodule