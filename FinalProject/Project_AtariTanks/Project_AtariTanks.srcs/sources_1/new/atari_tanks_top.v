`timescale 1ns / 1ps

module atari_tanks_top(
		input wire clk, reset,
		input wire [4:0] JA,
		input wire [4:0] JB,
		output wire hsync, vsync,
		output wire [11:0] rgb
    );
    
    // Preferences
    parameter BACKGROUND_COLOR = 12'h810;
    parameter STAGE_COLOR   = 12'hDA4;
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
    wire px_stage;
    reg [5:0] stage_row, stage_col;

    // Bullet/Projectile connections
    wire [9:0] p1_bullet_x, p1_bullet_y;
    wire [9:0] p2_bullet_x, p2_bullet_y;
    
    // Hit detection
    reg [11:0] bullet_collide = 12'h000; 
    reg p1_hit = 0;
    reg p2_hit = 0;
    
    // Collision detection
    reg [11:0] p1_wall_collide = 12'h000;
    reg [11:0] p2_wall_collide = 12'h000;
    reg p1_wall = 0;
    reg p2_wall = 0;
    
    // Video status output from vga_sync to tell when to route out rgb signal to DAC
    wire video_on; 
    
    // Instantiate vga_sync
    vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                            .video_on(video_on), .p_tick(), .x(x), .y(y));
    
    // Draw stage logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage_row <= 0;
            stage_col <= 0;
        end else begin
            // Map screen coordinates to stage row/column. Shift by two to magnify by 16x.
            if ((x >= 0) && (x < 640) && (y >= 0) && (y < 480)) begin
                stage_row <= y >> 4;
                stage_col <= x >> 4;
            end
        end 
    end
    
    // Instantiate stage
    stage_rom stage_rom_unit (.clk(clk), .row(stage_row), .col(stage_col), .pixel_data(px_stage));
                           
    // Instantiate players
    player #(.COLOR(PLAYER1_COLOR), .X_START(P1_X_START_POS), .Y_START(P1_Y_START_POS), .BLANK(BACKGROUND_COLOR), .PLAYER_TAG(PLAYER1_COLOR + 12'h001)) player1_unit (.clk(clk), .reset(reset), .x_in(x), .y_in(y), .ja_pins(JA), .image_out(p1_image), .hit_flag(p1_hit), .wall_flag(p1_wall));
    
    player #(.COLOR(PLAYER2_COLOR), .X_START(P2_X_START_POS), .Y_START(P2_Y_START_POS), .BLANK(BACKGROUND_COLOR), .PLAYER_TAG(PLAYER2_COLOR + 12'h002)) player2_unit (.clk(clk), .reset(reset), .x_in(x), .y_in(y), .ja_pins(JB), .image_out(p2_image), .hit_flag(p2_hit), .wall_flag(p2_wall));
    
    // Create a single concurrent image based on the compilation of all the image data presented
    
    // RGB buffer
    always@(posedge clk, posedge reset)
    begin
        if(reset)
            rgb_out <= 12'h000; // Set to black
        else
        begin
            rgb_out <= (p1_image != BACKGROUND_COLOR) && !px_stage? p1_image : px_stage? STAGE_COLOR : p2_image;
            
            // Bullet collision
            bullet_collide <= p1_image | p2_image;
            
            if (bullet_collide == (PLAYER2_COLOR | (PLAYER1_COLOR + 12'h001)))
                p2_hit <= 1;
            else if (bullet_collide == (PLAYER1_COLOR | (PLAYER2_COLOR + 12'h002)))
                p1_hit <= 1;
            else begin
                p1_hit <= 0;
                p2_hit <= 0;
            end
            
            // A collision occurs when both player and stage colors are present
            // Wall collision
            p1_wall_collide <= p1_image | (px_stage? STAGE_COLOR : BACKGROUND_COLOR);
            p2_wall_collide <= p2_image | (px_stage? STAGE_COLOR : BACKGROUND_COLOR);
            
            if(p1_wall_collide == (PLAYER1_COLOR | STAGE_COLOR))
                p1_wall <= 1;
            else if(p2_wall_collide == (PLAYER2_COLOR | STAGE_COLOR))
                p2_wall <= 1;
            else begin
                p1_wall <= 0;
                p2_wall <= 0;
            end
        end
    end
    
    // Write to display
    assign rgb = (video_on)? rgb_out : 12'h000; // Set to black
                               
endmodule

