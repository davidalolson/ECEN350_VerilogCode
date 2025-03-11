`timescale 1ns / 1ps

module memory_tb( ); 
    reg we, oe, clk; 
    wire [15:0] data; 
    reg [3:0] addr; 
    reg [15:0] data_temp; 
    parameter period = 10; 
    memory u0 (.we(we), .oe(oe), .clk(clk), .data(data), .addr(addr)); 
 
    assign data = we ? data_temp : 16'hzzzz;  
    always #(period/2) clk = ~clk;  
    initial 
    begin    clk = 0;    oe = 0;    we = 0; addr = 4'h0; data_temp = 8'h00;
         #5 we = 1'b1;    
         @(posedge clk) 
         #1          addr = 4'h0; data_temp = 8'h34;   // wait 1 ns before writing
         #period     addr = 4'h1; data_temp = 8'h58;        // writing to memory
         #period     addr = 4'h2; data_temp = 8'hA5;    
         #period     addr = 4'h3; data_temp = 8'h5A;
         //…
         #period     addr = 4'h0; we= 1'b0; oe = 1'b1;      // reading from memory
         #period     addr = 4'h1;    
         #period     addr = 4'h2;
         //…
//         #1000 $finish
    end
endmodule
