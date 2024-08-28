module led_effect (
    input clk_50M,          // 50 MHz clock signal
    input switch,           // Control switch
    output reg [6:0] leds   // 7 LEDs
);

    reg [31:0] clk_divider = 0; // Clock divider counter
    reg slow_clk = 0;           // Slow clock signal
    reg [3:0] counter = 0;      // 4-bit counter to manage LED states
    reg direction = 0;          // Direction of the running light (0: forward, 1: backward)

    // Clock divider: divide 50 MHz to 1 Hz (assuming 50 million clock cycles per second)
    always @(posedge clk_50M) begin
        clk_divider <= clk_divider + 1;
        if (clk_divider == 25000000) begin  // 50 million / 2 = 25 million
            clk_divider <= 0;
            slow_clk <= ~slow_clk; // Toggle the slow clock signal
        end
    end

    // LED effect logic
    always @(posedge slow_clk) begin
        if (!switch) begin
            leds <= 7'b0000000;  // All LEDs off when the switch is off
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
