module onehot2binary(clk,onehot,binary,times,tries,secrect,buzzer,switch);
  
    input clk;
    input [15:0] onehot;
    output reg[11:0] binary=12'b111111111111;
    output reg [1:0] times=2'b00;
    output reg [4:0] tries=4'h0;
    output reg [11:0]secrect=12'b001001000110;
    output reg buzzer; 
    output reg switch;

    reg [3:0] cur_binary=4'b1111;
    reg [3:0] pv_binary=4'b1111;
    reg [31:0] buzzer_counter;   // 计时器寄存器
    reg [31:0] buzzer_counter2;   // 计时器寄存器
    reg buzzer_active=0;   
    reg buzzer_success=0;          // 蜂鸣器激活状态
    reg buzzer_fail=0;   // 蜂鸣器报错
    reg start_conut=0;
    reg buzzer_count=0;
    reg [3:0]wrong_times=4'b0000;
    reg is_set=0;
    reg [25:0] clk_div_counter; 
    
	always @(posedge clk) begin

       if(start_conut) begin
        if (clk_div_counter == 26'd49_999_999) begin  // 50 cycles at 50 Hz = 1 second
            clk_div_counter <= 26'b0;  // Reset the clock divider counter

            if (binary[7:0] == 8'b0) begin  // Check if the upper nibble is 6 (minutes tens place)
                start_conut <= 0;  // Stop counting
                binary[11:0] = 12'b111111111111;  // Reset counter after reaching 60
            end 
            else if (binary[3:0] == 4'b0000) begin  // If lower nibble is 9 (seconds units place)
                binary[7:4] = binary[7:4] - 1;  // Increment upper nibble (seconds tens place)
                binary[3:0] = 4'b1001;  // Reset lower nibble to 0
                buzzer_count <= 1;
                buzzer_counter <= 0;
                buzzer_counter2 <= 0;
                buzzer <= 1;   
            end
            else begin
                binary[3:0] = binary[3:0] - 1;  // Increment lower nibble (seconds units place)
                buzzer_count <= 1;
                buzzer_counter <= 0;
                buzzer_counter2 <= 0;
                buzzer <= 1;   
            end
        end 
        else begin
            clk_div_counter <= clk_div_counter + 1;  // Increment clock divider counter
        end
    end

            if (buzzer_active) begin
                // 计时器计时
                buzzer_counter2<=buzzer_counter2+1;
                buzzer_counter<=buzzer_counter+1;
                if (buzzer_counter2 >= 50000) begin  // 通过调整计数值来控制翻转频率，例如50000
                buzzer <= ~buzzer;  // 翻转蜂鸣器信号
                buzzer_counter2 <= 0;  // 重置计数器
            end
            if (buzzer_counter >= 10000000) begin  // 假设50MHz时钟，计时1秒
                buzzer_active <= 0;
                buzzer <= 0;
            end
        end 
        else if (buzzer_success) begin
                // 计时器计时
                buzzer_counter2<=buzzer_counter2+1;
                buzzer_counter<=buzzer_counter+1;
                if (buzzer_counter2 >= 25000) begin  
                buzzer <= ~buzzer;  
                buzzer_counter2 <= 0;  
            end
            if (buzzer_counter >= 30000000) begin  
                buzzer_success <= 0;
                buzzer <= 0;
            end
        end
      
        else if (buzzer_fail) begin
                // 计时器计时
                buzzer_counter2<=buzzer_counter2+1;
                buzzer_counter<=buzzer_counter+1;
                if (buzzer_counter2 >= 100000) begin  // 通过调整计数值来控制翻转频率，例如50000
                buzzer <= ~buzzer;  // 翻转蜂鸣器信号
                buzzer_counter2 <= 0;  // 重置计数器
            end
            if (5000000<buzzer_counter&& buzzer_counter< 10000000) begin  // 假设50MHz时钟，计时1秒
                buzzer <= 0;
            end
            if (buzzer_counter >= 15000000) begin  // 假设50MHz时钟，计时1秒
                buzzer_fail <= 0;
                buzzer <= 0;
            end
        end
         else if (buzzer_count) begin
                // 计时器计时
                buzzer_counter2<=buzzer_counter2+1;
                buzzer_counter<=buzzer_counter+1;
                if (buzzer_counter2 >= 100000) begin  // 通过调整计数值来控制翻转频率，例如50000
                buzzer <= ~buzzer;  // 翻转蜂鸣器信号
                buzzer_counter2 <= 0;  // 重置计数器
            end
            if (buzzer_counter >= 5000000) begin  // 假设50MHz时钟，计时1秒
                buzzer_count <= 0;
                buzzer <= 0;
            end
        end
        else begin
            buzzer <= 0;
        end
            
        pv_binary <=cur_binary;
        
     if(binary==12'b101111001100)   
		if(onehot==16'h0100)
           binary=12'b111111111111; 
     if(binary!=12'b101111001100&& !start_conut)    
    //如果没有按键按下 onehot不动,则输出数据保持
        case(onehot) //编码器
            16'h0001 : begin
                if (times == 2'b11)begin
                    if(binary==secrect && !is_set)begin //输入密码正确，屏幕显示PASS
                        switch<=1;
                        binary=12'b101111001100; //binary='ASS'
                        buzzer_success <= 1;
                        buzzer_counter <= 0;
                        buzzer_counter2 <= 0;
                        buzzer <= 1;   
                        times=0;   
                    end
                    else if (is_set)begin
                        secrect=binary;
                        is_set=0;
                        binary=12'b111111111111;
                        tries=0;
                        times=0;
                        buzzer_success<=1;
                    end
                    else if(binary!=secrect)begin//输入密码错误，不显示
                    	binary=12'b111111111111;
                    	times=2'b00;
                    	tries=tries+1;
                        buzzer_fail <= 1;
                        buzzer_counter <= 0;
                        buzzer_counter2 <= 0;
                        buzzer <= 1;      
                        if(tries==4'h3)begin  //次数达到六次，显示0000
                            wrong_times=wrong_times+1;
                        	case (wrong_times)
                                4'b0001: binary=12'b000000000101;
                                4'b0010: binary=12'b000000010000;
                                4'b0011: binary=12'b000000100000;
                                default: binary=12'b000001100000;
                            endcase
                            start_conut<=1;
                            tries<=0;
                        end
                        // 激活蜂鸣器
					end
                    
                end
                end // enter
            // 16'h0002 : binary <= 4'b0001;
            // 16'h0004 : binary <= 4'b0010;
            16'h0008 : cur_binary <= 4'b0000; //0
            16'h0010 : begin
                binary[11:0]={3{4'hd}};
                is_set=1;
                times=0;
                tries=4'b1111;
                // binary[3:0]=4'b0011;
            end
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
            16'h1000 : cur_binary <= 4'b1110; // back
            16'h2000 : cur_binary <= 4'b1001; //9
            16'h4000 :
            begin
                binary=12'b000000000000; //8
                tries=0;
                buzzer_fail<=1;
            end 
                
            16'h8000 : cur_binary <= 4'b0111; //7
            16'h0000 : cur_binary <= 4'b1111; //none
        endcase
        
        if(pv_binary !=cur_binary)begin 

        buzzer_active <= 1;
        buzzer_counter <= 0;
        buzzer_counter2 <= 0;
        buzzer <= 1;   
        if(cur_binary!=4'b1111 &&binary!=12'b0 &&cur_binary!=4'b1110) begin
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
        else if(cur_binary==4'b1110 &&binary!=12'b0)begin
        case (times)
                2'b01:begin
                    binary=12'b111111111111;
                    times=2'b00;
                end  
                2'b10:begin
                    binary[3:0]=binary[7:4];
                    binary[7:4]=4'b1111;
                    times=2'b01;
                end  
                2'b11:begin
                    binary[3:0]=binary[7:4];
                    binary[7:4]=binary[11:8];
                    binary[11:8]=4'b1111;
                    times=2'b10;
                end  
            endcase
        end
     end   
    end
endmodule