`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2023 15:12:13
// Design Name: 
// Module Name: Score_Counter_tb
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


module Score_Counter_tb(

    );
    
    reg CLK;
    reg RESET;
    reg TARGET_REACHED;
    wire [1:0] STROBE_COUNT;
    wire [3:0] SCORE_COUNT;
    
    Score_Counter utt(
        .CLK(CLK),
        .RESET(RESET),
        .TARGET_REACHED(TARGET_REACHED),
        .STROBE_COUNT(STROBE_COUNT),
        .SCORE_COUNT(SCORE_COUNT)
    );
    
    initial begin
        CLK = 0;
        forever #50 CLK = ~CLK;
    end
    
    initial begin
        RESET = 0;
        #100 
        TARGET_REACHED = 1;
    end
endmodule
