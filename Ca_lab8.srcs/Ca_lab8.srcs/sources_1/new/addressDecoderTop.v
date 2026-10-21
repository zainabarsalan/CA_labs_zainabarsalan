
`timescale 1ns / 1ps

module addressDecoderTop(
    input clk,
    input rst,
    input [31:0] address,
    input readEnable,
    input writeEnable,
    input [31:0] writeData,
    input [15:0] switches,
    output [31:0] readData,
    output [15:0] leds
);

    wire dmread;
    wire dmwrite;
    wire ledEnable;
    wire switchEnable;

    wire [31:0] dmReadData;
    wire [31:0] switchReadData;

    // Address Decoder
    AddressDecoder decoder (
        .address(address[9:0]),
        .writeenable(writeEnable),
        .readenable(readEnable),
        .dmread(dmread),
        .dm(dmwrite),
        .leds(ledEnable),
        .switches(switchEnable)
    );

    // Data Memory
    DataMemory memory (
        .clk(clk),
        .rst(rst),
        .address(address),
        .writedata(writeData),
        .memwrite(dmwrite),
        .readdata(dmReadData)
    );

    // LED Interface
    switches led_interface (
        .clk(clk),
        .rst(rst),
        .writeData(writeData),
        .writeEnable(ledEnable),
        .readEnable(1'b0),
        .memAddress(address[29:0]),
        .readData(),
        .leds(leds)
    );

    // Physical Switch Interface
    leds switch_interface (
        .clk(clk),
        .rst(rst),
        .btns(16'b0),
        .writeData(32'b0),
        .writeEnable(1'b0),
        .readEnable(switchEnable),
        .memAddress(address[29:0]),
        .switches(switches),
        .readData(switchReadData)
    );

    // Read Data Selection
    assign readData = dmread ? dmReadData :
                      switchEnable ? switchReadData :
                      32'b0;

endmodule