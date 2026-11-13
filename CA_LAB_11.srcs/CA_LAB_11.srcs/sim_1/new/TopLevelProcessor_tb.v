`timescale 1ns / 1ps

module TopLevelProcessor_tb;

    reg clk;
    reg rst;

    wire [31:0] PC_out;
    wire [31:0] instruction_out;

    TopLevelProcessor uut(
        .clk(clk),
        .rst(rst),
        .PC_out(PC_out),
        .instruction_out(instruction_out)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;

        $display("Starting Processor Simulation");

        #20;
        rst = 0;

        repeat (100) begin
            @(posedge clk);
            #1;

            $display(
                "Time = %0t | PC = %h | Instruction = %h",
                $time, PC_out, instruction_out
            );
        end

        $display("Processor Simulation Finished");

        $finish;

    end

endmodule