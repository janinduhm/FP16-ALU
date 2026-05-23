`timescale 1ns / 1ps

module operatorCore_sim();

    reg [15:0] num1, num2;
    wire [15:0] floA, floM;
   
    float_multi uut2(num1, num2, floM);
    floatadder uut3(num1, num2, floA);
    
    initial 
        begin
           num1 <= 16'b0000100000101011;
           num2 <= 16'b1000010000001011;
       /*  #250
           num1 <= 16'b1111111111111111;
           num2 <= 16'b1111111111111111;*/
        end   
endmodule