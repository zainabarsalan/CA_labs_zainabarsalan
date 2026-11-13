`timescale 1ns / 1ps

module mux2(
    input [31:0] input0,
    input [31:0] input1,
    input select,
    output [31:0] outputValue
);

assign outputValue = select ? input1 : input0;

endmodule