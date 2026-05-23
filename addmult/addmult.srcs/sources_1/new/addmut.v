`timescale 1ns / 1ps

module float_multi(num1, num2, result);
  input [15:0] num1, num2;
  output [15:0] result;
  
  wire sign1, sign2, signr; 
  wire [4:0] ex1, ex2;
  wire [9:0] fra1, fra2;
  wire [10:0] float1; 
  wire [5:0] exSum; 
  wire [10:0] float_res; 
  reg [10:0] mid[9:0], mid2[1:0];

  assign {sign1, ex1, fra1} = num1;
  assign {sign2, ex2, fra2} = num2;
  
  assign signr = (sign1 ^ sign2);
  assign exSum = (ex1 + ex2);
  assign float1 = {1'b1, fra1};
  assign float_res = float1 + mid2[1] + mid2[0]; 
  assign result = {signr, exSum[4:0], float_res[9:0]};

  always@* 
    begin
      mid[0] = (float1 >> 10) & {16{fra2[0]}};
      mid[1] = (float1 >> 9) & {16{fra2[1]}};
      mid[2] = (float1 >> 8) & {16{fra2[2]}};
      mid[3] = (float1 >> 7) & {16{fra2[3]}};
      mid[4] = (float1 >> 6) & {16{fra2[4]}};
      mid[5] = (float1 >> 5) & {16{fra2[5]}};
      mid[6] = (float1 >> 4) & {16{fra2[6]}};
      mid[7] = (float1 >> 3) & {16{fra2[7]}};
      mid[8] = (float1 >> 2) & {16{fra2[8]}};
      mid[9] = (float1 >> 1) & {16{fra2[9]}};
    end

  always@*
    begin
      mid2[1] = mid[0] + mid[1] + mid[2] + mid[3] + mid[4];
      mid2[0] = mid[5] + mid[6] + mid[7] + mid[8] + mid[9];
    end
endmodule

module floatadder(num1, num2, result);
  input [15:0] num1, num2;
  output [15:0] result;
 
  reg [15:0] bigNum, smallNum; 
  wire [9:0] big_fra, small_fra; 
  wire [4:0] big_ex, small_ex;
  wire [5:0] exCheck;
  wire big_sig, small_sig;
  wire [10:0] big_float, small_float;
  reg [10:0] sign_small_float, shifted_small_float;
  wire [3:0] ex_diff;
  wire [11:0] sum; 
  

  assign result[15] = big_sig; 
  assign result[14:10] = exCheck[4:0];
  assign result[9:0] = (sum[11]) ? sum[10:1] : sum[9:0];

 
  assign {big_sig, big_ex, big_fra} = bigNum;
  assign {small_sig, small_ex, small_fra} = smallNum;
  
  assign big_float = {1'b1, big_fra};
  assign small_float = {1'b1, small_fra};
  assign ex_diff = big_ex - small_ex; 
  assign sum = sign_small_float + big_float; 
 
  assign exCheck = (sum[11]) ? (big_ex + 5'b1) : big_ex;

  always@* 
    begin
      case (ex_diff)
        0: shifted_small_float = small_float;
        1: shifted_small_float = (small_float >> 1);
        2: shifted_small_float = (small_float >> 2);
        3: shifted_small_float = (small_float >> 3);
        4: shifted_small_float = (small_float >> 4);
        5: shifted_small_float = (small_float >> 5);
        6: shifted_small_float = (small_float >> 6);
        7: shifted_small_float = (small_float >> 7);
        8: shifted_small_float = (small_float >> 8);
        9: shifted_small_float = (small_float >> 9);
        10: shifted_small_float = (small_float >> 10);
        default: shifted_small_float = 11'b0;
      endcase
    end

  always@*
    begin
      if(big_sig != small_sig)
        begin
          sign_small_float = ~shifted_small_float + 11'b1;
        end
      else
        begin
          sign_small_float = shifted_small_float;
        end
    end

  always@* 
    begin
      if(num2[14:10] > num1[14:10])
        begin
          bigNum = num2;
          smallNum = num1;
        end
      else if(num2[14:10] == num1[14:10])
        begin
          if(num2[9:0] > num1[9:0])
            begin
              bigNum = num2;
              smallNum = num1;
            end
          else
            begin
              bigNum = num1;
              smallNum = num2;
            end
        end
      else
        begin
          bigNum = num1;
          smallNum = num2;
        end
    end
endmodule
