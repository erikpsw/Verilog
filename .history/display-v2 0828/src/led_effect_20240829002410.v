module led_effect (
    input wire clk_50M,       // 50 Hz clock signal
    input wire switch=0,         // Control switch
    output reg [6:0] leds      // 7 LEDs
);

    reg [3:0] counter = 0;     // 4-bit counter to manage LED states
    reg direction = 0;         // Direction of the running light (0: forward, 1: backward)

    always @(posedge clk_50M) begin
        if (!switch) begin
            leds <= 7'b0000000; // All LEDs off when the switch is off
        end else begin
            if (direction == 0) begin
                leds <= 7'b0000001 << counter;  // Shift LED pattern to the left
                counter <= counter + 1;
                if (counter == 6) begin
                    direction <= 1;  // Change direction to backward
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
