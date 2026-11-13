`timescale 1ns / 1ps

module ProgramCounter(
    input clk,
    input rst,
    input [31:0] nextPC,
    output reg [31:0] PC
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        PC <= 32'd0;
    end
    else begin
        PC <= nextPC;
    end
end

endmodule