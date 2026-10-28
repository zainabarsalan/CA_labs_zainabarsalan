
`timescale 1ns / 1ps

module ALUControl_tb;

reg [1:0] ALUOp;
reg [2:0] funct3;
reg [6:0] funct7;
reg [6:0] opcode;

wire RegWrite;
wire [1:0] ALUOp_main;
wire MemRead;
wire MemWrite;
wire ALUSrc;
wire MemtoReg;
wire Branch;
wire [3:0] ALUControl;

integer errors;

// Main Control Unit
MainControl uut_main(
    .opcode(opcode),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp_main),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .Branch(Branch)
);

// ALU Control Unit
ALUControl uut_alu(
    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7(funct7),
    .ALUControl(ALUControl)
);

// Test ALU Control outputs
task check_alu;
    input [1:0] op;
    input [2:0] f3;
    input [6:0] f7;
    input [3:0] expected;

    begin
        ALUOp = op;
        funct3 = f3;
        funct7 = f7;

        #10;

        if (ALUControl !== expected) begin
            $display("FAIL: ALUOp=%b funct3=%b funct7=%b got=%b expected=%b",
                     op, f3, f7, ALUControl, expected);
            errors = errors + 1;
        end
        else begin
            $display("PASS: ALUOp=%b funct3=%b ALUControl=%b",
                     op, f3, ALUControl);
        end
    end
endtask

initial begin

    errors = 0;

    ALUOp = 0;
    funct3 = 0;
    funct7 = 0;
    opcode = 0;

    #10;

    // Main Control: R-type
    opcode = 7'b0110011;
    #10;

    if (RegWrite !== 1'b1 || ALUOp_main !== 2'b10 ||
        MemRead !== 1'b0 || MemWrite !== 1'b0 ||
        ALUSrc !== 1'b0 || MemtoReg !== 1'b0 ||
        Branch !== 1'b0) begin
        $display("FAIL: R-type MainControl");
        errors = errors + 1;
    end
    else
        $display("PASS: R-type MainControl");

    // Main Control: I-type
    opcode = 7'b0010011;
    #10;

    if (RegWrite !== 1'b1 || ALUOp_main !== 2'b11 ||
        MemRead !== 1'b0 || MemWrite !== 1'b0 ||
        ALUSrc !== 1'b1 || MemtoReg !== 1'b0 ||
        Branch !== 1'b0) begin
        $display("FAIL: I-type MainControl");
        errors = errors + 1;
    end
    else
        $display("PASS: I-type MainControl");

    // Main Control: Load
    opcode = 7'b0000011;
    #10;

    if (RegWrite !== 1'b1 || ALUOp_main !== 2'b00 ||
        MemRead !== 1'b1 || MemWrite !== 1'b0 ||
        ALUSrc !== 1'b1 || MemtoReg !== 1'b1 ||
        Branch !== 1'b0) begin
        $display("FAIL: Load MainControl");
        errors = errors + 1;
    end
    else
        $display("PASS: Load MainControl");

    // Main Control: Store
    opcode = 7'b0100011;
    #10;

    if (RegWrite !== 1'b0 || ALUOp_main !== 2'b00 ||
        MemRead !== 1'b0 || MemWrite !== 1'b1 ||
        ALUSrc !== 1'b1 || MemtoReg !== 1'b0 ||
        Branch !== 1'b0) begin
        $display("FAIL: Store MainControl");
        errors = errors + 1;
    end
    else
        $display("PASS: Store MainControl");

    // Main Control: BEQ
    opcode = 7'b1100011;
    #10;

    if (RegWrite !== 1'b0 || ALUOp_main !== 2'b01 ||
        MemRead !== 1'b0 || MemWrite !== 1'b0 ||
        ALUSrc !== 1'b0 || MemtoReg !== 1'b0 ||
        Branch !== 1'b1) begin
        $display("FAIL: BEQ MainControl");
        errors = errors + 1;
    end
    else
        $display("PASS: BEQ MainControl");

    // R-type ALU operations
    check_alu(2'b10, 3'b000, 7'b0000000, 4'b0000); // ADD
    check_alu(2'b10, 3'b000, 7'b0100000, 4'b0001); // SUB
    check_alu(2'b10, 3'b001, 7'b0000000, 4'b0101); // SLL
    check_alu(2'b10, 3'b101, 7'b0000000, 4'b0110); // SRL
    check_alu(2'b10, 3'b111, 7'b0000000, 4'b0010); // AND
    check_alu(2'b10, 3'b110, 7'b0000000, 4'b0011); // OR
    check_alu(2'b10, 3'b100, 7'b0000000, 4'b0100); // XOR

    // I-type ALU operations
    check_alu(2'b11, 3'b000, 7'b0000000, 4'b0000); // ADDI
    check_alu(2'b11, 3'b001, 7'b0000000, 4'b0101); // SLLI
    check_alu(2'b11, 3'b101, 7'b0000000, 4'b0110); // SRLI
    check_alu(2'b11, 3'b111, 7'b0000000, 4'b0010); // ANDI
    check_alu(2'b11, 3'b110, 7'b0000000, 4'b0011); // ORI
    check_alu(2'b11, 3'b100, 7'b0000000, 4'b0100); // XORI

    // Load/store address calculation
    check_alu(2'b00, 3'b010, 7'b0000000, 4'b0000);

    // BEQ comparison
    check_alu(2'b01, 3'b000, 7'b0000000, 4'b0111);

    // Final result
    if (errors == 0)
        $display("ALL ALU CONTROL TESTS PASSED");
    else
        $display("ALU CONTROL TESTS FAILED: %0d error(s)", errors);

    $finish;

end

endmodule

