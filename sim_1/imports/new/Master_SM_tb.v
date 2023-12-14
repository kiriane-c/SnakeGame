`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2023 13:40:57
// Design Name: 
// Module Name: Master_SM_tb
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


module Master_SM_tb(

    );
    reg CLK;
    reg RESET;
    reg BTND;
    reg BTNL;
    reg BTNR;
    reg BTNU;
    reg [3:0] SCORE_COUNT;
    wire [1:0] STATE_OUT;
    
    Master_SM uut(
        .CLK(CLK),
        .RESET(RESET),
        .BTND(BTND),
        .BTNL(BTNL),
        .BTNR(BTNR),
        .BTNU(BTNU),
        .SCORE_COUNT(SCORE_COUNT),
        .STATE_OUT(STATE_OUT)
        );
        
    initial begin
        CLK = 0;
        forever #50 CLK = ~CLK;
    end
    
    initial begin
        RESET = 0;
        #100
        BTND = 0;
        BTNL = 0;
        BTNR = 0;
        BTNU = 0;
        #50 BTND = 1;
        #100 SCORE_COUNT = 4'd10;
    end
endmodule
