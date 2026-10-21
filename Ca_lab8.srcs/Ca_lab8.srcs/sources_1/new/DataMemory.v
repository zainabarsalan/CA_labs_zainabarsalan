`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2026 01:46:38 PM
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input clk,rst,
    input [31:0] address,
    input [31:0] writedata,
    input memwrite,
    output reg [31:0] readdata
 );
    reg [31:0] mem [0:511];
    always @(posedge clk or posedge rst) begin
        if(rst ) begin 
            readdata <= 32'b0;
        end
        else if ( memwrite ) begin 
            mem[address [8:0]] <= writedata;
        end
        else begin 
            readdata <= mem[address[8:0]];
        end
     end
endmodule

