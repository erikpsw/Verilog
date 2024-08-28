module onehot2binary(clk,onehot,binary,times,tries,buzzer);
  
    input clk;
    input [15:0] onehot;
    output reg[11:0] binary=12'b111111111111;
    output reg [1:0] times=2'b00;
    output reg [4:0] tries=4'h0;
    output reg buzzer; 
    reg [3:0] cur_binary=4'b1111;
    reg [3:0] pv_binary=4'b1111;
    
    reg [31:0] buzzer_counter;   // 计时器寄存器
    reg buzzer_active;           // 蜂鸣器激活状态
    
	always @(posedge clk) begin
        if (!rst_n) begin
        buzzer <= 0;
        buzzer_active <= 0;
        buzzer_counter <= 0;
    end else begin
        if (buzzer_active) begin
            // 计时器计时
            buzzer_counter <= buzzer_counter + 1;
            if (buzzer_counter >= 150000000) begin // 假设50MHz时钟，计时1秒
                buzzer_active <= 0;
                buzzer <= 0;
            end
        end else begin
            buzzer <= 0;
        end
    end
            
        pv_binary <=cur_binary;
    //如果没有按键按下 onehot不动,则输出数据保持
        case(onehot) //编码器
            16'h0001 : begin
                if (times == 2'b11)begin
                    if(binary==12'b001001000110)begin //输入密码(246)正确，屏幕显示PASS
                        binary=12'b101111001100; //binary='ASS'
                    end
                    else if(binary!=12'b101111001100)begin//输入密码错误，不显示
                    	binary=12'b111111111111;
                    	times=2'b00;
                    	tries=tries+1;
                        if(tries==4'h6)begin  //次数达到六次，显示0000
                        	binary=12'b000000000000;
                        end
                        // 激活蜂鸣器
                        buzzer_active <= 1;
                        buzzer_counter <= 0;
                        buzzer <= 1;                   
					end
                end
                end // enter
            // 16'h0002 : binary <= 4'b0001;
            // 16'h0004 : binary <= 4'b0010;
            16'h0008 : cur_binary <= 4'b0000; //0
            // 16'h0010 : binary <= 4'b0100;
            16'h0020 : cur_binary <= 4'b0011; //3
            16'h0040 : cur_binary <= 4'b0010; //2
            16'h0080 : cur_binary <= 4'b0001; //1
            16'h0100 : begin
            		binary=12'b111111111111;
                    times=2'b00;
                    tries=4'b0;  //清除Count次数  
            	end        
            16'h0200 : cur_binary <= 4'b0110; //6
            16'h0400 : cur_binary <= 4'b0101; //5
            16'h0800 : cur_binary <= 4'b0100; //4
            16'h1000 : begin
                    binary=12'b111111111111;
                    times=2'b00;
				end // enter
            16'h2000 : cur_binary <= 4'b1001; //9
            16'h4000 : cur_binary <= 4'b1000; //8
            16'h8000 : cur_binary <= 4'b0111; //7
        endcase
        
        if(pv_binary !=cur_binary)begin 
        case (times)
          2'b00: binary[3:0]=cur_binary;
          2'b01: begin 
              binary[7:4]=binary[3:0];
              binary[3:0]=cur_binary;
          end
          2'b10: begin 
              binary[11:8]=binary[7:4];
              binary[7:4]=binary[3:0];
              binary[3:0]=cur_binary;
          end
        endcase
        if (times < 2'b11) begin
          times <= times + 1;
        end
     end   
    end
endmodule