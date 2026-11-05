
`timescale 1ns / 1ps

module instructionMemory #(
    parameter OPERAND_LENGTH = 31
)(
    input  [OPERAND_LENGTH:0] instAddress,
    output reg [31:0] instruction
);

    reg [7:0] memory [0:255];
    reg [31:0] prog [0:37];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 8'h00;
        end

        prog[0]  = 32'h100004B7;
        prog[1]  = 32'h10048913;
        prog[2]  = 32'h0004A023;
        prog[3]  = 32'h00500293;
        prog[4]  = 32'hFE028EE3;
        prog[5]  = 32'h00028413;
        prog[6]  = 32'h0084A023;
        prog[7]  = 32'h00040513;
        prog[8]  = 32'h008000EF;
        prog[9]  = 32'hFE9FF06F;
        prog[10] = 32'hFF810113;
        prog[11] = 32'h00112223;
        prog[12] = 32'h00812023;
        prog[13] = 32'h00050413;
        prog[14] = 32'h02040063;
        prog[15] = 32'h02C000EF;
        prog[16] = 32'h00051863;
        prog[17] = 32'hFFF40413;
        prog[18] = 32'h0084A023;
        prog[19] = 32'hFEDFF06F;
        prog[20] = 32'h0004A023;
        prog[21] = 32'h00000413;
        prog[22] = 32'h00012403;
        prog[23] = 32'h00412083;
        prog[24] = 32'h00810113;
        prog[25] = 32'h00008067;
        prog[26] = 32'h00300293;
        prog[27] = 32'h00300393;
        prog[28] = 32'h00092303;
        prog[29] = 32'h00031E63;
        prog[30] = 32'hFFF38393;
        prog[31] = 32'hFE039AE3;
        prog[32] = 32'hFFF28293;
        prog[33] = 32'hFE0294E3;
        prog[34] = 32'h00000513;
        prog[35] = 32'h00008067;
        prog[36] = 32'h00100513;
        prog[37] = 32'h00008067;

        for (i = 0; i < 38; i = i + 1) begin
            memory[4*i]   = prog[i][7:0];
            memory[4*i+1] = prog[i][15:8];
            memory[4*i+2] = prog[i][23:16];
            memory[4*i+3] = prog[i][31:24];
        end
    end

    always @(*) begin
        instruction = {
            memory[instAddress[7:0] + 3],
            memory[instAddress[7:0] + 2],
            memory[instAddress[7:0] + 1],
            memory[instAddress[7:0]]
        };
    end

endmodule
