
`timescale 1ns / 1ps

module MainControl_tb;

reg [6:0] opcode;
wire RegWrite;
wire [1:0] ALUOp;
wire MemRead;
wire MemWrite;
wire ALUSrc;
wire MemtoReg;
wire Branch;

MainControl test(
    .opcode(opcode),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .Branch(Branch)
);

initial begin
    opcode = 7'b0110011;
    #10;
    $display("R-type: opcode=%b (%0d), RegWrite=%b, ALUOp=%b",
             opcode, opcode, RegWrite, ALUOp);

    opcode = 7'b0010011;
    #10;
    $display("ADDI: opcode=%b (%0d), RegWrite=%b, ALUOp=%b, ALUSrc=%b",
             opcode, opcode, RegWrite, ALUOp, ALUSrc);

    opcode = 7'b0000011;
    #10;
    $display("LOAD: opcode=%b (%0d), RegWrite=%b, ALUOp=%b, MemRead=%b, MemWrite=%b, ALUSrc=%b, MemtoReg=%b, Branch=%b",
             opcode, opcode, RegWrite, ALUOp, MemRead, MemWrite, ALUSrc, MemtoReg, Branch);

    opcode = 7'b0100011;
    #10;
    $display("STORE: opcode=%b (%0d), RegWrite=%b, ALUOp=%b, MemRead=%b, MemWrite=%b, ALUSrc=%b, MemtoReg=%b, Branch=%b",
             opcode, opcode, RegWrite, ALUOp, MemRead, MemWrite, ALUSrc, MemtoReg, Branch);

    opcode = 7'b1100011;
    #10;
    $display("BEQ: opcode=%b (%0d), RegWrite=%b, ALUOp=%b, MemRead=%b, MemWrite=%b, ALUSrc=%b, MemtoReg=%b, Branch=%b",
             opcode, opcode, RegWrite, ALUOp, MemRead, MemWrite, ALUSrc, MemtoReg, Branch);

    $finish;
end

endmodule
