`timescale 1ns / 1ps

module projectile(
    input clk, reset,
    input wire [3:0] face,      // The direction the sprite is facing (4-bit)
    input wire fire,            // Fire button signals the bullet to fire 
    input wire wall_collide,
    input wire [9:0] sprite_x, sprite_y,  // Player's position
    output reg [9:0] bullet_x, bullet_y // bullets position
);

    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;
    parameter CLK_DIV = 1000000;
    parameter speed = 8;
    
    reg active = 0;
    reg [3:0] last_face;
    reg [31:0] clk_divider = 0;
    
    always @(posedge clk, posedge wall_collide) begin
        if (reset | wall_collide) begin
            clk_divider <= 0;
            active <= 0;
            last_face <= 0;
        end
        else if (!fire && !active) begin
            // Initialize projectile at player's position
            bullet_x <= sprite_x;
            bullet_y <= sprite_y;
            active <= 1;       
            last_face <= face;
        end 
        else if (active) begin
            
            clk_divider <= clk_divider + 1;
           
                

            if(clk_divider % CLK_DIV == 0) begin
                    
                case (last_face)
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
                active <= 0; // Reset bullet
            end
        end
    end 

endmodule
