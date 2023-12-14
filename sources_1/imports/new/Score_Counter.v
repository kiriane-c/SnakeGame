`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2023 21:26:29
// Design Name: 
// Module Name: SCORE_COUNT
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Counts the target ate by the snake and shows the result on 7 segment display
//              Strobe count determines selects the segment
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Score_Counter(
    input CLK,
    input RESET,
    input TARGET_REACHED,
    output [1:0] STROBE_COUNT,
    output [3:0] SCORE_COUNT
    );
    
    wire Bit17TrigOut;
    wire [1:0] StrobeCount;
    wire TrigOut0;
    wire TrigOut1;
    
    wire [3:0] DecCount1;
    wire [3:0] DecCount2;
    
    wire [4:0] DecCountAndDOT1;
    wire [4:0] DecCountAndDOT2;
    
    wire [4:0] MuxOut;
    
    // 17-bit counter
    Generic_counter # (.COUNT_WIDTH(17), .COUNT_MAX(99999))
        Bit17Counter(
            .CLK(CLK),
            .RESET(1'b0),
            .ENABLE(1'b1),
            .TRIG_OUT(Bit17TrigOut)                     
            );    
    
    // 2-bit strobe counter
    Generic_counter # (.COUNT_WIDTH(2), .COUNT_MAX(4)) 
        StrobeCounter(
            .CLK(CLK),
            .RESET(1'b0),
            .ENABLE(Bit17TrigOut),
            .COUNT(StrobeCount)
            );     
    
    // 1st 4 bit counter
   Generic_counter # (.COUNT_WIDTH(4), .COUNT_MAX(9)) 
        Counter1(
            .CLK(CLK),
            .RESET(RESET),
            .ENABLE(TARGET_REACHED),
            .TRIG_OUT(TrigOut1),
            .COUNT(DecCount1)
            );
                                
    // 2nd 4 bit counter
    Generic_counter # (.COUNT_WIDTH(4), .COUNT_MAX(9)) 
        Counter2(
            .CLK(CLK),
            .RESET(RESET),
            .ENABLE(TrigOut1),
            .COUNT(DecCount2)
            );
            
    
    assign DecCountAndDOT1 = {1'b1, DecCount1};
    assign DecCountAndDOT2 = {1'b1, DecCount2};
    
    Multiplexer Mux(
      .CTRL(StrobeCount),
      .IN0(DecCountAndDOT1),
      .IN1(DecCountAndDOT2),
      .OUT(MuxOut)
      );
      
    assign STROBE_COUNT = StrobeCount;
    assign SCORE_COUNT = MuxOut;
           
endmodule
