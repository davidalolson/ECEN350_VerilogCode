`timescale 1ns / 1ps

module traffic_light(clk, tl_main, tl_center);
    input clk;
    
    output reg [2:0] tl_main = 3'b100;
    output reg [2:0] tl_center = 3'b001;
    
    reg [2:0] next_tl_main;
    reg [2:0] next_tl_center;
    
    always@*
    begin
       case(tl_main)
           3'b001: next_tl_main = 3'b010;
           3'b010: next_tl_main = 3'b100;
           3'b100: next_tl_main = 3'b001;
           
           default next_tl_main = 3'b001; 
       endcase 
       
       case(tl_center)
           3'b001: next_tl_center = 3'b010;
           3'b010: next_tl_center = 3'b100;
           3'b100: next_tl_center = 3'b001;
           
           default next_tl_center = 3'b001; 
       endcase 
    end
    
    always@(posedge clk)
    begin
//        if(timer == 1)
        begin
            tl_main   <= next_tl_main;
            tl_center <= next_tl_center;
        end
                 
    end
    
endmodule
