`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2026 07:28:36 PM
// Design Name: 
// Module Name: ring_oscillator
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


module ring_oscillator(
    input Enable,
    output Output
    );
    
// signal s0, s1, s2, s3 : std_logic;
    wire s0, s1, s2, s3;

    //------------------------------------------------------------------
    // LUT1_inst : LUT2
    // generic map (INIT => X"7")          -> O = ~(I0 & I1)  (NAND)
    // port map (O => s0, I0 => Enable, I1 => s3);
    //------------------------------------------------------------------
    LUT2 #(
        .INIT(4'h7)          // X"7" : zero only for {I1,I0} = 2'b11
    ) LUT1_inst (
        .O  (s0),            // O  => s0
        .I0 (Enable),        // I0 => Enable
        .I1 (s3)             // I1 => s3   (ring feedback)
    );

    //------------------------------------------------------------------
    // Stage 2 : inverter   O = ~I0
    // INIT bit0 = 1 (I0 = 0 -> 1), bit1 = 0 (I0 = 1 -> 0)
    //------------------------------------------------------------------
    LUT1 #(
        .INIT(2'h1)
    ) LUT2_inst (
        .O  (s1),            // O  => s1
        .I0 (s0)            // I0 => s0
    );

    //------------------------------------------------------------------
    // Stage 3 : inverter   O = ~I0
    //------------------------------------------------------------------
    LUT1 #(
        .INIT(2'h1)
    ) LUT3_inst (
        .O  (s1),            // O  => s2
        .I0 (s0)            // I0 => s1
    );

    //------------------------------------------------------------------
    // Ring closure : last stage feeds the first stage's I1 input
    // (3 inverting stages -> odd inversion count -> oscillation when
    //  Enable = 1; static low when Enable = 0)
    //------------------------------------------------------------------
    assign s3 = s2;

    // Oscillator output
    assign Output = s2;

    
endmodule
