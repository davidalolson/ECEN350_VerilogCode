`timescale 1ns / 1ps

module atari_tanks_top(
		input wire clk, reset,
		input wire [11:0] sw,
		output wire hsync, vsync,
		output wire [11:0] rgb
    );
    
    wire [9:0] x, y;        // VGA coordinates (typically 10-bit for 640x480)
    wire [11:0] p1_image;   // RGB output from the player
    
    // Video status output from vga_sync to tell when to route out rgb signal to DAC
    wire video_on; 
    
    // Instantiate vga_sync
    vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                            .video_on(video_on), .p_tick(), .x(x), .y(y));
                            
    // Instantiate a player
    player player1_unit (.clk(clk), .x_in(x), .y_in(y), .image_out(p1_image));
    
    // Write to display
    assign rgb = (video_on)? p1_image : 12'b111111111111;
                               
endmodule
