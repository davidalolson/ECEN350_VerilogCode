`timescale 1ns / 1ps

  module memory(
     input wire oe, we, clk,
     input wire [14:0] addr,
     inout wire [7:0] data
     ); 

    reg [7:0] mem [32767:0];


    assign data = (oe && !we) ? mem[addr]:8'hzz; // Watch this dude
    
    always@(posedge clk)  
    begin 
        if (we) mem[addr] <= data; 
    end 
endmodule 

