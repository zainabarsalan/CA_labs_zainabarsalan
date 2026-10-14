`timescale 1ns / 1ps

module RF_ALU_FSM_tb;

    reg clk;
    reg rst;

    top_rf_alu dut (
        .clk(clk),
        .rst(rst)
    );


   
    always #5 clk = ~clk;
    initial begin

        clk = 0;
        rst = 1;

        #10;
        rst = 0;


        #30;


        // Check x1
        if (dut.rf.regs[1] == 32'h10101010)
            $display("x1 WRITE PASSED");
        else
            $display("x1 WRITE FAILED");


        // Check x2
        if (dut.rf.regs[2] == 32'h01010101)
            $display("x2 WRITE PASSED");
        else
            $display("x2 WRITE FAILED");


        // ADD
        #20;

        if (dut.rf.regs[4] == 32'h11111111)
            $display("ADD ? x4 PASSED");
        else
            $display("ADD ? x4 FAILED");


        // SUB
        #10;

        if (dut.rf.regs[5] == 32'h0F0F0F0F)
            $display("SUB ? x5 PASSED");
        else
            $display("SUB ? x5 FAILED");


        // AND
        #10;

        if (dut.rf.regs[6] == 32'h00000000)
            $display("AND ? x6 PASSED");
        else
            $display("AND ? x6 FAILED");


        // OR
        #10;

        if (dut.rf.regs[7] == 32'h11111111)
            $display("OR ? x7 PASSED");
        else
            $display("OR ? x7 FAILED");


        // XOR
        #10;

        if (dut.rf.regs[8] == 32'h11111111)
            $display("XOR ? x8 PASSED");
        else
            $display("XOR ? x8 FAILED");


        // SLL
        #10;

        if (dut.rf.regs[9] == 32'h20202020)
            $display("SLL ? x9 PASSED");
        else
            $display("SLL ? x9 FAILED");


        // SRL
        #10;

        if (dut.rf.regs[10] == 32'h08080808)
            $display("SRL ? x10 PASSED");
        else
            $display("SRL ? x10 FAILED");


        // BEQ
        #10;

        if (dut.Zero == 1'b1)
            $display("BEQ PASSED");
        else
            $display("BEQ FAILED");


        // Flag write
        #10;

        if (dut.rf.regs[11] == 32'd1)
            $display("FLAG WRITE PASSED");
        else
            $display("FLAG WRITE FAILED");

               // Read-after-write
        wait (dut.state == 4'd13);
        #1;
        
        if (dut.ReadData1 == 32'h08080808)
            $display("READ-AFTER-WRITE PASSED");
        else
            $display("READ-AFTER-WRITE FAILED");
        #20;

        $finish;

    end

endmodule