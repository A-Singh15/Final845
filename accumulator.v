`timescale 1ns/1ps

module accumulator (
    output reg [15:0] sum,  // accumulated out
    input [7:0] in,         // input
    input rst, clk          // reset and clock inputs
);
    wire carry;
    wire [15:0] sum_in; 
    assign {carry, sum_in} = sum + in;

    always @(posedge clk) begin
        if (rst)
            sum <= 0;
        else 
            sum <= (carry) ? 16'hFFFF : sum_in;
    end
endmodule
