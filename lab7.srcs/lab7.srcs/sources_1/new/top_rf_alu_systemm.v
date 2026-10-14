`timescale 1ns / 1ps

module top_rf_alu_systemm (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    wire rst_clean;
    wire slow_clk;
    wire [31:0] switch_data;

    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] ALUResult;
    wire Zero;

    reg WriteEnable;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] WriteData;
    reg [3:0] ALUControl;
    reg [3:0] state;

    reg [31:0] led_write_data = 32'd0;

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
    localparam READ_STATE = 4'd12;
    localparam DONE       = 4'd13;

    debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)
    );

    leds switch_reader (
        .clk(clk),
        .rst(rst_clean),
        .btns(16'd0),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(1'b1),
        .memAddress(30'd0),
        .switches(physical_sw),
        .readData(switch_data)
    );

    clock_divider ticker (
        .clk_in(clk),
        .rst(rst_clean),
        .clk_out(slow_clk)
    );

    RegisterFile rf (
        .clk(slow_clk),
        .rst(rst_clean),
        .WriteEnable(WriteEnable),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    ALU alu_unit (
        .A(ReadData1),
        .B(ReadData2),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    always @(posedge slow_clk or posedge rst_clean) begin
        if (rst_clean)
            state <= IDLE;
        else begin
            case (state)
                IDLE:       state <= WRITE_X1;
                WRITE_X1:  state <= WRITE_X2;
                WRITE_X2:  state <= WRITE_X3;
                WRITE_X3:  state <= ADD_STATE;
                ADD_STATE: state <= SUB_STATE;
                SUB_STATE: state <= AND_STATE;
                AND_STATE: state <= OR_STATE;
                OR_STATE:  state <= XOR_STATE;
                XOR_STATE: state <= SLL_STATE;
                SLL_STATE: state <= SRL_STATE;
                SRL_STATE: state <= BEQ_STATE;
                BEQ_STATE: state <= READ_STATE;
                READ_STATE: state <= DONE;
                DONE:      state <= DONE;
                default:   state <= IDLE;
            endcase
        end
    end

    always @(*) begin
        WriteEnable = 1'b0;
        rs1 = 5'd1;
        rs2 = 5'd2;
        rd = 5'd0;
        WriteData = 32'd0;
        ALUControl = 4'b0000;

        case (state)
            WRITE_X1: begin
                WriteEnable = 1'b1;
                rd = 5'd1;
                WriteData = 32'h10101010;
            end

            WRITE_X2: begin
                WriteEnable = 1'b1;
                rd = 5'd2;
                WriteData = 32'h01010101;
            end

            WRITE_X3: begin
                WriteEnable = 1'b1;
                rd = 5'd3;
                WriteData = 32'h00000005;
            end

            ADD_STATE: begin
                ALUControl = 4'b0000;
                WriteEnable = 1'b1;
                rd = 5'd4;
                WriteData = ALUResult;
            end

            SUB_STATE: begin
                ALUControl = 4'b0001;
                WriteEnable = 1'b1;
                rd = 5'd5;
                WriteData = ALUResult;
            end

            AND_STATE: begin
                ALUControl = 4'b0010;
                WriteEnable = 1'b1;
                rd = 5'd6;
                WriteData = ALUResult;
            end

            OR_STATE: begin
                ALUControl = 4'b0011;
                WriteEnable = 1'b1;
                rd = 5'd7;
                WriteData = ALUResult;
            end

            XOR_STATE: begin
                ALUControl = 4'b0100;
                WriteEnable = 1'b1;
                rd = 5'd8;
                WriteData = ALUResult;
            end

            SLL_STATE: begin
                ALUControl = 4'b0101;
                WriteEnable = 1'b1;
                rd = 5'd9;
                WriteData = ALUResult;
            end

            SRL_STATE: begin
                ALUControl = 4'b0110;
                WriteEnable = 1'b1;
                rd = 5'd10;
                WriteData = ALUResult;
            end

            BEQ_STATE: begin
                rs1 = 5'd1;
                rs2 = 5'd1;
                ALUControl = 4'b0111;

                if (Zero) begin
                    WriteEnable = 1'b1;
                    rd = 5'd11;
                    WriteData = 32'd1;
                end
            end

            READ_STATE: begin
                rs1 = 5'd10;
                rs2 = 5'd0;
            end

            DONE: begin
                if (physical_sw[15]) begin
                    rs1 = physical_sw[13:9];
                    rs2 = physical_sw[14] ? 5'd1 : 5'd2;
                    rd = physical_sw[8:4];
                    ALUControl = {1'b0, switch_data[2:0]};

                    if (physical_sw[3]) begin
                        WriteEnable = 1'b1;
                        WriteData = ALUResult;
                    end
                end
                else begin
                    rs1 = 5'd10;
                    rs2 = 5'd0;
                end
            end

            default: begin
                WriteEnable = 1'b0;
            end
        endcase
    end

    always @(*) begin
        led_write_data = 32'd0;
        led_write_data[3:0] = state;
        led_write_data[14:4] = ALUResult[10:0];
        led_write_data[15] = Zero;
    end

    switches led_writer (
        .clk(clk),
        .rst(rst_clean),
        .writeData(led_write_data),
        .writeEnable(1'b1),
        .readEnable(1'b0),
        .memAddress(30'd0),
        .readData(),
        .leds(physical_leds)
    );

endmodule