`timescale 1ns / 1ps

module clk_gen(input clk, output clk_div);

    parameter n = 25; // Counter size is n + 1

    // As the number of registers used to divide
    // the clock increases, the tick speed
    // decreases. In this case, n = 25 so f out
    // = f_in/2^n = 100MHz/2^26 = (about 1 Hz)
    // which is slow enough to be perceived.
    reg [n:0] counter = 0;// Initialize as zero
    
    always @ (posedge clk)
    begin
    
        counter <= counter + 1;
    
    end

    // Assigning the output signal to the MSB of the
    // counter ensures most efficient use of the counter
    assign clk_div = counter [n] ;

endmodule