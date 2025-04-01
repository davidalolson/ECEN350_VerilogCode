`timescale 1ns / 1ps

module player(
    input wire clk, reset,
    input wire [9:0] x_in, y_in,
    input wire [5:0] ja_pins,
    
    output reg [11:0] image_out,
    output reg [11:0] proj_out
    );

    // Graphics support
    reg [2:0] sprite_row;
    reg [2:0] sprite_col;
    wire [11:0] pixel_data;
    
    // Positional defaults
    parameter X_START = 320;
	parameter Y_START = 240;
	
	// Attributes - Positional
    reg [9:0] x_pos = X_START;
	reg [9:0] y_pos = Y_START;
	
	// Attributes - Sprite Dimentions 
	parameter SIZE = 32; // 8X8  
    
    // Movement speed varaible
    parameter CLK_DIV = 10000000;
    reg [31:0] clk_divider = 0;
    
    // Controller connections
    wire [2:0] btn;
    wire cw;
    wire ccw;
    reg [3:0] face = 1;
    reg [3:0] speed = 0; // Initialize to zero
    reg direction = 0;
    
    // added projectile contolles 
//    wire [9:0] bullet_x, bullet_y;
//    wire [1:0] bullet_dir;
//    wire active = 1;
//    reg [2:0] bullet_row;
//    reg [2:0] bullet_col;
//    reg [11:0] bullet_img_out;  // New variable for bullet image output

    // Instance controller data
    controller controller_unit (.clk(clk), .reset(reset), .pin(ja_pins[5:0]), .buttons(btn), .re_clockwise(cw), .re_counterclock(ccw));
    
    // Instance sprite graphics data
    p_sprite p_sprite_unit (.clk(clk), .row(sprite_row), .col(sprite_col), .pixel_data(pixel_data), .sel_sprite(face));
    
   // Instantiate projectile
    projectile projectile_unit (.clk(clk), .reset(reset), .face(face), .fire(btn[2]), .sprite_x(x_pos), .sprite_y(y_pos), .bullet_x(bullet_x), .bullet_y(bullet_y));
    
    // Draw sprite
    // Create a counter that cycles through the sprite rom
    // to print the sprite to the diplay.
    // This may require two loops, one for the height of
    // the sprite and another for the width.
    
    always @(posedge clk) begin
        // Map screen coordinates to sprite row/column
        sprite_row <= (y_in - (y_pos - SIZE/2)) >> 2; // Map screen y to sprite row
        sprite_col <= (x_in - (x_pos - SIZE/2)) >> 2; // Map screen x to sprite column
      
        // Check if the pixel is within the sprite's bounds and output the pixel data
        if ((x_in > x_pos - SIZE/2) && (x_in < x_pos + SIZE/2) &&
            (y_in > y_pos - SIZE/2) && (y_in < y_pos + SIZE/2)) begin
            image_out <= pixel_data; // Output sprite pixel color
        end else begin
            image_out <= 12'h000; // Set to black (background)
        end    
        
        if ((x_in > bullet_x - 4) && (x_in < bullet_x + 4) &&
            (y_in > bullet_y - 4) && (y_in < bullet_y + 4)) begin
            proj_out <= 12'hFFF;
        end else begin
            proj_out <= 12'hF00;
        end
    end
    
    
    
//     always @(posedge clk) begin
//    // Default to background (black)
//    image_out <= 12'h000;  
//    bullet_img_out <= 12'h000; 

//    sprite_row <= 3'b000;
//    sprite_col <= 3'b000;
//    bullet_row <= 2'b00;  // Adjusted for 3x3 bullet
//    bullet_col <= 2'b00;

    // Player sprite mapping
//    if ((x_in >= x_pos - SIZE/2) && (x_in < x_pos + SIZE/2) &&
//        (y_in >= y_pos - SIZE/2) && (y_in < y_pos + SIZE/2)) begin
//        sprite_row <= (y_in - (y_pos - SIZE/2)) >> 2;
//        sprite_col <= (x_in - (x_pos - SIZE/2)) >> 2;
//        image_out <= pixel_data;  
//    end 
    // Bullet display
//    else if (active && (x_in >= bullet_x - 2) && (x_in < bullet_x + 2) &&
//             (y_in >= bullet_y - 2) && (y_in < bullet_y + 2)) begin
//        bullet_row <= (y_in - (bullet_y - 2)) >> 1;
//        bullet_col <= (x_in - (bullet_x - 2)) >> 1;
//        image_out <= bullet_img_out;  // Show bullet
//    end
//end



    // Properties
    // This section includes attributes such as current health
    // position 
    
    // Process
    // Dynamics and collisions go here. Also signal processing
    // will be handeled here.
    //  - Movement
    //  - Collisions
    //  - Status
    
always@(posedge clk, posedge reset)
    begin
        if(reset)
        begin
            clk_divider <= 0;
            x_pos <= X_START;
            y_pos <= Y_START;
        end
        else begin
        
            clk_divider <= clk_divider + 1; // Fix the speed of the sprite
            
            // Get signals from rotary encoder
            if(cw)
                face <= face + 1;
            else if (ccw)
                face <= face - 1;
            else
                face <= face;
            
            // Get signals from buttons
            if(btn[0])
                direction <= 0;
            else if (btn[1])
                direction <= 1;
            else
                direction <= direction;
            
            if(btn[0] && btn[1])
                speed <= 0;
            else
                speed <= 4;
            
            //DIR   BIN   HEX  DESC       FUNC  FRAME MOD
            //0     0000  4'h0 RIGHT      ++X   fwd   3R
            //
            //30    0001  4'h1 UP RIGHT   -Y++X ttv   3R
            //45  - 0010  4'h2 UP RIGHT   -Y+X  ffv   3R
            //60    0011  4'h3 UP RIGHT   --Y+X ttv   3R & FLIP_X
            //
            //90    0100  4'h4 UP         --Y   fwd   
            //
            //120   0101  4'h5 UP LEFT    --Y-X ttv
            //135 - 0110  4'h6 UP LEFT    -Y-X  ffv
            //150   0111  4'h7 UP LEFT    -Y--X ttv   FLIP_X  
            //
            //180   1000  4'h8 LEFT       --X   fwd   R
            //
            //210   1001  4'h9 DOWN LEFT  +Y--X ttv   R
            //225 - 1010  4'hA DOWN LEFT  +Y-X  ffv   R
            //240   1011  4'hB DOWN LEFT  ++Y-X ttv   R & FLIP_X
            //
            //270   1100  4'hC DOWN       ++Y   fwd   2R
            //
            //300   1101  4'hD DOWN RIGHT ++Y+X ttv   2R
            //315 - 1110  4'hE DOWN RIGHT +Y+X  ffv   2R
            //330   1111  4'hF DOWN RIGHT +Y++X ttv   2R & FLIP_X
            
            // If recieved a movement signal
            // When the buttons are not being pressed, speed is zero
            // so that the sprite can rotate in place. Otherwise, 
            // the tank will move forward or backward using the direction
            // variable. Face determines what angle the tank faces on the
            // display.
            if((btn[0] || btn[1] || cw || ccw) && (clk_divider % CLK_DIV == 0))
            begin
                case (face)
                    4'b0000: x_pos <= direction? x_pos + speed : x_pos - speed;                     // 0
                    
                    4'b0001: begin x_pos <= direction? x_pos + speed : x_pos - speed;               // 30
                                   y_pos <= direction? y_pos - (speed/2) : y_pos + (speed/2); end
                                   
                    4'b0010: begin x_pos <= direction? x_pos + speed : x_pos - speed;               // 45
                                   y_pos <= direction? y_pos - speed : y_pos + speed; end
                             
                    4'b0011: begin x_pos <= direction? x_pos + (speed/2) : x_pos - (speed/2);       // 60
                                   y_pos <= direction? y_pos - speed : y_pos + speed; end
                                   
                    4'b0100: y_pos <= direction? y_pos - speed : y_pos + speed;                     // 90
                    
                    4'b0101: begin x_pos <= direction? x_pos - (speed/2) : x_pos + (speed/2);               // 120
                                   y_pos <= direction? y_pos - speed : y_pos + speed; end
                                   
                    4'b0110: begin x_pos <= direction? x_pos - speed : x_pos + speed;               // 135
                                   y_pos <= direction? y_pos - speed : y_pos + speed; end
                                   
                    4'b0111: begin x_pos <= direction? x_pos - speed : x_pos + speed;       // 150
                                   y_pos <= direction? y_pos - (speed/2) : y_pos + (speed/2); end
                                   
                    4'b1000: x_pos <= direction? x_pos - speed : x_pos + speed;                     // 180
                    
                    4'b1001: begin x_pos <= direction? x_pos - speed : x_pos + speed;               // 210
                                   y_pos <= direction? y_pos + (speed/2) : y_pos - (speed/2); end
                    
                    4'b1010: begin x_pos <= direction? x_pos - speed : x_pos + speed;               // 225
                                   y_pos <= direction? y_pos + speed : y_pos - speed; end
                                   
                    4'b1011: begin x_pos <= direction? x_pos - (speed/2) : x_pos + (speed/2);       // 240
                                   y_pos <= direction? y_pos + speed : y_pos - speed; end
                    
                    4'b1100: y_pos <= direction? y_pos + speed : y_pos - speed;                     // 270     
                    
                    4'b1101: begin x_pos <= direction? x_pos + (speed/2) : x_pos - (speed/2);       // 300
                                   y_pos <= direction? y_pos + speed : y_pos - speed; end
                    
                    4'b1110: begin x_pos <= direction? x_pos + speed : x_pos - speed;               // 315
                                   y_pos <= direction? y_pos + speed : y_pos - speed; end
                                   
                    4'b1111: begin x_pos <= direction? x_pos + speed : x_pos - speed;               // 330
                                   y_pos <= direction? y_pos + (speed/2) : y_pos - (speed/2); end
                    
                    default: ; // Do nothing
                endcase
            end
            
        end    
    end
    


    
    
endmodule
