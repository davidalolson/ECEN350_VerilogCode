`timescale 1ns / 1ps

module player(
    input wire clk,
    
    input wire [9:0] x_in,
    input wire [9:0] y_in,
    
    output wire [11:0] image_out
    );

    wire [11:0] image; // Declare image to store sprite pixel data

    // Graphics support
    reg [5:0] scan_image;
    
    // Positional defaults
    parameter X_START = 320;
	parameter Y_START = 240;
	
	// Attributes - Positional
    reg [9:0] x_pos = X_START;
	reg [9:0] y_pos = Y_START;
	
	// Attributes - Sprite Dimentions 
	parameter SIZE = 8; // 8X8  
    
    // Instance sprite graphics data
    p_sprite p_sprite_unit (.clk(clk), .row(scan_image[5:3]), .col(scan_image[2:0]), .pixel_data(image));
    
    // Instance controller data
    // controller controller_unit (.clk(clk), .sw(), .button_presses(buttons));
    
    // Draw sprite
    // Create a counter that cycles through the sprite rom
    // to print the sprite to the diplay.
    // This may require two loops, one for the height of
    // the sprite and another for the width.
    always@(posedge clk)
    begin  
        // Increment the scan of the rows and columns of the sprite
        scan_image <= scan_image + 1;
                
    end
    
    // Output the image when within the aspect ratio
    assign image_out = ((x_in >= x_pos - SIZE/2) && (x_in < x_pos + SIZE/2) &&
                    (y_in >= y_pos - SIZE/2) && (y_in < y_pos + SIZE/2)) 
                   ? 12'b111100000000 : 12'b111111110000;
        
    
    // Properties
    // This section includes attributes such as current health
    // position 
    
    // Process
    // Dynamics and collisions go here. Also signal processing
    // will be handeled here.
    //  - Movement
    //  - Collisions
    //  - Status
    
    
    
endmodule
