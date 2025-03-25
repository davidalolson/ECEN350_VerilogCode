`timescale 1ns / 1ps

module controller(
    input wire clk,
    input wire [11:0] sw,
    output wire [11:0] button_presses
    );
    
    assign button_presses = sw;
    
endmodule
