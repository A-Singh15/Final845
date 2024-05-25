`timescale 1ns/1ps

module top;

    bit clk;
    parameter clk_per = 10; // clock period
    always #(clk_per / 2) clk = ~clk; // clock generation

    ac_if acif(clk); // Interface
    test tst(acif); // Test Program
    accumulator dut(
        .sum(acif.sum),
        .in(acif.in),
        .rst(acif.rst),
        .clk(clk)
    ); // Design Under Test

endmodule
