module clock_divider (
    input clk,          // System clock
    input rst_n,        // Active low reset
    output reg clk_1hz       // 1 Hz clock output
);
    parameter DIVISOR = 50_000_000; // Assuming a 50 MHz clock, this divides it down to 1 Hz

    reg [25:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 26'b0;
            clk_1hz <= 1'b0;
        end else begin
            if (counter == (DIVISOR-1)) begin
                counter <= 26'b0;
                clk_1hz <= ~clk_1hz; // Toggle the 1 Hz clock
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end
endmodule
