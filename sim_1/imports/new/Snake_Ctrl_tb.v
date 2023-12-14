`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2023 14:44:35
// Design Name: 
// Module Name: Snake_Ctrl_tb
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


module Snake_Ctrl_tb(

    );
    reg CLK;
    reg RESET;
    reg [1:0] MSM_STATE;
    reg [1:0] NAV_STATE;
    reg [7:0] TARGET_ADDR_X;
    reg [6:0] TARGET_ADDR_Y;
    reg [9:0] PIXEL_ADDR_X;
    reg [8:0] PIXEL_ADDR_Y;
    wire TARGET_REACHED;
    wire [11:0] COLOUR_OUT;
    
    Snake_Ctrl uut(
        .CLK(CLK),
        .RESET(RESET),
        .MSM_STATE(MSM_STATE),
        .NAV_STATE(NAV_STATE),
        .TARGET_ADDR_X(TARGET_ADDR_X),
        .TARGET_ADDR_Y(TARGET_ADDR_Y),
        .PIXEL_ADDR_X(PIXEL_ADDR_X),
        .PIXEL_ADDR_Y(PIXEL_ADDR_Y),
        .TARGET_REACHED(TARGET_REACHED),
        .COLOUR_OUT(COLOUR_OUT)
    );
    
    initial begin
        CLK = 0;
        forever #50 CLK = ~CLK;
    end
    
    initial begin
        RESET = 0;
        #50 MSM_STATE = 1;
        #50 NAV_STATE = 1;
        
        #50 TARGET_ADDR_X = 8'b10101000;
        #50 TARGET_ADDR_Y = 7'b0101011;
        
        #50 PIXEL_ADDR_X = 10'b0010101000;
        #50 PIXEL_ADDR_Y = 9'b000101011;
    end 
endmodule
