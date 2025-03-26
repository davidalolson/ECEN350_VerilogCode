module bram_rom
	(
		input wire clk,
		input wire [2:0] address,
		output reg [7:0] data
	);

	(* rom_style = "block" *)

	//signal declaration
	reg [2:0] address_reg;

	always @(posedge clk)
		address_reg <= address;

	always @*
	case (address)
		3'b000: data = 12'b111111111111;
		3'b001: data = 12'b100000000001;
		3'b010: data = 12'b101000000101;
		3'b011: data = 12'b101000000101;
		3'b100: data = 12'b100000000001;
		3'b101: data = 12'b101111111101;
		3'b110: data = 12'b100000000001;
		3'b111: data = 12'b111111111111;
		
		default: data = 12'b111111111111;
	endcase
endmodule

// Credit: Poketronics
