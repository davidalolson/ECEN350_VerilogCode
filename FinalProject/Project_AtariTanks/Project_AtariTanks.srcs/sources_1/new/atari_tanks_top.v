`timescale 1ns / 1ps

module atari_tanks_top(
		input wire clk, reset,
		input wire [4:0] JA,
		output wire hsync, vsync,
		output wire [11:0] rgb
    );
    
    // This wire is the compilation of the entire display (px by px)
    reg [11:0] rgb_out; // RGB output
    wire [9:0] x, y;
    wire [11:0] p1_image;
    
    // Video status output from vga_sync to tell when to route out rgb signal to DAC
    wire video_on; 
    
    // Instantiate vga_sync
    vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                            .video_on(video_on), .p_tick(), .x(x), .y(y));
                            
    // Instantiate a player
    player player1_unit (.clk(clk), .reset(reset), .x_in(x), .y_in(y), .ja_pins(JA), .image_out(p1_image));
    
    // Create a single concurrent image based on the compilation of all the image data presented
    
    // RGB buffer
    always@(posedge clk, posedge reset)
    begin
        if(reset)
            rgb_out <= 12'hF00;
        else
            rgb_out <= p1_image;
    end
    
    // Write to display
    assign rgb = (video_on)? rgb_out : 12'h000;
                               
endmodule
