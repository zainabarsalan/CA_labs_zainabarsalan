`timescale 1ns / 1ps

module RegisterFile_tb;

    reg clk;
    reg rst;
    reg WriteEnable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] WriteData;

    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    RegisterFile uut (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    
    always #5 clk = ~clk;

    initial begin
         
        clk = 0;
        rst = 1;
        WriteEnable = 0;
        rs1 = 0;
        rs2 = 0;
        rd = 0;
        WriteData = 0;

        
        #10;
        rst = 0;

        WriteEnable = 1;
        rd = 5;
        WriteData = 32'hDEADBEEF;
        #10;
        WriteEnable = 0;
        rs1 = 5;
        #1;
        if (ReadData1 == 32'hDEADBEEF)
            $display("TEST 1 PASSED");
        else
            $display("TEST 1 FAILED");

        
        WriteEnable = 1;
        rd = 0;
        WriteData = 32'hFFFFFFFF;
        #10;
        WriteEnable = 0;
        rs1 = 0;
        #1;
        if (ReadData1 == 32'h0)
            $display("TEST 2 PASSED");
        else
            $display("TEST 2 FAILED");

   
        rs1 = 5;
        rs2 = 5;
        #1;
        if (ReadData1 == 32'hDEADBEEF && ReadData2 == 32'hDEADBEEF)
            $display("TEST 3 PASSED");
        else
            $display("TEST 3 FAILED");

        
        WriteEnable = 1;
        rd = 5;
        WriteData = 32'h12345678;
        #10;
        WriteEnable = 0;
        rs1 = 5;
        #1;
        if (ReadData1 == 32'h12345678)
            $display("TEST 4 PASSED");
        else
            $display("TEST 4 FAILED");

        $finish;
    end

endmodule