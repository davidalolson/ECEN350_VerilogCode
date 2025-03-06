`timescale 1ns / 1ps

module clk_div(input clk, output reg clk_1Hz = 0);

    // A 1Hz clock from 100MHz example
    reg [27:0] count = 0; // make sure the count has enough bits to count to 50,000,000
       
   always @ (posedge clk) // f_clk is 100MHz
        if (count < 5) // 50000000
            count <= count + 1; // keep incrementing until you hit 50,000,000
        else
        begin
            count <= 0;
            clk_1Hz <= !clk_1Hz; // invert the clock every 1 second
        end 
    
endmodule