`timescale 1ns / 1ps


module ALU_tb;

    reg [31:0] A; //32 bit A
    reg [31:0] B;// 32 bit B
    reg [3:0] ALUControl; //4 bit alu 

    wire [31:0] ALUResult; //32 bit result
    wire Zero;

    ALU dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    initial begin
        A = 32'd5;//A=5
        B = 32'd3;//B=3
        ALUControl = 4'b0000;//ADD
        #10;//10 NS WAIT TIME

        A = 32'd9;// A=9
        B = 32'd4;//B=4
        ALUControl = 4'b0001;//SUB
        #10;//WAIT TIME

        A = 32'd6;//A=6
        B = 32'd3;//B=3
        ALUControl = 4'b0010; //AND
        #10;

       
        A = 32'd4;//A=4
        B = 32'd1;//B=1
        ALUControl = 4'b0011;//OR
        #10;

        
        A = 32'd7; //A=7
        B = 32'd2;//B=2
        ALUControl = 4'b0100;//XOR
        #10;

        
        A = 32'd3;//A=3
        B = 32'd1;//B=1`
        ALUControl = 4'b0101;//SLL
        #10;

        
        A = 32'd16;//A=16
        B = 32'd2; //B=2
        ALUControl = 4'b0110; //SRL
        #10;

        
        A = 32'd5;//A=5
        B = 32'd5;//B=5
        ALUControl = 4'b0111;//BEQ =SAME
        #10;

        
        A = 32'd8;//A=8
        B = 32'd3;//B=3
        ALUControl = 4'b0111;//BEQ BUT DIFF NUMBERS
        #10;

        $finish;                                                  

    end

endmodule
