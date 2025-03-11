`timescale 1ns / 1ps

module sseg_x4_top(input [15:0] sw, btnC, clk, output [6:0] seg, [3:0] an, dp);

    // Each hexadecimal number can be represented
    // in four bits. Therefore, a four-bit bus is
    // used to read digit data.
    wire [3:0] hex_num; 
   
    // The operation of the sseg_x4_top module is delegated
    // to sub-modules. Each sub-module instantiated here
    // has the format "module_name UX (.IO(top_IO), ...)"
    // where IO is the input/output of the sub-module and
    // top_IO are the inputs/outputs of the entire system.

    // Reduce clock frequency
    clk_gen U1 (.clk(clk), .rst(btnC), .clk_div(clkd)); 
    
    // Select which display is active
    digit_sel U2 (.clk(clkd), .rst(btnC), .digit_sel(an));
   
    // Generate hexadecimal numbers from the switch inputs 
    hex_num_gen U3 (.digit_sel(an), .sw(sw), .hex_num(hex_num));
   
    // Map the hexadecimal digits to the displays
    sseg_encoder U4 (.hex(hex_num), .seg(seg), .dp(dp));
   
       
endmodule
