`timescale 1ns / 1ps

module atari_tanks_top(
		input wire clk, reset,
		input wire [4:0] JA,
		input wire [4:0] JB,
		output wire hsync, vsync,
		output wire [11:0] rgb
    );
    
    // Preferences
    parameter BACKGROUND_COLOR = 12'h050;
    parameter PLAYER1_COLOR = 12'hF00;
    parameter PLAYER2_COLOR = 12'h0F0;
    parameter P1_X_START_POS = 40;
    parameter P1_Y_START_POS = 100;
    parameter P2_X_START_POS = 600;
    parameter P2_Y_START_POS = 380;
    
    // This wire is the compilation of the entire display (px by px)
    reg [11:0] rgb_out; // RGB output
    wire [9:0] x, y;
    wire [11:0] p1_image;
    wire [11:0] p2_image;
//    wire px_stage;

    // Bullet/Projectile connections
    wire [9:0] p1_bullet_x, p1_bullet_y;
    wire [9:0] p2_bullet_x, p2_bullet_y;
    
    // Hit detection
    reg [11:0] collide = 12'h000; 
    reg p1_hit = 0;
    reg p2_hit = 0;
    
    // Video status output from vga_sync to tell when to route out rgb signal to DAC
    wire video_on; 
    
    // Instantiate vga_sync
    vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                            .video_on(video_on), .p_tick(), .x(x), .y(y));
    // Instantiate stage
//    stage_rom stage_rom_unit (.clk(clk), .scan({y,x}>>2), .pixel_data(px_stage));
                           
    // Instantiate players
    player #(.COLOR(PLAYER1_COLOR), .X_START(P1_X_START_POS), .Y_START(P1_Y_START_POS), .BLANK(BACKGROUND_COLOR), .PLAYER_TAG(PLAYER1_COLOR + 12'h001)) player1_unit (.clk(clk), .reset(reset), .x_in(x), .y_in(y), .ja_pins(JA), .image_out(p1_image), .hit_flag(p1_hit));
    
    player #(.COLOR(PLAYER2_COLOR), .X_START(P2_X_START_POS), .Y_START(P2_Y_START_POS), .BLANK(BACKGROUND_COLOR), .PLAYER_TAG(PLAYER2_COLOR + 12'h002)) player2_unit (.clk(clk), .reset(reset), .x_in(x), .y_in(y), .ja_pins(JB), .image_out(p2_image), .hit_flag(p2_hit));
    
    // Create a single concurrent image based on the compilation of all the image data presented
    
    // RGB buffer
    always@(posedge clk, posedge reset)
    begin
        if(reset)
            rgb_out <= 12'h000; // Set to black
        else
        begin
            rgb_out <= (p1_image != BACKGROUND_COLOR)? p1_image : p2_image;
            
            collide <= p1_image | p2_image;
            
            if (collide == (PLAYER2_COLOR | (PLAYER1_COLOR + 12'h001)))
                p2_hit <= 1;
            else if (collide == (PLAYER1_COLOR | (PLAYER2_COLOR + 12'h002)))
                p1_hit <= 1;
            else begin
                p1_hit <= 0;
                p2_hit <= 0;
            end            
        end
    end
    
    // Write to display
    assign rgb = (video_on)? rgb_out : 12'h000; // Set to black
                               
endmodule

