`timescale 1ns / 1ps

module instructionMemory_tb;

    reg [31:0] instAddress;
    wire [31:0] instruction;

    instructionMemory uut (
        .instAddress(instAddress),
        .instruction(instruction)
    );

    integer i;

    initial begin
        instAddress = 0;
        #1;

        for (i = 0; i < 38; i = i + 1) begin

            instAddress = i * 4;
            #5;

            $display("PC=%02h instruction=%08h",
                     instAddress[7:0], instruction);

        end

        $finish;
    end

endmodule