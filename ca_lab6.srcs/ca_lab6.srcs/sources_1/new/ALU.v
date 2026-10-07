`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//

module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg Zero
);

    always @(*) begin
        case (ALUControl)
            4'b0000: ALUResult = A + B; //ADD
            4'b0001: ALUResult = A - B;//sub
            4'b0010: ALUResult = A & B;//and
            4'b0011: ALUResult = A | B;//or          
            4'b0100: ALUResult = A ^ B;//xor
            4'b0101:  ALUResult = A << B[4:0];//sll (*2)
            4'b0110: ALUResult = A >> B[4:0];//srl 
            4'b0111: ALUResult = A - B; //beq
            default: ALUResult = 32'd0;
            
        endcase
        if (ALUResult == 32'd0)
            Zero = 1'b1;// flag zero=1
        else
            Zero = 1'b0;//flag zero=0

    end

endmodule

