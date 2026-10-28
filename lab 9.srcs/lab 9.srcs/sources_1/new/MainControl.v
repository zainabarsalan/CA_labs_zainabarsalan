`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2026 02:00:12 PM
// Design Name: 
// Module Name: MainControl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module MainControl(
    input [6:0] opcode,
    output reg RegWrite,
    output reg [1:0] ALUOp,
    output reg MemRead,
    output reg MemWrite,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg Branch
);

always @(*) begin
    RegWrite = 0;
    ALUOp = 0;
    MemRead = 0;
    MemWrite = 0;
    ALUSrc = 0;
    MemtoReg = 0;
    Branch = 0;

    case (opcode)

        7'b0110011: begin
            RegWrite = 1;
            ALUOp = 2'b10;
        end

        7'b0010011: begin
            RegWrite = 1;
            ALUOp = 2'b11;
            ALUSrc = 1;
        end

        7'b0000011: begin
            RegWrite = 1;
            ALUOp = 2'b00;
            MemRead = 1;
            ALUSrc = 1;
            MemtoReg = 1;
        end

        7'b0100011: begin
            ALUOp = 2'b00;
            MemWrite = 1;
            ALUSrc = 1;
        end

        7'b1100011: begin
            ALUOp = 2'b01;
            Branch = 1;
        end

    endcase
end

endmodule
