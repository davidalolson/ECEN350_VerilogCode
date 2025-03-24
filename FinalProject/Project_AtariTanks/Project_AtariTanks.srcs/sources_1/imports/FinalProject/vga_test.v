module vga_test
	(
		input wire clk, reset,
		input wire [11:0] sw,
		output wire hsync, vsync,
		output wire [11:0] rgb
	);
	
	// Positional parameter test
	parameter X_START = 320;
	parameter Y_START = 240;
	parameter SIZE = 8;
	parameter CLK_DIV = 1000000;
	
	wire [9:0] x, y;
	
	reg [9:0] x_pos = X_START;
	reg [9:0] y_pos = Y_START;
	
	wire video_on; // video status output from vga_sync to tell when to route out rgb signal to DAC
	wire [11:0] rgb_out;
	
	reg [31:0] clk_divider = 0;

    // instantiate vga_sync
    vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                            .video_on(video_on), .p_tick(), .x(x), .y(y));
    
    always@(posedge clk, posedge reset)
    begin
        if(reset)
        begin
             clk_divider <= 0;
            x_pos <= 0;
            y_pos <= 0;
        end
        else begin
        
            clk_divider <= clk_divider + 1;
            
            if (clk_divider % CLK_DIV == 0) begin
                if (sw[0] && x_pos < 640 - SIZE) x_pos <= x_pos + 1; // Move Right
                if (sw[1] && x_pos > SIZE)       x_pos <= x_pos - 1; // Move Left
                if (sw[2] && y_pos < 480 - SIZE) y_pos <= y_pos + 1; // Move Down
                if (sw[3] && y_pos > SIZE)       y_pos <= y_pos - 1; // Move Up
            end
        end    
    end
    
                                  
    // output
    assign rgb_out = ((x >= x_pos - SIZE) && (x <= x_pos + SIZE) && (y >= y_pos - SIZE) && (y <= y_pos + SIZE)) ? 12'b111100000000 : 12'b0;

    assign rgb = (video_on) ? rgb_out : 12'b0;
    
endmodule

// Credit: Poketronics
