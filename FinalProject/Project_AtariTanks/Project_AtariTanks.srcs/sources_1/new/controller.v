`timescale 1ns / 1ps

module controller(
    input wire clk, reset,
    input wire [4:0] pin,
    
    output wire [2:0] buttons,
    output reg re_clockwise,
    output reg re_counterclock
    );
    
    // Handel up, down, and action (fire)
    assign buttons = pin[2:0];
    
    // Registers for encoder
    reg enc_a = 0;
    reg enc_b = 0;
    reg last_state_a = 0; // Store the previous state of enc_a
    
    // Detect rotation of encoder
    always @(posedge clk, posedge reset) begin
           
        if (reset) begin
            re_clockwise    <= 0;
            re_counterclock <= 0;
            last_state_a <= enc_a;
        end else begin
            if (enc_a != last_state_a) begin  // Detect state change on A
                if (enc_b != enc_a) begin
                    re_clockwise    <= 1;
                    re_counterclock <= 0;
                end else begin
                    re_clockwise    <= 0;
                    re_counterclock <= 1;
                end
            end else begin
                re_clockwise    <= 0;  // Reset indicators when idle
                re_counterclock <= 0;
            end
            
            // Get input from re via JA pins
            enc_a <= pin[3];
            enc_b <= pin[4];
            last_state_a <= enc_a;  // Update last state of A
        end
    end

endmodule
