`timescale 1ns / 1ps

module sprite315_rom(
		input wire clk,
		input wire [2:0] row,
		input wire [2:0] col,
		output reg pixel_data
	);

	(* rom_style = "block" *)

	// Signal declaration
	reg [2:0] row_reg;
	reg [2:0] col_reg;
	
	// Parameter
	parameter mono_c  = 1;
	parameter blank = 0;

	always @(posedge clk)
	    begin
		row_reg <= row;
		col_reg <= col;
		end

	always @*
	case ({row_reg, col_reg})
		6'b000000: pixel_data = blank;
		6'b000001: pixel_data = blank;
		6'b000010: pixel_data = blank;
		6'b000011: pixel_data = mono_c;
		6'b000100: pixel_data = mono_c;
		6'b000101: pixel_data = blank;
		6'b000110: pixel_data = blank;
		6'b000111: pixel_data = blank; // Row 0 End
				
		6'b001000: pixel_data = blank;
		6'b001001: pixel_data = blank;
		6'b001010: pixel_data = blank;
		6'b001011: pixel_data = mono_c;
		6'b001100: pixel_data = mono_c;
		6'b001101: pixel_data = mono_c;
		6'b001110: pixel_data = blank; 
		6'b001111: pixel_data = blank; // Row 1 End
		
		6'b010000: pixel_data = blank;
		6'b010001: pixel_data = blank;
		6'b010010: pixel_data = blank;
		6'b010011: pixel_data = blank;
		6'b010100: pixel_data = mono_c;
		6'b010101: pixel_data = mono_c;
		6'b010110: pixel_data = mono_c;
		6'b010111: pixel_data = blank; // Row 2 End
		
		6'b011000: pixel_data = mono_c;
		6'b011001: pixel_data = mono_c;
		6'b011010: pixel_data = blank;
		6'b011011: pixel_data = mono_c;
		6'b011100: pixel_data = mono_c;
		6'b011101: pixel_data = mono_c;
		6'b011110: pixel_data = mono_c;
		6'b011111: pixel_data = mono_c; // Row 3 End
		
		6'b100000: pixel_data = mono_c;
		6'b100001: pixel_data = mono_c;
		6'b100010: pixel_data = mono_c;
		6'b100011: pixel_data = mono_c;
		6'b100100: pixel_data = mono_c;
		6'b100101: pixel_data = mono_c;
		6'b100110: pixel_data = mono_c;
		6'b100111: pixel_data = mono_c; // Row 4 End
		
		6'b101000: pixel_data = blank;
		6'b101001: pixel_data = mono_c;
		6'b101010: pixel_data = mono_c;
		6'b101011: pixel_data = mono_c;
		6'b101100: pixel_data = mono_c;
		6'b101101: pixel_data = mono_c;
		6'b101110: pixel_data = blank;
		6'b101111: pixel_data = blank; // Row 5 End
		
		6'b110000: pixel_data = blank;
		6'b110001: pixel_data = blank;
		6'b110010: pixel_data = mono_c;
		6'b110011: pixel_data = mono_c;
		6'b110100: pixel_data = mono_c;
		6'b110101: pixel_data = blank;
		6'b110110: pixel_data = mono_c;
		6'b110111: pixel_data = blank; // Row 6 End
		
		6'b111000: pixel_data = blank;
		6'b111001: pixel_data = blank;
		6'b111010: pixel_data = blank;
		6'b111011: pixel_data = mono_c;
		6'b111100: pixel_data = mono_c;
		6'b111101: pixel_data = blank;
		6'b111110: pixel_data = blank;
		6'b111111: pixel_data = mono_c; // Row 7 End
		
		default: pixel_data = blank;
	endcase
endmodule