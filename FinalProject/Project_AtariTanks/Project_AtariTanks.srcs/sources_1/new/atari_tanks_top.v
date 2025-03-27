`timescale 1ns / 1ps

module atari_tanks_top(
		input wire clk, reset,
		input wire [11:0] sw,
		output wire hsync, vsync,
		output wire [11:0] rgb
    );
    
    // This wire is the compilation of the entire display (px by px)
    wire [11:0] rgb_out = 12'b1; // RGB output
    
    // Video status output from vga_sync to tell when to route out rgb signal to DAC
    wire video_on; 
    
    // Instantiate vga_sync
    vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                            .video_on(video_on), .p_tick(), .x(x), .y(y));
                            
    // Instantiate a player
    player player1_unit (.clk(clk), .x_in(x), .y_in(y), .image_out(p1_image));
    
    // Create a single concurrent image based on the compilation of all the image data presented
    assign rgb_out = p1_image;
    
    
    // Write to display
    assign rgb = (video_on)? rgb_out : 12'b1;
                               
endmodule
