`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2023 17:08:35
// Design Name: 
// Module Name: Seven_SegSM
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


module Seven_SegSM(
    input CLK,
    input [1:0] MSM_STATE,
    output [3:0] SEG_SELECT,
    output [7:0] DEC_OUT
    );
    
    wire Bit17TrigOut;
    wire [1:0] StrobeCount;
    
    //counter to slow down the clock to 1kHz
    Generic_counter # (.COUNT_WIDTH(17), .COUNT_MAX(99999))
                    Bit17Counter(
                    .CLK(CLK),
                    .RESET(1'b0),
                    .ENABLE(1'b1),
                    .TRIG_OUT(Bit17TrigOut)
                    );
    // strobe counter for the multiplexer and 7 segment display
    Generic_counter # (.COUNT_WIDTH(2), .COUNT_MAX(9))
                    Bit2Counter(
                    .CLK(CLK),
                    .RESET(1'b0),
                    .ENABLE(Bit17TrigOut),
                    .COUNT(StrobeCount)
                    );
                    
    reg [4:0] FirstDigit;
    reg [4:0] SecondDigit;
    reg [4:0] ThirdDigit;
    reg [4:0] FourthDigit;
                    
    wire [4:0] MuxOut;
    
    always@(posedge CLK) begin
        if(MSM_STATE == 2'd0) begin
            FirstDigit = 5'h15;
            SecondDigit = 5'hA;
            ThirdDigit = 5'h12;
            FourthDigit = 5'h13;
        end
        else if(MSM_STATE == 2'd3) begin
            FirstDigit = 5'h12;
            SecondDigit = 5'h1;
            ThirdDigit = 5'hA;
            FourthDigit = 5'hF;
        end
        else if(MSM_STATE == 2'd1) begin
            FirstDigit = MAZE;
            SecondDigit = 5'h0;
            ThirdDigit = 5'h0;
            FourthDigit = 5'h0;
        end
        else begin
            FirstDigit = 5'h0;
            SecondDigit = 5'h0;
            ThirdDigit = 5'h0;
            FourthDigit = 5'h0;
        end
    end

    Multiplexer Mux4(
        .CTRL(StrobeCount),
        .IN0(FirstDigit),
        .IN1(SecondDigit),
        .IN2(ThirdDigit),
        .IN3(FourthDigit),
        .OUT(MuxOut)
        );
        
    Seven_Seg_Diff Seg7(
        .SEG_SELECT_IN(StrobeCount),
        .BIN_IN(MuxOut[4:0]),
        .DOT_IN(1'b0),
        .SEG_SELECT_OUT(SEG_SELECT),
        .HEX_OUT(DEC_OUT)
        );
endmodule
