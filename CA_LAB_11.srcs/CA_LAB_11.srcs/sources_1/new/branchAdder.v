`timescale 1ns / 1ps

module branchAdder(
    input [31:0] PC,
    input [31:0] imm,
    output [31:0] branchTarget
);

assign branchTarget = PC + (imm << 1);

endmodule