`timescale 1ns / 1ps

module multiplier(input [15:0] sw, clk, output [15:0] led);

    // Eight Bit Multiplier
    // Create eight partial product stages using assign, then take the sum
    
    wire [7:0] a = sw[7:0];
    wire [7:0] b = sw[15:8];
    
    // Define wires for each partial product
    wire [8:0] p0;
    wire [9:0] p1;
    wire [10:0] p2;
    wire [11:0] p3;
    wire [12:0] p4;
    wire [13:0] p5;
    wire [14:0] p6;
    wire [15:0] p7;
    
    // Flip-flops for pipelining, initialize to zero
    reg partial0_1 = 0;
    reg partial2_3 = 0;
    reg partial4_5 = 0;
    reg partial6_7 = 0;
    reg partial_a  = 0;
    reg partial_b  = 0;
    
    // Compute each partial product with bitwise AND  
    assign p0[7:0] = {({8{a[0]}} & b[7:0])};
    assign p1[8:0] = {({8{a[1]}} & b[7:0]), 1'h0};
    assign p2[9:0] = {({8{a[2]}} & b[7:0]), 2'h0};
    assign p3[10:0] = {({8{a[3]}} & b[7:0]), 3'h0};
    assign p4[11:0] = {({8{a[4]}} & b[7:0]), 4'h0};
    assign p5[12:0] = {({8{a[5]}} & b[7:0]), 5'h00};
    assign p6[13:0] = {({8{a[6]}} & b[7:0]), 6'h00};
    assign p7[14:0] = {({8{a[7]}} & b[7:0]), 7'h00};

    
    // Sum partial products
    // Display product on LED array
//    assign led = p0 + p1 + p2 + p3 + p4 + p5 + p6 + p7;

    // Implement pipelining
    always@(posedge clk)
    begin
    
        // Stage 1
        partial0_1 <= p0 + p1;
        partial2_3 <= p3 + p3;
        partial4_5 <= p4 + p5;
        partial6_7 <= p6 + p7;
        
        // Stage 2
        partial_a  <= partial0_1 + partial2_3;
        partial_b  <= partial4_5 + partial6_7;
              
    end
    
    // Stage 3
    assign led = partial_a + partial_b;
    
endmodule