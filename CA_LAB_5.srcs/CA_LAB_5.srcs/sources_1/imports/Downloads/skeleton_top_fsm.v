`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Muddassir Ali
//
// Module Name: top_fsm_system
// Project Name: Counter
// Target Devices: Baasys 3
//
//////////////////////////////////////////////////////////////////////////////////

module top_fsm_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // DEBOUNCER
    wire rst_clean;
    wire [31:0] switch_data;
    reg [31:0] led_write_data = 32'd0;
    wire slow_clk;

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


    clock_divider ticker (
        .clk_in(clk),
        .rst(rst_clean),
        .clk_out(slow_clk)
    );


    // FSM states
    reg state;

    
    reg [31:0] counter;

    
    parameter WAIT = 1'b0;
    parameter COUNTDOWN = 1'b1;


    
    always @(posedge slow_clk or posedge rst_clean) begin

        if (rst_clean) begin
            state <= WAIT;
            counter <= 32'd0;
            led_write_data <= 32'd0;
        end

        else begin

            if (state == WAIT) begin

                // Wai
                if (switch_data != 32'd0) begin
                    counter <= switch_data;
                    led_write_data <= switch_data;
                    state <= COUNTDOWN;
                end

                else begin
                    state <= WAIT;
                end

            end

            else if (state == COUNTDOWN) begin

                
                if (counter > 32'd0) begin
                    counter <= counter - 32'd1;
                    led_write_data <= counter - 32'd1;
                end

                else begin
                    state <= WAIT;
                    counter <= 32'd0;
                    led_write_data <= 32'd0;
                end

            end

        end

    end

endmodule