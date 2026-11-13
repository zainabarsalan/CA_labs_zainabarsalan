`timescale 1ns / 1ps

module BranchControl(
    input Branch,
    input Jump,
    input [2:0] funct3,
    input Zero,
    output reg PCSrc
);

always @(*) begin

    if (Jump)
        PCSrc = 1'b1;

    else if (Branch) begin

        case (funct3)

            3'b000: PCSrc = Zero;
            3'b001: PCSrc = ~Zero;

            default: PCSrc = 1'b0;

        endcase

    end

    else
        PCSrc = 1'b0;

end

endmodule