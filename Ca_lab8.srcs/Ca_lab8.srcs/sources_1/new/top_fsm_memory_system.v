`timescale 1ns / 1ps

module top_fsm_memory_system(
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // Button signal
    wire button;

    debouncer button_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(button)
    );

    // Generate a one-clock-cycle pulse when the button is pressed
    reg button_prev = 1'b0;

    always @(posedge clk) begin
        button_prev <= button;
    end

    wire accessPulse;
    assign accessPulse = button && !button_prev;

    // Startup reset
    reg [1:0] startup_count = 2'b00;

    always @(posedge clk) begin
        if (startup_count != 2'b11)
            startup_count <= startup_count + 1'b1;
    end

    wire rst;
    assign rst = (startup_count != 2'b11);

    // Physical switch configuration:
    // SW[9:0]  = address
    // SW[14:10] = 5-bit write data
    // SW[15] = 1 for write, 0 for read

    wire [9:0] address;
    wire [31:0] writeData;
    wire readEnable;
    wire writeEnable;

    assign address = physical_sw[9:0];
    assign writeData = {27'b0, physical_sw[14:10]};

    assign writeEnable = accessPulse && physical_sw[15];
    assign readEnable = accessPulse && !physical_sw[15];

    // Address decoder signals
    wire dmread;
    wire dmwrite;
    wire ledEnable;
    wire switchEnable;

    // Read data
    wire [31:0] dmReadData;
    wire [31:0] switchReadData;
    wire [31:0] readData;

    // Stored LED output
    wire [15:0] ledOutput;

    // Address Decoder
    AddressDecoder decoder (
        .address(address),
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
        .address({22'b0, address}),
        .writedata(writeData),
        .memwrite(dmwrite),
        .readdata(dmReadData)
    );

    // Lab 5 LED Interface
    switches led_writer (
        .clk(clk),
        .rst(rst),
        .writeData(writeData),
        .writeEnable(ledEnable),
        .readEnable(1'b0),
        .memAddress(30'b0),
        .readData(),
        .leds(ledOutput)
    );

    // Lab 5 Switch Interface
    leds switch_reader (
        .clk(clk),
        .rst(rst),
        .btns(16'b0),
        .writeData(32'b0),
        .writeEnable(1'b0),
        .readEnable(switchEnable),
        .memAddress(30'b0),
        .switches(physical_sw),
        .readData(switchReadData)
    );

    // Read data selection
    assign readData = dmread ? dmReadData :
                      switchEnable ? switchReadData :
                      32'b0;

    // Display LED writes or the selected read result
    assign physical_leds =
        (address[9:8] == 2'b10) ? ledOutput :
        readData[15:0];

endmodule