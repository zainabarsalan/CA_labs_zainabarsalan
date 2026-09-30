
`timescale 1ns / 1ps



module top_fsm_system_tb;  
    reg clk;
    reg pbin;
    reg [15:0] physical_sw;

    
    wire [15:0] physical_leds;


    
    top_fsm_system dut (
        .clk(clk),
        .pbin(pbin),
        .physical_sw(physical_sw),
        .physical_leds(physical_leds)
    );
  
    always #5 clk = ~clk;
    initial begin       
        clk = 0;
        pbin = 1;
        physical_sw = 16'd0;

        #20;
        pbin = 0;       
        physical_sw = 16'd5;

        #150;


       physical_sw = 16'd3;

        #120;
        physical_sw = 16'd6;

        #20;

        physical_sw = 16'd2;

        #150;
        physical_sw = 16'd8;

        #30;

        pbin = 1;

        #20;
        pbin = 0;

        physical_sw = 16'd0;

        #50;
        $finish;

    end

endmodule