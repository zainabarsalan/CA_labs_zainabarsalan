`timescale 1ns / 1ps

module top_rf_alu (
    input wire clk,
    input wire rst
);

 
    reg WriteEnable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] WriteData;

    wire [31:0] ReadData1;
    wire [31:0] ReadData2;


  
    reg [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire Zero;


  
    reg [3:0] state;
    reg [3:0] next_state;

    localparam IDLE       = 4'd0;
    localparam WRITE_X1   = 4'd1;
    localparam WRITE_X2   = 4'd2;
    localparam WRITE_X3   = 4'd3;

    localparam ADD_STATE  = 4'd4;
    localparam SUB_STATE  = 4'd5;
    localparam AND_STATE  = 4'd6;
    localparam OR_STATE   = 4'd7;
    localparam XOR_STATE  = 4'd8;
    localparam SLL_STATE  = 4'd9;
    localparam SRL_STATE  = 4'd10;

    localparam BEQ_STATE  = 4'd11;
    localparam FLAG_STATE = 4'd12;
    localparam READ_STATE = 4'd13;



    RegisterFile rf (
        .clk(clk),
        .rst(rst),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );


    
    ALU alu (
        .A(ReadData1),
        .B(ReadData2),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );


    
    always @(posedge clk) begin

        if (rst)
            state <= IDLE;

        else
            state <= next_state;

    end


    always @(*) begin

        case (state)

            IDLE:
                next_state = WRITE_X1;

            WRITE_X1:
                next_state = WRITE_X2;

            WRITE_X2:
                next_state = WRITE_X3;

            WRITE_X3:
                next_state = ADD_STATE;

            ADD_STATE:
                next_state = SUB_STATE;

            SUB_STATE:
                next_state = AND_STATE;

            AND_STATE:
                next_state = OR_STATE;

            OR_STATE:
                next_state = XOR_STATE;

            XOR_STATE:
                next_state = SLL_STATE;

            SLL_STATE:
                next_state = SRL_STATE;

            SRL_STATE:
                next_state = BEQ_STATE;

            BEQ_STATE:
                next_state = FLAG_STATE;

            FLAG_STATE:
                next_state = READ_STATE;

            READ_STATE:
                next_state = ADD_STATE;

            default:
                next_state = IDLE;

        endcase

    end


  
    always @(*) begin

        
        WriteEnable = 0;

        rs1 = 0;
        rs2 = 0;
        rd = 0;

        WriteData = 0;

        ALUControl = 4'b0000;


        case (state)

            // x1 = 10101010
            WRITE_X1: begin

                WriteEnable = 1;
                rd = 5'd1;
                WriteData = 32'h10101010;

            end


            // x2 = 01010101
            WRITE_X2: begin

                WriteEnable = 1;
                rd = 5'd2;
                WriteData = 32'h01010101;

            end


            // x3 = 5
            WRITE_X3: begin

                WriteEnable = 1;
                rd = 5'd3;
                WriteData = 32'h00000005;

            end

            ADD_STATE: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUControl = 4'b0000;

                WriteEnable = 1;
                rd = 5'd4;
                WriteData = ALUResult;

            end


            // SUB ? x5
            SUB_STATE: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUControl = 4'b0001;

                WriteEnable = 1;
                rd = 5'd5;
                WriteData = ALUResult;

            end


            // AND ? x6
            AND_STATE: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUControl = 4'b0010;

                WriteEnable = 1;
                rd = 5'd6;
                WriteData = ALUResult;

            end


            // OR ? x7
            OR_STATE: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUControl = 4'b0011;

                WriteEnable = 1;
                rd = 5'd7;
                WriteData = ALUResult;

            end


            // XOR ? x8
            XOR_STATE: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUControl = 4'b0100;

                WriteEnable = 1;
                rd = 5'd8;
                WriteData = ALUResult;

            end


            // SLL ? x9
            SLL_STATE: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUControl = 4'b0101;

                WriteEnable = 1;
                rd = 5'd9;
                WriteData = ALUResult;

            end


            // SRL ? x10
            SRL_STATE: begin

                rs1 = 5'd1;
                rs2 = 5'd2;

                ALUControl = 4'b0110;

                WriteEnable = 1;
                rd = 5'd10;
                WriteData = ALUResult;

            end


            // BEQ
            // Compare x1 with x1
            // They are equal, so Zero = 1
            BEQ_STATE: begin

                rs1 = 5'd1;
                rs2 = 5'd1;

                ALUControl = 4'b0111;

            end


            // If BEQ is true, write 1 into x11
            FLAG_STATE: begin

                if (Zero == 1'b1) begin

                    WriteEnable = 1;
                    rd = 5'd11;
                    WriteData = 32'd1;

                end

            end


      
            READ_STATE: begin

                rs1 = 5'd10;

            end

        endcase

    end

endmodule