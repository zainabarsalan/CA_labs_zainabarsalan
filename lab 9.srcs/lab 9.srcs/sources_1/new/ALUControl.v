
module ALUControl(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [3:0] ALUControl
);

always @(*) begin
    case (ALUOp)

        // Load and Store: address calculation using ADD
        2'b00: begin
            ALUControl = 4'b0000;
        end

        // BEQ: subtraction for comparison
        2'b01: begin
            ALUControl = 4'b0111;
        end

        // R-type instructions
        2'b10: begin
            case (funct3)

                // ADD and SUB
                3'b000: begin
                    if (funct7 == 7'b0100000)
                        ALUControl = 4'b0001; // SUB
                    else
                        ALUControl = 4'b0000; // ADD
                end

                // SLL
                3'b001: begin
                    ALUControl = 4'b0101;
                end

                // SRL
                3'b101: begin
                    if (funct7 == 7'b0000000)
                        ALUControl = 4'b0110; // SRL
                    else
                        ALUControl = 4'b0000; // Unsupported
                end

                // AND
                3'b111: begin
                    ALUControl = 4'b0010;
                end

                // OR
                3'b110: begin
                    ALUControl = 4'b0011;
                end

                // XOR
                3'b100: begin
                    ALUControl = 4'b0100;
                end

                default: begin
                    ALUControl = 4'b0000;
                end

            endcase
        end

        // I-type ALU instructions
        2'b11: begin
            case (funct3)

                // ADDI
                3'b000: begin
                    ALUControl = 4'b0000;
                end

                // SLLI
                3'b001: begin
                    ALUControl = 4'b0101;
                end

                // SRLI
                3'b101: begin
                    if (funct7 == 7'b0000000)
                        ALUControl = 4'b0110; // SRLI
                    else
                        ALUControl = 4'b0000; // Unsupported
                end

                // ANDI
                3'b111: begin
                    ALUControl = 4'b0010;
                end

                // ORI
                3'b110: begin
                    ALUControl = 4'b0011;
                end

                // XORI
                3'b100: begin
                    ALUControl = 4'b0100;
                end

                default: begin
                    ALUControl = 4'b0000;
                end

            endcase
        end

        default: begin
            ALUControl = 4'b0000;
        end

    endcase
end

endmodule
