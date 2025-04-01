`timescale 1ns / 1ps
module p_sprite
	(
		input wire clk,
		input wire [2:0] row,
		input wire [2:0] col,
		input wire [3:0] sel_sprite,
		output reg [11:0] pixel_data // 1 or 0
	);
	// Declare 12-bit buses for each sprite ROM output
    wire [11:0] sprite0_data;
    wire [11:0] sprite30_data;
    wire [11:0] sprite45_data;
    wire [11:0] sprite60_data;
    wire [11:0] sprite90_data;
    wire [11:0] sprite120_data;
    wire [11:0] sprite135_data;
    wire [11:0] sprite150_data;
    wire [11:0] sprite180_data;
    wire [11:0] sprite210_data;
    wire [11:0] sprite225_data;
    wire [11:0] sprite240_data;
    wire [11:0] sprite270_data;
    wire [11:0] sprite300_data;
    wire [11:0] sprite315_data;
    wire [11:0] sprite330_data;

    // Instantiate each sprite ROM module
	sprite0_rom  sprite0_rom_unit  (.clk(clk), .row(row), .col(col), .pixel_data(sprite0_data));
	sprite30_rom sprite30_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite30_data));
	sprite45_rom sprite45_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite45_data));
	sprite60_rom sprite60_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite60_data));
	sprite90_rom sprite90_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite90_data));
	sprite120_rom sprite120_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite120_data));
	sprite150_rom sprite150_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite150_data));	
	sprite135_rom sprite135_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite135_data));
	sprite180_rom sprite180_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite180_data));
	sprite210_rom sprite210_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite210_data));
	sprite225_rom sprite225_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite225_data));
	sprite240_rom sprite240_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite240_data));
	sprite270_rom sprite270_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite270_data));
	sprite300_rom sprite300_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite300_data));
	sprite315_rom sprite315_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite315_data));
	sprite330_rom sprite330_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(sprite330_data));

    always@(posedge clk)
    begin
    
    // Frame handeler
    case (sel_sprite)
    
        4'b0000: pixel_data <= sprite0_data; // 0
        4'b0001: pixel_data <= sprite30_data; // 30
        4'b0010: pixel_data <= sprite45_data; // 45
        4'b0011: pixel_data <= sprite60_data; // 60
        4'b0100: pixel_data <= sprite90_data; // 90
        4'b0101: pixel_data <= sprite120_data; // 120
        4'b0110: pixel_data <= sprite135_data; // 135
        4'b0111: pixel_data <= sprite150_data; // 150
        4'b1000: pixel_data <= sprite180_data; // 180
        4'b1001: pixel_data <= sprite210_data; // 210
        4'b1010: pixel_data <= sprite225_data; // 225
        4'b1011: pixel_data <= sprite240_data; // 240
        4'b1100: pixel_data <= sprite270_data; // 270
        4'b1101: pixel_data <= sprite300_data; // 300
        4'b1110: pixel_data <= sprite315_data; // 315
        4'b1111: pixel_data <= sprite330_data; // 330
    
        default: pixel_data <= sprite0_data;
    endcase
    
    end
    
endmodule

// Credit: Poketronics
