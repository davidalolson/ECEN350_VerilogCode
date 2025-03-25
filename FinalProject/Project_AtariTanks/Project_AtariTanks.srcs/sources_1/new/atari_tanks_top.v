`timescale 1ns / 1ps

module atari_tanks_top(
		input wire clk, reset,
		input wire [11:0] sw,
		output wire hsync, vsync,
		output wire [11:0] rgb
    );
    
    // Instantiate vga_sync
    vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                            .video_on(video_on), .p_tick(), .x(x), .y(y));
                            
    
    
    
    
endmodule
