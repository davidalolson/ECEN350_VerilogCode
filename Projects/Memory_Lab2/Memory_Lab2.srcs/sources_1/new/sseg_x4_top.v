`timescale 1ns / 1ps

module  clk_gen(input clk, rst, output clk_div);

    parameter n = 13;
    
    // As the number of registers used to divide
    // the clock increases, the tick speed
    // decreases. In this case, n = 19 so f_out
    // = f_in/2^n = 100MHz/2^19 = 191 Hz which
    // is between 30Hz and 200Hz.
    reg [n:0] counter = 0; // Initialize as zero
           
    always @(posedge clk, posedge rst)
        begin
            if(rst) // Asynchronous positive-true reset
                counter <= 0;
            else
                counter <= counter + 1;
        end

    // Assigning the output signal to the MSB of the
    // counter ensures most efficient use of the counter
    assign clk_div = counter[n];

endmodule

module digit_sel(input clk, rst, output reg [3:0] digit_sel);
   
    // The four anodes can be completely multiplexed 
    // with two bits.
    reg [1:0] state = 2'b00;
   
    always@(*)
        begin
		  // A case statement encapsulates the multiplexing
		  // behavior by assigning the adequate binary
             // sequence to enable exclusively one anode at
             // a time.
             case(state)

                0: digit_sel <= 4'b1110; // A zero means the anode
                1: digit_sel <= 4'b1101; // is active.
                2: digit_sel <= 4'b1011;
                3: digit_sel <= 4'b0111;
           
            endcase
        end
   
    always@(posedge clk, posedge rst)
    begin
   
        if(rst) // Asynchronous positive-true reset
            state <= 2'b00;
        else
		 // A counter is implemented here to cycle through
            // the four anodes by exploiting bit wrapping.
            state <= state + 2'b01; // 00-01-10-11-00-01-...        
    end
   
endmodule

module hex_num_gen(input [3:0] digit_sel, [15:0] sw, output reg [3:0] hex_num);
   
    always@(*)
        begin
           
            // A case statement receives the output of
            // digit_sel to select which set of switches
            // to generate the hexadecimal number from.
            // This ensures that each set of switches
            // correspond to exactly one display. 
            case(digit_sel)

                7:  hex_num <= sw[15:12];
                11: hex_num <= sw[11:8];
                13: hex_num <= sw[7:4];
                14: hex_num <= sw[3:0];

                default: hex_num <= 4'b0000;

            endcase

        end
   
endmodule

module sseg_encoder(
    input [3:0] hex, 
    output [3:0] an, 
    output reg [6:0] seg,
    output dp
    
    );
   
    assign an = 4'b1110; // Enable fourth array
    assign dp = 1'b1; // Disable decimal point
   
    always@(*) 
  // Each 7-segment display pattern is stored in a binary string
  // A case statement is used to simplify the interpretation
        case(hex[3:0]) //gfedcba
            0: seg = 7'b1000000;     // 0
            1: seg = 7'b1111001;     // 1
            2: seg = 7'b0100100;     // 2
            3: seg = 7'b0110000;     // 3
            4: seg = 7'b0011001;     // 4
            5: seg = 7'b0010010;     // 5
            6: seg = 7'b0000010;     // 6
            7: seg = 7'b1111000;     // 7
            8: seg = 7'b0000000;     // 8
            9: seg = 7'b0010000;     // 9
            10: seg = 7'b0100000;    // a
            11: seg = 7'b0000011;    // b
            12: seg = 7'b1000110;    // c
            13: seg = 7'b0100001;    // d
            14: seg = 7'b0000110;    // e
            15: seg = 7'b0001110;    // f
        endcase
       
endmodule



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