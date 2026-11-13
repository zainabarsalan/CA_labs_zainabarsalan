`timescale 1ns / 1ps

module immGen(
    input [31:0] instruction,
    input [1:0] ImmSrc,
    output reg [31:0] imm
);

always @(*) begin

    case (ImmSrc)

        2'b00: imm = {{20{instruction[31]}}, instruction[31:20]};

        2'b01: imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

        2'b10: imm = {{20{instruction[31]}}, instruction[31], instruction[7],
                      instruction[30:25], instruction[11:8]};

        2'b11: imm = {{12{instruction[31]}}, instruction[31],
                      instruction[19:12], instruction[20], instruction[30:21]};

        default: imm = 32'd0;

    endcase

end

endmodule
