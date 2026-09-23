`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2026 07:28:36 PM
// Design Name: 
// Module Name: ring_oscillator_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ring_oscillator_tb;

    reg  Enable;
    wire Output;

    ring_oscillator dut (
        .Enable(Enable),
        .Output(Output)
    );

    initial begin
        Enable = 1'b0;  // oscillator disabled
        #20;

        Enable = 1'b1;  // oscillator enabled
        #100;

        Enable = 1'b0;  // oscillator disabled again
        #20;

        $finish;
    end

endmodule
