`timescale 1ns / 1ps

module traffic_light_top(
    input clk,
    output [5:0] led
    );
    
    // Instantiate clock generator module and route signals
    clk_gen       U1 (.clk(clk), .clk_div(clkd));
    
    // Insantiate traffic light module and route signals
    traffic_light U2 (.clk(clkd), .tl_main(led[2:0]), .tl_center(led[5:3]));
    
endmodule
