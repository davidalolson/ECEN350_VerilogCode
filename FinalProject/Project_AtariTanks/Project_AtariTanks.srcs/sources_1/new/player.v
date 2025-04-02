`timescale 1ns / 1ps

    module player #(
    
    // Set sprite color
    parameter COLOR = 12'hFFF,
    
    // Set background color
    parameter BLANK = 12'h000,
    
    // Set sprite starting position
    parameter X_START = 320,
	parameter Y_START = 240,
	
    // Attributes - Sprite Dimentions 
	parameter SIZE = 32, // 8X8  
    
    // Change this to change the movement drive
    parameter MOV_DIV = 10000000,
    
    // How many pixels to move each time
    parameter DRIVE_POWER = 4 // Leave this alone plz
    
    ) (
    
    // IO
    input wire clk, reset,
    input wire [9:0] x_in, y_in,
    input wire [4:0] ja_pins,
    
    output reg [11:0] image_out
    
    );

    // Graphics streaming
    reg [2:0] sprite_row;
    reg [2:0] sprite_col;
    
    wire pixel_data; // Pixel data from ROMs
    
	// Track sprite position
    reg [9:0] x_pos = X_START; // Get initial position from parameters
	reg [9:0] y_pos = Y_START;
	
    // 31 bit regeister to slow down the movements of the sprite
    reg [31:0] movement_delay_counter = 0;
    
    // Controller connections
    wire [2:0] btn;
    wire cw; // Clockwise
    wire ccw; // Counterclockwise
    
    // Movement handeling
    reg [3:0] face = 1; // Defines the direction the head of the tank is facing
    reg [3:0] drive = 0; // Indicator whether to drive (or move) the tank with a power level between 2 and 4
    reg direction = 0; // 1 is forward (in respect to the head/face), 0 is reverse
    
    // Bullet/Projectile connections
    wire [9:0] bullet_x, bullet_y;

    // Instance controller data
    controller controller_unit (.clk(clk), .reset(reset), .pin(ja_pins[4:0]), .buttons(btn), .re_clockwise(cw), .re_counterclock(ccw));
    
    // Instance sprite graphics data
    p_sprite p_sprite_unit (.clk(clk), .row(sprite_row), .col(sprite_col), .pixel_data(pixel_data), .sel_sprite(face));
    
   // Instantiate projectile
    projectile projectile_unit (.clk(clk), .reset(reset), .face(face), .fire(btn[2]), .sprite_x(x_pos), .sprite_y(y_pos), .bullet_x(bullet_x), .bullet_y(bullet_y));
    
    // Draw sprite
    // Print the sprite depeding on the VGA scan variables and the position of the
    // sprite.
    always @(posedge clk) begin
        // Map screen coordinates to sprite row/column. Shift by two to magnify by 4x.
        sprite_row <= (y_in - (y_pos - SIZE/2)) >> 2; // Map screen y to sprite row
        sprite_col <= (x_in - (x_pos - SIZE/2)) >> 2; // Map screen x to sprite column
      
        // Check if the pixel is within the sprite's bounds and output the pixel data
        if ((x_in > x_pos - SIZE/2) && (x_in < x_pos + SIZE/2) && (y_in > y_pos - SIZE/2) && (y_in < y_pos + SIZE/2))
            // Get the shape of the sprite from ROMs that output a 1 for COLOR and a 0 for blank
            image_out <= pixel_data? COLOR: BLANK;
        else if ((x_in > bullet_x - SIZE/10) && (x_in < bullet_x + SIZE/10) && (y_in > bullet_y - SIZE/10) && (y_in < bullet_y + SIZE/10))
            // Match the color of the bullet to the color of the sprite
            image_out <= COLOR;
        else
            image_out <= BLANK; // Set to blank  
    end

    // Physics Process
    // Sprite movement control and reponse
    always@(posedge clk, posedge reset)
    begin
        if(reset)
        begin
            movement_delay_counter <= 0;
            x_pos <= X_START;
            y_pos <= Y_START;
        end
        else begin
            
            // Roll counter
            movement_delay_counter <= movement_delay_counter + 1; 
            
            // Get signals from rotary encoder
            // This update face between 0000 and 1111 for 16 possible
            // head/face angles.
            if(cw)
                face <= face + 1;
            else if (ccw)
                face <= face - 1;
            else
                face <= face;
            
            // Get signals from buttons
            // Detect foward or background input and change
            // direction of travel accordingly 
            // ACTIVE LOW
            if(btn[0])
                direction <= 0;
            else if (btn[1])
                direction <= 1;
            else
                direction <= direction;
            
            // If either foward or backward is pressed, then
            // initiate drive to begin moving the sprite
            // ACTIVE LOW
            if(btn[0] && btn[1])
                drive <= 0;
            else
                drive <= DRIVE_POWER; // Constant drive power (how many pixel to move at a time)
            
            // ------- TABLE -OF- DIRECTION & POWER -------
            //DIR - Direction in degrees
            //BIN - Binary step assignment
            //HEX - Hex step assignment
            //DESC- Description of approximate movement
            //FUNC- Function excecuted to realize movement
            //FRAME Sprite frame corresponding to step
            //MOD - Modifications to sprite frame
            // --------------------------------------------
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
            // When the buttons are not being pressed, drive is zero
            // so that the sprite can rotate in place. Otherwise, 
            // the tank will move forward or backward using the direction
            // variable. Face determines what angle the tank faces on the
            // display.
            
            // This is in essence a sensitivity list
            if((btn[0] || btn[1] || cw || ccw) && (movement_delay_counter % MOV_DIV == 0))
            begin
                case (face)
                    4'b0000: x_pos <= direction? x_pos + drive : x_pos - drive;                     // 0
                    
                    4'b0001: begin x_pos <= direction? x_pos + drive : x_pos - drive;               // 30
                                   y_pos <= direction? y_pos - (drive/2) : y_pos + (drive/2); end
                                   
                    4'b0010: begin x_pos <= direction? x_pos + drive : x_pos - drive;               // 45
                                   y_pos <= direction? y_pos - drive : y_pos + drive; end
                             
                    4'b0011: begin x_pos <= direction? x_pos + (drive/2) : x_pos - (drive/2);       // 60
                                   y_pos <= direction? y_pos - drive : y_pos + drive; end
                                   
                    4'b0100: y_pos <= direction? y_pos - drive : y_pos + drive;                     // 90
                    
                    4'b0101: begin x_pos <= direction? x_pos - (drive/2) : x_pos + (drive/2);       // 120
                                   y_pos <= direction? y_pos - drive : y_pos + drive; end
                                   
                    4'b0110: begin x_pos <= direction? x_pos - drive : x_pos + drive;               // 135
                                   y_pos <= direction? y_pos - drive : y_pos + drive; end
                                   
                    4'b0111: begin x_pos <= direction? x_pos - drive : x_pos + drive;               // 150
                                   y_pos <= direction? y_pos - (drive/2) : y_pos + (drive/2); end
                                   
                    4'b1000: x_pos <= direction? x_pos - drive : x_pos + drive;                     // 180
                    
                    4'b1001: begin x_pos <= direction? x_pos - drive : x_pos + drive;               // 210
                                   y_pos <= direction? y_pos + (drive/2) : y_pos - (drive/2); end
                    
                    4'b1010: begin x_pos <= direction? x_pos - drive : x_pos + drive;               // 225
                                   y_pos <= direction? y_pos + drive : y_pos - drive; end
                                   
                    4'b1011: begin x_pos <= direction? x_pos - (drive/2) : x_pos + (drive/2);       // 240
                                   y_pos <= direction? y_pos + drive : y_pos - drive; end
                    
                    4'b1100: y_pos <= direction? y_pos + drive : y_pos - drive;                     // 270     
                    
                    4'b1101: begin x_pos <= direction? x_pos + (drive/2) : x_pos - (drive/2);       // 300
                                   y_pos <= direction? y_pos + drive : y_pos - drive; end
                    
                    4'b1110: begin x_pos <= direction? x_pos + drive : x_pos - drive;               // 315
                                   y_pos <= direction? y_pos + drive : y_pos - drive; end
                                   
                    4'b1111: begin x_pos <= direction? x_pos + drive : x_pos - drive;               // 330
                                   y_pos <= direction? y_pos + (drive/2) : y_pos - (drive/2); end
                    
                    default: ; // Do nothing
                endcase
            end
        end    
    end    
    
endmodule