module onehot2binary(clk,onehot,binary,cur_binary,times);
  
    input clk;
    input [15:0] onehot;

    output reg [11:0] binary=12'b111111111111;
    output reg [3:0] cur_binary=4'b1111;
    output reg times; 
    reg [3:0]pv_binary;
    

    always@(posedge clk) begin //如果没有按键按下 onehot不动,则输出数据保持
            
        pv_binary<=cur_binary;
        case(onehot) //编码器
            // 16'h0001 : binary <= 4'b0000;
            // 16'h0002 : binary <= 4'b0001;
            // 16'h0004 : binary <= 4'b0010;
            16'h0008 : cur_binary <= 4'b0000; //0
            // 16'h0010 : binary <= 4'b0100;
            16'h0020 : cur_binary <= 4'b0011; //3
            16'h0040 : cur_binary <= 4'b0010; //2
            16'h0080 : cur_binary <= 4'b0001; //1
            // 16'h0100 : binary <= 4'b1000;    
            16'h0200 : cur_binary <= 4'b0110; //6
            16'h0400 : cur_binary <= 4'b0101; //5
            16'h0800 : cur_binary <= 4'b0100; //4
            // 16'h1000 : binary <= 4'b1100;
            16'h2000 : cur_binary <= 4'b1001; //9
            16'h4000 : cur_binary <= 4'b1000; //8
            16'h8000 : cur_binary <= 4'b0111; //7
            default: cur_binary <= 4'b1111;
        endcase
        
        if(pv_binary!=cur_binary) begin
            case (times)
            0: binary[3:0]<=cur_binary[3:0];
            1: binary[7:4]<=cur_binary[3:0];
            2: binary[11:8]<=cur_binary[3:0];
            default: binary[11:0]<=binary[11:0];
            endcase
            if (times < 4'b0011) begin
            times <= times + 4'b0001;
            end
        end
        

    end

endmodule