`timescale 1ns / 1ps

module digit_sel(input clk, rst, output reg [3:0] digit_sel);
   
    // The four anodes can be completely multiplexed 
    // with two bits.
    reg [1:0] state = 2'b00;
   
    always@(*)
        begin
		  // A case statement encapsulates the multiplexing
		  // behavior by assigning the adequate binary
             // sequence to enable exclusively one anode at
             // a time.
             case(state)

                0: digit_sel <= 4'b1110; // A zero means the anode
                1: digit_sel <= 4'b1101; // is active.
                2: digit_sel <= 4'b1011;
                3: digit_sel <= 4'b0111;
           
            endcase
        end
   
    always@(posedge clk, posedge rst)
    begin
   
        if(rst) // Asynchronous positive-true reset
            state <= 2'b00;
        else
		 // A counter is implemented here to cycle through
            // the four anodes by exploiting bit wrapping.
            state <= state + 2'b01; // 00-01-10-11-00-01-...        
    end
   
endmodule

