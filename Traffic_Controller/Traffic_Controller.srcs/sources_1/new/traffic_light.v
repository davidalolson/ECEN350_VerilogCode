`timescale 1ns / 1ps

module traffic_light(clk, tl_main, tl_center);//, cw_main, cw_center);
    input clk;
    
    output reg [2:0] tl_main = 3'b001; // Green
    output reg [2:0] tl_center = 3'b100; // Red
//    output cw_main   = ;
//    output cw_center = ;
    
    reg [2:0] next_tl_main;
    reg [2:0] next_tl_center;

    // counter register (adjust as needed to
    // provide differnt delays
    reg [4:0] timer = 0;
    parameter duration1 = 5'b01111; // 15s between 0  and 15
    parameter duration2 = 5'b10010; // 3s  between 15 and 18
    parameter duration3 = 5'b11100; // 10s between 18 and 28
    parameter duration4 = 5'b11111; // 3s  between 28 and 31
    
    
    always@*
    begin
       case(tl_main)
           3'b001: next_tl_main = 3'b010;
           3'b010: next_tl_main = 3'b100;
           3'b100: next_tl_main = 3'b001;
           
           default next_tl_main = 3'b100; 
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
        // We need to use a five bit counter for the 31 seconds of operation
        // since 31 in binary is 1111 1.
        // counter state + update machine
        // 0 1111        | Main
        // 1 0010        | Main & Center
        // 1 1100        | Center
        // 1 1111        | Main & Center

        // Increment counter (timer) every rising edge
        timer <= timer + 1;

        case(timer)
            
            duration1: tl_main   <= next_tl_main; // Just update main
           
            duration2: begin
   
                tl_main   <= next_tl_main; // Update both
                tl_center <= next_tl_center;
            
            end
            
            duration3: tl_center <= next_tl_center; // Just update center
            
            duration4: begin 
            
                tl_main   <= next_tl_main; // Update both
                tl_center <= next_tl_center;
                
            end
            
            default: ; // Do nothing
        
        endcase
       
                 
    end
    
endmodule


