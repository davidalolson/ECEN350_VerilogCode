`timescale 1ns / 1ps

module player(
    input wire clk
    );
    
    // Instance sprite graphics data
    p_sprite p_sprite_unit (.clk(clk), .address(), .pixel_data(image));
    
    // Instance controller data
    controller controller_unit (.clk(clk), .sw(), .button_presses());
    
    // Draw sprite
    // Create a counter that cycles through the sprite rom
    // to print the sprite to the diplay.
    // This may require two loops, one for the height of
    // the sprite and another for the width.
    
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
