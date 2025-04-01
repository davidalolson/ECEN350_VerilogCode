`timescale 1ns / 1ps

module projectile(
    input clk, reset,
    input wire [3:0] face,      // The direction the sprite is facing (4-bit)
    input wire fire,            // Fire button; signals the bullet to fire 
    input wire [9:0] sprite_x, sprite_y,  // Player's position
    output reg [9:0] bullet_x, bullet_y // bullets position
);

    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;
    parameter CLK_DIV = 10000000;
    parameter speed = 4; // Added missing speed definition
    
    reg fired = 0;
    reg clk_divider = 0;
    
    always @(posedge clk) begin
        if (reset) begin
            clk_divider <= 0;
            fired <= 0;
        end
        else if (!fire) begin
            // Initialize projectile at player's position
            bullet_x <= sprite_x;
            bullet_y <= sprite_y;
            fired <= 1;       
        end 
        else if (fired) begin
            
            clk_divider <= clk_divider + 1; // Fix the speed of the bullet

            if(clk_divider % CLK_DIV == 0) begin
                case (face)
                    4'b0000: bullet_x <= bullet_x + speed;                     // 0
                    4'b0001: begin bullet_x <= bullet_x + speed;               // 30
                                   bullet_y <= bullet_y - (speed/2); end
                    4'b0010: begin bullet_x <= bullet_x + speed;               // 45
                                   bullet_y <= bullet_y - speed; end
                    4'b0011: begin bullet_x <= bullet_x + (speed/2);       // 60
                                   bullet_y <= bullet_y - speed; end
                    4'b0100: bullet_y <= bullet_y - speed;                     // 90
                    4'b0101: begin bullet_x <= bullet_x - (speed/2);           // 120
                                   bullet_y <= bullet_y - speed; end
                    4'b0110: begin bullet_x <= bullet_x - speed;               // 135
                                   bullet_y <= bullet_y - speed; end
                    4'b0111: begin bullet_x <= bullet_x - speed;       // 150
                                   bullet_y <= bullet_y - (speed/2); end
                    4'b1000: bullet_x <= bullet_x - speed;                     // 180
                    4'b1001: begin bullet_x <= bullet_x - speed;               // 210
                                   bullet_y <= bullet_y + (speed/2); end
                    4'b1010: begin bullet_x <= bullet_x - speed;               // 225
                                   bullet_y <= bullet_y + speed; end
                    4'b1011: begin bullet_x <= bullet_x - (speed/2);       // 240
                                   bullet_y <= bullet_y + speed; end
                    4'b1100: bullet_y <= bullet_y + speed;                     // 270     
                    4'b1101: begin bullet_x <= bullet_x + (speed/2);       // 300
                                   bullet_y <= bullet_y + speed; end
                    4'b1110: begin bullet_x <= bullet_x + speed;               // 315
                                   bullet_y <= bullet_y + speed; end
                    4'b1111: begin bullet_x <= bullet_x + speed;               // 330
                                   bullet_y <= bullet_y + (speed/2); end
                    default: ; // Do nothing
                endcase
            end

            // Deactivate when out of bounds
            if (bullet_x <= 0 || bullet_x >= SCREEN_WIDTH || bullet_y <= 0 || bullet_y >= SCREEN_HEIGHT) begin
                fired <= 0; // Reset bullet
            end
        end // <-- This `end` properly closes the `always` block
    end // <-- This `end` was missing before `endmodule`

endmodule
