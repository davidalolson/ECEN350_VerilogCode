`timescale 1ns / 1ps

module player(
    input wire clk,
    
    input wire [9:0] x_in,
    input wire [9:0] y_in,
    
    output reg [11:0] image_out
    );

    // Graphics support
    reg [2:0] sprite_row;
    reg [2:0] sprite_col;
    
    // Positional defaults
    parameter X_START = 320;
	parameter Y_START = 240;
	
	// Attributes - Positional
    reg [9:0] x_pos = X_START;
	reg [9:0] y_pos = Y_START;
	
	// Attributes - Sprite Dimentions 
	parameter SIZE = 8; // 8X8  
    
    // Instance sprite graphics data
    p_sprite p_sprite_unit (.clk(clk), .row(sprite_row), .col(sprite_col), .pixel_data(pixel_data));
    
    // Instance controller data
    // controller controller_unit (.clk(clk), .sw(), .button_presses(buttons));
    
    // Draw sprite
    // Create a counter that cycles through the sprite rom
    // to print the sprite to the diplay.
    // This may require two loops, one for the height of
    // the sprite and another for the width.
    always@(posedge clk) 
    // Define sprite position on screen
        if ((x_in >= x_pos - SIZE/2) && (x_in < x_pos + SIZE/2) && (y_in >= y_pos - SIZE/2) && (y_in < y_pos + SIZE/2)) begin
            sprite_row = y_in - (y_pos - SIZE/2); // Map screen y to sprite row
            sprite_col = x_in - (x_pos - SIZE/2); // Map screen x to sprite column
            image_out = pixel_data[sprite_row * SIZE + sprite_col]; // Output sprite pixel color
        end else begin
            image_out = 12'h000;
        end
                
  
        
    
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
