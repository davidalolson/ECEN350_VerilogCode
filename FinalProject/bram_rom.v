module bram_rom
	(
		input wire clk,
		input wire [2:0] address
		output reg [7:0] data
	);

	(* rom_style = "block" *)

	//signal declaration
	reg [2:0] address_reg;

	always @(posedge clk)
		address_reg <= address;

	always @*
	case (address)
		3'b000: data = 8'b00000001;
		.
		.
		.
		default: data = 8'b11111111;
	endcase
endmodule

// Credit: Poketronics
