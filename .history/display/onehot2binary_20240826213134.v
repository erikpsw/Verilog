module onehot2binary(clk,onehot,binary,tries_out);
  
    input clk;
    input [15:0] onehot;

    output reg [3:0] binary;

    always@(posedge clk) begin //如果没有按键按下 onehot不动,则输出数据保持
            
        if (tries < 4'h5) begin
            tries_out <= tries + 1;
        end else begin
            tries_out <= 0; // 根据需要进行复位
        end
        case(onehot) //编码器
            // 16'h0001 : binary <= 4'b0000;
            // 16'h0002 : binary <= 4'b0001;
            // 16'h0004 : binary <= 4'b0010;
            16'h0008 : binary <= 4'b0000; //0
            // 16'h0010 : binary <= 4'b0100;
            16'h0020 : binary <= 4'b0011; //3
            16'h0040 : binary <= 4'b0010; //2
            16'h0080 : binary <= 4'b0001; //1
            // 16'h0100 : binary <= 4'b1000;    
            16'h0200 : binary <= 4'b0110; //6
            16'h0400 : binary <= 4'b0101; //5
            16'h0800 : binary <= 4'b0100; //4
            // 16'h1000 : binary <= 4'b1100;
            16'h2000 : binary <= 4'b1001; //9
            16'h4000 : binary <= 4'b1000; //8
            16'h8000 : binary <= 4'b0111; //7
        endcase
    end
endmodule