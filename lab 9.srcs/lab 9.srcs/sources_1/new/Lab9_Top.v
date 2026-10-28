
`timescale 1ns / 1ps

module Lab9_Top (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // Lab 5 modules: keep their original files unchanged
    wire rst_clean;

    debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)
    );

    wire slow_clk;

    clock_divider ticker (
        .clk_in(clk),
        .rst(rst_clean),
        .clk_out(slow_clk)
    );

    // Read the physical switches using the Lab 5 leds module
    wire [31:0] switch_data;

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

    // Instruction fields selected using the switches
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = switch_data[6:0];
    assign funct3 = switch_data[9:7];
    assign funct7 = {1'b0, switch_data[15:10]};

    // Main Control Unit
    wire RegWrite;
    wire [1:0] ALUOp_main;
    wire MemRead;
    wire MemWrite;
    wire ALUSrc;
    wire MemtoReg;
    wire Branch;

    MainControl main_control (
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
    wire [3:0] ALUControl_signal;

    ALUControl alu_control (
        .ALUOp(ALUOp_main),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl_signal)
    );

    // FSM states
    reg state;

    parameter READ_INPUT = 1'b0;
    parameter UPDATE_LEDS = 1'b1;

    reg [31:0] led_write_data = 32'd0;

    always @(posedge slow_clk or posedge rst_clean) begin
        if (rst_clean) begin
            state <= READ_INPUT;
            led_write_data <= 32'd0;
        end
        else begin
            case (state)

                READ_INPUT: begin
                    state <= UPDATE_LEDS;
                end

                UPDATE_LEDS: begin
                    led_write_data <= {
                        4'b0000,
                        RegWrite,
                        ALUOp_main,
                        MemRead,
                        MemWrite,
                        ALUSrc,
                        MemtoReg,
                        Branch,
                        ALUControl_signal
                    };

                    state <= READ_INPUT;
                end

                default: begin
                    state <= READ_INPUT;
                    led_write_data <= 32'd0;
                end

            endcase
        end
    end

    // Write results to the physical LEDs using the Lab 5 switches module
    switches led_writer (
        .clk(slow_clk),
        .rst(rst_clean),
        .writeData(led_write_data),
        .writeEnable(1'b1),
        .readEnable(1'b0),
        .memAddress(30'd0),
        .readData(),
        .leds(physical_leds)
    );

endmodule
