
`timescale 1ns / 1ps

module MemorySystem_tb;

    reg clk;
    reg rst;
    reg [31:0] address;
    reg [31:0] writedata;
    reg writeenable;
    reg readenable;
    reg [15:0] physical_switches;

    wire dmread;
    wire dm;
    wire led_enable;
    wire switch_enable;

    wire [31:0] dm_readdata;
    wire [31:0] led_readdata;
    wire [31:0] switch_readdata;
    wire [31:0] readdata;

    wire [15:0] physical_leds;

    // Address Decoder
    AddressDecoder decoder (
        .address(address[9:0]),
        .writeenable(writeenable),
        .readenable(readenable),
        .dmread(dmread),
        .dm(dm),
        .leds(led_enable),
        .switches(switch_enable)
    );

    // Data Memory
    DataMemory memory (
        .clk(clk),
        .rst(rst),
        .address(address),
        .writedata(writedata),
        .memwrite(dm),
        .readdata(dm_readdata)
    );

    // LED Interface
    switches led_interface (
        .clk(clk),
        .rst(rst),
        .writeData(writedata),
        .writeEnable(led_enable),
        .readEnable(1'b0),
        .memAddress(address[29:0]),
        .readData(),
        .leds(physical_leds)
    );

    // Physical Switch Interface
    leds switch_interface (
        .clk(clk),
        .rst(rst),
        .btns(16'd0),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(switch_enable),
        .memAddress(address[29:0]),
        .switches(physical_switches),
        .readData(switch_readdata)
    );

    // Read Data Multiplexer
    assign readdata =
        (dmread) ? dm_readdata :
        (switch_enable) ? switch_readdata :
        32'b0;

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        rst = 1;
        address = 0;
        writedata = 0;
        writeenable = 0;
        readenable = 0;
        physical_switches = 16'h000F;

        #10;
        rst = 0;

        // Test 1: Data Memory Write
        @(negedge clk);
        address = 10;
        writedata = 32'h12345678;
        writeenable = 1;
        readenable = 0;

        @(negedge clk);
        writeenable = 0;
        readenable = 1;

        @(posedge clk);
        #1;

        if (readdata == 32'h12345678)
            $display("PASS: Data Memory read/write");
        else
            $display("FAIL: Data Memory read/write. Got %h", readdata);

        // Test 2: LED Write
        @(negedge clk);
        address = 520;
        writedata = 32'h000000A5;
        writeenable = 1;
        readenable = 0;

        @(posedge clk);
        #1;

        if (physical_leds == 16'h00A5)
            $display("PASS: LED write");
        else
            $display("FAIL: LED write. Got %h", physical_leds);

        // Test 3: Switch Read
        @(negedge clk);
        address = 800;
        writeenable = 0;
        readenable = 1;

        #1;

        if (switch_enable == 1 && readdata == 32'h0000000F)
            $display("PASS: Switch read");
        else
            $display("FAIL: Switch read. Got %h", readdata);

        #10;
        $finish;

    end

endmodule