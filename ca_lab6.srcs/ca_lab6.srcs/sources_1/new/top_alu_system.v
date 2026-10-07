`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
////////////////////////////////////////////////////////////

module top_alu_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

   
    wire rst_clean;
    wire [31:0] switch_data;
    reg [31:0] led_write_data = 32'd0;
    wire slow_clk;

    
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] ALUControl;

    wire [31:0] ALUResult;
    wire Zero;

    // FSM state
    reg [2:0] state;


    
    always @(*) begin
        A = {28'd0, switch_data[3:0]};
        B = {28'd0, switch_data[7:4]};
    end


    // DEBOUNCER
    debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)
    );


    // SWITCH INTERFACE
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


    // LED INTERFACE
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


    // CLOCK DIVIDER
    clock_divider ticker (
        .clk_in(clk),
        .rst(rst_clean),
        .clk_out(slow_clk)
    );


    // ALU
    ALU alu_unit (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );


    // FSM
    always @(posedge slow_clk or posedge rst_clean) begin

        if (rst_clean) begin
            state <= 3'd0;
            ALUControl <= 4'b0000;
            led_write_data <= 32'd0;
        end

        else begin

            
            ALUControl <= switch_data[15:12];

            
            led_write_data[14:0] <= ALUResult[14:0];
            led_write_data[15] <= Zero;

            // FSM cycles through 8 states
            if (state == 3'd7)
                state <= 3'd0;
            else
                state <= state + 3'd1;

        end

    end

endmodule