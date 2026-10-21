`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2026 01:47:06 PM
// Design Name: 
// Module Name: AddressDecoder
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


module AddressDecoder(
    input [9:0] address, 
    input  writeenable,
    input  readenable,
    output  wire dmread,
    output wire dm,
    output  wire  leds,
    output wire  switches
     

    );
    wire [1:0] selector;
    assign selector = address[9:8];
    assign dm   = ((selector == 2'b00) || (selector == 2'b01)) && writeenable;
    assign dmread   = ((selector == 2'b00) || (selector == 2'b01)) && readenable;
    assign leds     = (selector == 2'b10) && writeenable;
    assign switches = (selector == 2'b11) && readenable;
endmodule
