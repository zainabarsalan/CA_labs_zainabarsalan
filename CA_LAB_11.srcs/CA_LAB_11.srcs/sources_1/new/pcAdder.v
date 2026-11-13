`timescale 1ns / 1ps

module pcAdder(
    input [31:0] PC,
    output [31:0] nextPC
);

assign nextPC = PC + 32'd4;

endmodule