`timescale 1ns/1ps

interface ac_if (input bit clk);
    logic [7:0] in;
    logic rst;
    logic [15:0] sum;

    clocking cb @(posedge clk);
        default input #1 output #1;
        output in, rst;
        input sum;
    endclocking : cb

    modport dut (
        input rst, in,
        output sum
    );

    modport test (
        clocking cb,
        input clk,
        output rst,
        input sum
    );

endinterface : ac_if
