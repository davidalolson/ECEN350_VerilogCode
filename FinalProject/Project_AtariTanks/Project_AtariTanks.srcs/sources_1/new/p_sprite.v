`timescale 1ns / 1ps
module p_sprite
	(
		input wire clk,
		input wire [2:0] row,
		input wire [2:0] col,
		input wire [1:0] sel_sprite,
		output reg [11:0] pixel_data
	);
	
	wire [11:0] fwd_px_data;
	wire [11:0] ffv_px_data;
    wire [11:0] ttv_px_data;

	
	fwd_rom fwd_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(fwd_px_data));
	ffv_rom ffv_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(ffv_px_data));
	ttv_rom ttv_rom_unit (.clk(clk), .row(row), .col(col), .pixel_data(ttv_px_data));
    
    always@(posedge clk)
    begin
    
    // Frame handeler
    case (sel_sprite)
    
        4'b0000: pixel_data <= fwd_px_data; // 0
        4'b0001: pixel_data <= ttv_px_data; // 30
        4'b0010: pixel_data <= ffv_px_data; // 45
        4'b0011: pixel_data <= ttv_px_data; // 60
        4'b0100: pixel_data <= fwd_px_data; // 90
        4'b0101: pixel_data <= ttv_px_data; // 120
        4'b0110: pixel_data <= ffv_px_data; // 135
        4'b0111: pixel_data <= ttv_px_data; // 150
        4'b1000: pixel_data <= fwd_px_data; // 180
        4'b1001: pixel_data <= ttv_px_data; // 210
        4'b1010: pixel_data <= ffv_px_data; // 225
        4'b1011: pixel_data <= ttv_px_data; // 240
        4'b1100: pixel_data <= fwd_px_data; // 270
        4'b1101: pixel_data <= ttv_px_data; // 300
        4'b1110: pixel_data <= ffv_px_data; // 315
        4'b1111: pixel_data <= ttv_px_data; // 330
    
        default: pixel_data <= fwd_px_data;
    endcase
    
    end
    
endmodule

// Credit: Poketronics
