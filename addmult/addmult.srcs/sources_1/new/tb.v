`timescale 1ns / 1ps

module operatorCore_sim();

    reg [15:0] num1, num2;
    wire [15:0] floA, floM;

    floatadder  uut_add(num1, num2, floA);
    float_multi uut_mul(num1, num2, floM);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, operatorCore_sim);

        // 2.0 = 0_00001_0000000000 = 16'h0400
        // 1.0 = 0_00000_0000000000 = 16'h0000
        // 4.0 = 0_00010_0000000000 = 16'h0800
        // 1.5 = 0_00000_1000000000 = 16'h0200

        // Addition: 2.0 + 1.0 = 3.0 (expect 16'h0600)
        num1 = 16'h0400; num2 = 16'h0000; #100;
        $display("ADD  2.0 + 1.0 = %h  (expect 0600)", floA);

        // Addition: 4.0 + 2.0 = 6.0 (expect 16'h0A00)
        num1 = 16'h0800; num2 = 16'h0400; #100;
        $display("ADD  4.0 + 2.0 = %h  (expect 0A00)", floA);

        // Multiplication: 2.0 * 1.0 = 2.0 (expect 16'h0400)
        num1 = 16'h0400; num2 = 16'h0000; #100;
        $display("MUL  2.0 * 1.0 = %h  (expect 0400)", floM);

        // Multiplication: 2.0 * 1.5 = 3.0 (expect 16'h0600)
        num1 = 16'h0400; num2 = 16'h0200; #100;
        $display("MUL  2.0 * 1.5 = %h  (expect 0600)", floM);

        $finish;
    end

endmodule
