module Led_effect (
      clk_50M,   
     switch,     
    leds     
);
    input clk_50M; 
    input switch; 
    output reg [6:0] leds;

    reg [31:0] clk_divider = 0; 
    reg slow_clk = 0;          
    reg [3:0] counter = 0;     
    reg direction = 0;         
    always @(posedge clk_50M) begin
        clk_divider <= clk_divider + 1;
        if (clk_divider == 2500000) begin  
            clk_divider <= 0;
            slow_clk <= ~slow_clk; 
        end
    end

    always @(posedge slow_clk) begin
        if (!switch) begin
            leds <= 7'b0000000;  
        end else begin
            if (direction == 0) begin
                leds <= 7'b0000001 << counter;  
                counter <= counter + 1;
                if (counter == 6) begin
                    direction <= 1;  
                end
            end else begin
                leds <= 7'b0000001 << counter;
                counter <= counter - 1;
                if (counter == 0) begin
                    direction <= 0;  // Change direction to forward
                end
            end
        end
    end

endmodule
