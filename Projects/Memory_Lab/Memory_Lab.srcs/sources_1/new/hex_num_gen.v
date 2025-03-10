`timescale 1ns / 1ps


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