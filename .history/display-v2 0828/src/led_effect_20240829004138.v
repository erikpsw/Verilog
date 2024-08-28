module Led_effect (
      clk_50M,   
     switch,     
    leds     
);
    input clk_50M; 
    input switch; 
    output reg [6:0] leds;
    reg [26:0] counter = 0;     
    reg direction = 0;         

    always @(posedge clk_50M) begin
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
                    direction <= 0;  
                end
            end
        end
    end

endmodule
