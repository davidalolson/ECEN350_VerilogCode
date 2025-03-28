`timescale 1ns / 1ps

module controller(
    input wire clk, reset,
    input wire [5:0] pin,
    
    output wire up_button;
    output wire down_button;
    output wire action_button;
    output reg re_clockwise;
    output reg re_counterclock;
    );
    
    // Handel up, down, and action (fire)
    assign up_button = pin[0];
    assign down_button = pin[1];
    assign action_button = pin[3];
    
    // Registers for encoder
    reg enc_a = pin[4];
    reg enc_b = pin[5];
   
    reg last_state_a = enc_a; // Store the previous state of enc_a
    
    // Detect rotation of encoder
    always @(posedge clk or posedge reset) begin
        if (rst) begin
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
            last_state_a <= enc_a;  // Update last state of A
        end
    end

endmodule
