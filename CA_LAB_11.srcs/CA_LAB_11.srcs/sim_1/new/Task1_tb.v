`timescale 1ns / 1ps

module Task1_tb;

reg clk;
reg rst;
reg PCSrc;
reg [31:0] instruction;
reg [1:0] ImmSrc;

wire [31:0] PC;
wire [31:0] pc_plus4;
wire [31:0] branchTarget;
wire [31:0] selectedPC;
wire [31:0] immediate;

ProgramCounter pc(
    .clk(clk),
    .rst(rst),
    .nextPC(selectedPC),
    .PC(PC)
);

pcAdder pc_add(
    .PC(PC),
    .nextPC(pc_plus4)
);

branchAdder branch_add(
    .PC(PC),
    .imm(immediate),
    .branchTarget(branchTarget)
);

mux2 pc_mux(
    .input0(pc_plus4),
    .input1(branchTarget),
    .select(PCSrc),
    .outputValue(selectedPC)
);

immGen imm_gen(
    .instruction(instruction),
    .ImmSrc(ImmSrc),
    .imm(immediate)
);

always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;
    PCSrc = 0;
    instruction = 0;
    ImmSrc = 0;

    #10;
    rst = 0;

    #10;
    $display("PC = %h, PC + 4 = %h", PC, pc_plus4);

    instruction = 32'h00500093;
    ImmSrc = 2'b00;
    #10;
    $display("I-type immediate = %d", immediate);

    instruction = 32'h00502023;
    ImmSrc = 2'b01;
    #10;
    $display("S-type immediate = %d", immediate);

    instruction = 32'h00208463;
    ImmSrc = 2'b10;
    #10;
    $display("B-type immediate = %d", immediate);

    PCSrc = 1;
    #1;
    $display("Branch target = %h", branchTarget);
    $display("Selected PC = %h", selectedPC);

    #9;
    $display("PC after branch = %h", PC);

    PCSrc = 0;
    #10;
    $display("Selected PC (PC + 4) = %h", selectedPC);

    $finish;

end

endmodule