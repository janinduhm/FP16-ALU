`timescale 1ns / 1ps

module FloatAddMult(clk, rst, sw, btnU, btnL, btnR, btnD);
  parameter IDLE = 2'b00, WAIT1 = 2'b01, WAIT2 = 2'b10, RESULT = 2'b11;
  parameter FloatAdd = 2'b00;
  parameter FloatMult = 2'b01;

  input clk, rst;
  input [15:0] sw;
  input btnU, btnL, btnR, btnD;

  wire [15:0] result_flA, result_flM;
  reg [15:0] result, num1, num2;
  reg [1:0] state;
  reg [1:0] op;

  wire FlAd, FlMd;
  wire FlA, FlM;
  wire commonBTN;

  assign FlAd = btnU;
  assign FlMd = btnL;

  debouncer db_FlA(.clk(clk), .rst(rst), .in_n(FlAd), .out_c(FlA));
  debouncer db_FlM(.clk(clk), .rst(rst), .in_n(FlMd), .out_c(FlM));

  float_multi flM(.num1(num1), .num2(num2), .result(result_flM));
  floatadder  flA(.num1(num1), .num2(num2), .result(result_flA));

  assign commonBTN = FlA | FlM;

  always@(posedge clk or posedge rst)
    begin
      if(rst)
        state <= IDLE;
      else
        state <= state + (commonBTN & (~(&state)));
    end

  always@(posedge clk or posedge rst)
    begin
      if(rst)
        op <= FloatAdd;
      else if(state == IDLE)
        begin
          if(FlA)      op <= FloatAdd;
          else if(FlM) op <= FloatMult;
        end
    end

  always@*
    begin
      case (op)
        FloatAdd:  result = result_flA;
        FloatMult: result = result_flM;
        default:   result = 16'b0;
      endcase
    end

  always@(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          num1 <= 16'b0;
          num2 <= 16'b0;
        end
      else
        case(state)
          WAIT1:   num1 <= sw;
          WAIT2:   num2 <= sw;
          default: ;
        endcase
    end

endmodule
