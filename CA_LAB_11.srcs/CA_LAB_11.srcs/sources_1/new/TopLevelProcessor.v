`timescale 1ns / 1ps

module TopLevelProcessor(
    input clk,
    input rst,
    output [31:0] PC_out,
    output [31:0] instruction_out
);

    // PC wires
    wire [31:0] PC;
    wire [31:0] pc_plus4;
    wire [31:0] branchTarget;
    wire [31:0] selectedPC;
    wire [31:0] jalrTarget;
    wire [31:0] PC_branch;

    // Instruction fields
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] funct7;

    // Control signals
    wire RegWrite;
    wire [1:0] ALUOp;
    wire MemRead;
    wire MemWrite;
    wire ALUSrc;
    wire MemtoReg;
    wire Branch;
    wire Jump;
    wire Jalr;

    // Immediate generator
    wire [1:0] ImmSrc;
    wire [31:0] imm;
    wire [31:0] immGenerated;

    // Register file
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] WriteData;
    wire [31:0] ResultData;

    // ALU
    wire [31:0] ALU_B;
    wire [3:0] ALUCtrl;
    wire [31:0] ALUResult;
    wire Zero;

    // Data memory
    wire [31:0] MemReadData;

    // Branch control
    wire PCSrc;


    // 1. Program Counter

    ProgramCounter pc_reg(
        .clk(clk),
        .rst(rst),
        .nextPC(selectedPC),
        .PC(PC)
    );


    // 2. PC + 4

    pcAdder pc_add(
        .PC(PC),
        .nextPC(pc_plus4)
    );


    // 3. Instruction Memory

    instructionMemory imem(
        .instAddress(PC),
        .instruction(instruction_out)
    );


    // 4. Instruction fields

    assign opcode = instruction_out[6:0];
    assign rd = instruction_out[11:7];
    assign funct3 = instruction_out[14:12];
    assign rs1 = instruction_out[19:15];
    assign rs2 = instruction_out[24:20];
    assign funct7 = instruction_out[31:25];


    // 5. Main Control

    MainControl main_ctrl(
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch),
        .Jump(Jump),
        .Jalr(Jalr)
    );


    // 6. Immediate source selection

    assign ImmSrc =
        (opcode == 7'b0100011) ? 2'b01 :
        (opcode == 7'b1100011) ? 2'b10 :
        (opcode == 7'b1101111) ? 2'b11 :
        2'b00;


    // 7. Immediate Generator

    immGen imm_gen(
        .instruction(instruction_out),
        .ImmSrc(ImmSrc),
        .imm(immGenerated)
    );


    // LUI immediate

    assign imm = (opcode == 7'b0110111) ?
                 {instruction_out[31:12], 12'b0} :
                 immGenerated;


    // 8. Register File

    RegisterFile rf(
        .clk(clk),
        .rst(rst),
        .WriteEnable(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );


    // 9. ALU Control

    ALUControl alu_ctrl(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUCtrl)
    );


    // 10. ALU input selection

    mux2 alu_mux(
        .input0(ReadData2),
        .input1(imm),
        .select(ALUSrc),
        .outputValue(ALU_B)
    );


    // 11. ALU

    ALU alu(
        .A(ReadData1),
        .B(ALU_B),
        .ALUControl(ALUCtrl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );


    // 12. Data Memory

    DataMemory data_mem(
        .clk(clk),
        .address(ALUResult),
        .writedata(ReadData2),
        .memwrite(MemWrite),
        .readdata(MemReadData)
    );


    // 13. Writeback selection: ALU or Memory

    mux2 wb_mux(
        .input0(ALUResult),
        .input1(MemReadData),
        .select(MemtoReg),
        .outputValue(ResultData)
    );


    // 14. Writeback selection: normal result or PC + 4

    mux2 link_mux(
        .input0(ResultData),
        .input1(pc_plus4),
        .select(Jump | Jalr),
        .outputValue(WriteData)
    );


    // 15. Branch and Jump Target

    branchAdder branch_add(
        .PC(PC),
        .imm(imm),
        .branchTarget(branchTarget)
    );


    // 16. Branch Control

    BranchControl branch_ctrl(
        .Branch(Branch),
        .Jump(Jump),
        .funct3(funct3),
        .Zero(Zero),
        .PCSrc(PCSrc)
    );


    // 17. Select PC + 4 or Branch/Jump Target

    mux2 pc_mux(
        .input0(pc_plus4),
        .input1(branchTarget),
        .select(PCSrc),
        .outputValue(PC_branch)
    );


    // 18. JALR Target

    assign jalrTarget = {ALUResult[31:1], 1'b0};


    // 19. Final PC selection

    mux2 jalr_mux(
        .input0(PC_branch),
        .input1(jalrTarget),
        .select(Jalr),
        .outputValue(selectedPC)
    );


    // Outputs

    assign PC_out = PC;

endmodule