`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2023 22:46:29
// Design Name: 
// Module Name: VGA_Ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: Snake_Ctrl, VGA_Interface, Master_SM
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA_Ctrl(
    input CLK,
    input [1:0] MSM_STATE,
    input [11:0] COLOUR,
    output [9:0] PIXEL_ADDR_X,
    output [8:0] PIXEL_ADDR_Y,
    output HS,
    output VS,
    output [11:0] COLOUR_OUT
    );
    
    wire [9:0] X;
    wire [8:0] Y;
    
    reg [15:0] FrameCount = 0;
    reg [11:0] Color;
    
    // Instantiate a VGA
    VGA_Interface VGA(
        .CLK(CLK),
        .COLOUR_IN(Color),
        .ADDRH(X),
        .ADDRV(Y),
        .COLOUR_OUT(COLOUR_OUT),
        .HS(HS),
        .VS(VS)        
    );
    
    always@(posedge CLK) begin
        if(X == 479) 
            FrameCount <= FrameCount + 1;
    end
    
    always@(posedge CLK) begin
    //Idle state
        if(MSM_STATE == 2'd0) begin
            Color <= 12'hFFF;
        end
    // Play state
    // If in the play state, the VGA takes the colour output of snake control
        else if(MSM_STATE == 2'd1) begin
            Color <= COLOUR;
        end  
    //Win state
        else if(MSM_STATE == 2'd2) begin
            if(Y[8:0] > 240) begin
                if(X[9:0] > 320)
                    Color <= FrameCount[15:8] + Y[7:0] + X[7:0] - 240 - 320;
                else
                    Color <= FrameCount[15:8] + Y[7:0] - X[7:0] - 240 + 320;
            end
            else begin
                if(X[9:0] > 320)
                    Color <= FrameCount[15:8] - Y[7:0] + X[7:0] + 240 - 320;
                else
                    Color <= FrameCount[15:8] - Y[7:0] - X[7:0] + 240 + 320;
            end
        end
        
        else if(MSM_STATE == 2'd3) begin
            if((X > 80) && (X < 560) && (Y > 80) && (Y < 400))
                Color <= 12'h0FF;
            else if(((X > 120) && (X < 140) && (Y > 120) && (Y < 140)) || 
                    ((X > 520) && (X < 540) && (Y > 120) && (Y < 140)) ||
                    ((X > 120) && (X < 540) && (Y > 360) && (Y < 365)))
                Color <= 12'h000;
            else
                Color <= 12'hFFF;
        end
                    
        else
            Color <= 12'hFFF;
    end
    
    assign PIXEL_ADDR_X = X;
    assign PIXEL_ADDR_Y = Y;
    
endmodule
