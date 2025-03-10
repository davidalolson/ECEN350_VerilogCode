`timescale 1ns / 1ps

module traffic_light_top_tb();
    reg clk;
    wire [5:0] led;
    
    traffic_light_top U1 (.clk(clk), .led(led));

    initial
        begin
        
        // Setup Signals
        clk = 0;
        
        // Simulation duration
//        #1000 $finish;
        
        end
    
    // Simulate a virtual clock signal
    always #5 clk <= ~clk;

endmodule


//