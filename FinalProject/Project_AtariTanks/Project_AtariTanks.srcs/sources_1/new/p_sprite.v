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
    
    if(sel_sprite == 2'b00)
        pixel_data <= fwd_px_data;
    else if(sel_sprite == 2'b01)
        pixel_data <= ffv_px_data;
    else if(sel_sprite == 2'b10)
        pixel_data <= ttv_px_data;
    else
        pixel_data <= 12'hF00; // fault
    end
    
endmodule

// Credit: Poketronics
