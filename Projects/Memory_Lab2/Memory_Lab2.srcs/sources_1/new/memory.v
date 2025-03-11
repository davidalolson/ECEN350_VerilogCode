`timescale 1ns / 1ps

module memory(
  input wire oe, we, clk,
  input wire [3:0] addr,
  inout wire [15:0] data
  ); 

  reg [15:0] mem [15:0];
  
  assign data = (oe && !we) ? mem[addr]:16'hzzzz; // Watch this dude
    
  always@(posedge clk)  
  begin 
    if (we) mem[addr] <= data; 
  end 
endmodule 