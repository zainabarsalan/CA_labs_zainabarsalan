`timescale 1ns / 1ps

module tb_instructionMemory;

    reg [31:0] pc = 0;
    wire [31:0] instruction;

    instructionMemory uut(
        .instAddress(pc),
        .instruction(instruction)
    );

    integer i;

    initial begin
        #1;

        for (i = 0; i < 38; i = i + 1) begin
            pc = i * 4;
            #5;
            $display("PC=0x%02h instruction=%08h", pc[7:0], instruction);
        end

        $finish;
    end

endmodule
