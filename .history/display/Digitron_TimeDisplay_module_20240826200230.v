module Digitron_TimeDisplay_module
(
	CLK, data, tries,Digitron_Out_1,W_Digitron_Out
);
	 input CLK;
	 input [3:0]data;
	 input [7:0]tries;
	 output [7:0]Digitron_Out; 
	 output [3:0]DigitronCS_Out; 

     parameter T1MS = 16'd50000;
	 reg [15:0]Count;
	 reg [3:0]SingleNum;
	 reg [7:0]W_Digitron_Out;
	 reg [7:0]W_DigitronCS_Out;
	 reg cnt ;
     parameter _0 = 8'b0011_1111, _1 = 8'b0000_0110, _2 = 8'b0101_1011,
			 	  _3 = 8'b0100_1111, _4 = 8'b0110_0110, _5 = 8'b0110_1101,
			 	  _6 = 8'b0111_1101, _7 = 8'b0000_0111, _8 = 8'b0111_1111,
				  _9 = 8'b0110_1111, _Ri= 8'b0111_1111;
				 	
	
	always @ ( posedge CLK )
		begin
			if( Count == T1MS )
			begin
				Count <= 16'd0 ;
			  if(cnt == 1'b0)
					cnt <= 1'b1;
			  else 
					cnt <= 1'b0;					

			end
			else
				Count <= Count+1'b1;				
	end
			
	 always@(cnt)   //片选不同的数码
	 begin
			case (cnt)			
			1'b0:
				W_DigitronCS_Out = 4'b1110 ;
			1'b1:
				W_DigitronCS_Out = 4'b1110 ;			
			endcase
	 end
	 
	 always@(W_DigitronCS_Out)
	 begin

			case(W_DigitronCS_Out)
			4'b1110: SingleNum = data;
			4'b1110: SingleNum = data;	
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
	 
	 assign Digitron_Out_1 = W_Digitron_Out_1;
	 assign Digitron_Out_4 = W_Digitron_Out_4;
	 assign DigitronCS_Out = W_DigitronCS_Out;
	 
endmodule