`timescale 1ns / 1ps

module  clk_gen(input clk, rst, output clk_div);

    parameter n = 19;
    
    // As the number of registers used to divide
    // the clock increases, the tick speed
    // decreases. In this case, n = 19 so f_out
    // = f_in/2^n = 100MHz/2^19 = 191 Hz which
    // is between 30Hz and 200Hz.
    reg [n:0] counter = 0; // Initialize as zero
           
    always @(posedge clk, posedge rst)
        begin
            if(rst) // Asynchronous positive-true reset
                counter <= 0;
            else
                counter <= counter + 1;
        end

    // Assigning the output signal to the MSB of the
    // counter ensures most efficient use of the counter
    assign clk_div = counter[n];

endmodule
