`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2023 19:20:12
// Design Name: 
// Module Name: Snake_Game
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


module SnakeGame(
    input CLK,
    input RESET,
    input BTND,
    input BTNL,
    input BTNR,
    input BTNU,
    input PAUSE,
    output LED_OUT,
    output [11:0] COLOUR_OUT,
    output HS,
    output VS,
    output [3:0] SEG_SELECT,
    output [7:0] HEX_OUT
    );
    
    // Declaration of wires to connect all the inner modules
    // Master state machine output
    wire [1:0] Master_SM_Out;
    
    // Navigation state machine output
    wire [1:0] Nav_SM_Out;
    
    // Target Adress
    wire [7:0] Target_Addr_X;
    wire [6:0] Target_Addr_Y;
    
    // Pixel address to be coloured
    wire [9:0] Pixel_Addr_X;
    wire [8:0] Pixel_Addr_Y;
    
    // 1 : snake has ate target, 0 : otherwise.
    wire Target_reached;
    
    // Colour input for the VGA controller, sent from snake_ctrl
    wire [11:0] Colour;
    
    // Score displayed on 7 segment
    wire [3:0] Score_Count;
    
    // Strobe count to determine which segment display is to be used
    wire [1:0] StrobeCount;
    
    wire Death;
    
    // Master state instantiation  
    Master_SM MSM(
        .CLK(CLK),
        .RESET(RESET),
        .BTND(BTND),
        .BTNL(BTNL),
        .BTNR(BTNR),
        .BTNU(BTNU),
        .DEATH(Death),
        .SCORE_COUNT(Score_Count),
        .STATE_OUT(Master_SM_Out)
    );
    
    // Navigation state instantiation
    Navigation_SM NSM(
        .CLK(CLK),
        .RESET(RESET),
        .BTND(BTND),
        .BTNL(BTNL),
        .BTNR(BTNR),
        .BTNU(BTNU),
        .STATE_OUT(Nav_SM_Out)
    );
    
    // Snake control instantiation. When PAUSE signal is high the snake and target freeze on the screen.
    // If the PAUSE signal is low, the snake continues its initial motion
    Snake_Ctrl SCTRL(
        .CLK(CLK),
        .RESET(RESET),
        .PAUSE(PAUSE),
        .MSM_STATE(Master_SM_Out),
        .NAV_STATE(Nav_SM_Out),
        .TARGET_ADDR_X(Target_Addr_X),
        .TARGET_ADDR_Y(Target_Addr_Y),
        .PIXEL_ADDR_X(Pixel_Addr_X),
        .PIXEL_ADDR_Y(Pixel_Addr_Y),
        .DEATH(Death),
        .TARGET_REACHED(Target_reached),
        .COLOUR_OUT(Colour)
    );
    
    // Target generator instantiation
    Target_Gen TGN(
        .CLK(CLK),
        .RESET(RESET),
        .TARGET_REACHED(Target_reached),
        .TARGET_ADDR_X(Target_Addr_X),
        .TARGET_ADDR_Y(Target_Addr_Y)
    );
    
    // VGA control instantiation
    VGA_Ctrl VGA(
        .CLK(CLK),
        .MSM_STATE(Master_SM_Out),
        .COLOUR(Colour),
        .PIXEL_ADDR_X(Pixel_Addr_X),
        .PIXEL_ADDR_Y(Pixel_Addr_Y),
        .HS(HS),
        .VS(VS),
        .COLOUR_OUT(COLOUR_OUT)
    );
    
    // Score counter instantiation : outputs used as 7SEG inputs
    Score_Counter SC(
        .CLK(CLK),
        .RESET(RESET),
        .TARGET_REACHED(Target_reached),
        .STROBE_COUNT(StrobeCount),
        .SCORE_COUNT(Score_Count)
    );
    
    // 7 SEG instantiation : displays score received from score counter
    Seven_Segment Seg7(
      .SEG_SELECT_IN(StrobeCount),
      .BIN_IN(Score_Count),
      .DOT_IN(1'b1),
      .SEG_SELECT_OUT(SEG_SELECT),
      .HEX_OUT(HEX_OUT)
      );
      
    // Instantiate the LED State machine
    Led_SM LSM(
        .CLK(CLK),
        .RESET(RESET),
        .MSM_STATE(Master_SM_Out),
        .LED_OUT(LED_OUT)
    );
      
endmodule
