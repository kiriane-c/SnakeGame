`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2023 22:07:31
// Design Name: 
// Module Name: Decoding_The_World
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Selects each segment of the display and lights it depending on what to display
//              1 turns OFF the light, 0 turns ON
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Seven_Segment(
    input [1:0] SEG_SELECT_IN,
    input [3:0] BIN_IN,
    input DOT_IN,
    output [3:0] SEG_SELECT_OUT,
    output [7:0] HEX_OUT
    );
    
    wire A, B, C, D;
    wire E, F;
    
    assign B = BIN_IN[0];
    assign A = BIN_IN[1];
    assign D = BIN_IN[2];
    assign C = BIN_IN[3];
    
    //CA = A'BC'D' + A'B'C'D + A'BCD + ABCD' {0,2,3,5,6,7,8,9,A,C,E,F}
    assign HEX_OUT[0] = ((~A)&B&(~C)&(~D))|((~A)&(~B)&(~C)&D)|((~A)&B&C&D)|(A&B&C&(~D));
    
    //CB = AB'D + ABC + A'BC'D + B'CD {0,1,2,3,4,7,8,9,A,D}
    assign HEX_OUT[1] = (A&B&C)|(A&(~B)&D)|((~B)&C&D)|((~A)&B&(~C)&D);
    
    //CC = AB'C'D' + B'CD + ACD {0,1,3,4,5,6,7,8,9,A,B,D}
    assign HEX_OUT[2] = (A&C&D)|((~B)&C&D)|(A&(~B)&(~C)&(~D));
    
    //CD = ABD + A'BD' + A'B'C'D + AB'CD' {0,2,3,5,6,8,B,C,D,E}
    assign HEX_OUT[3] = (A&B&D)|((~A)&B&(~D))|((~A)&(~B)&(~C)&D)|(A&(~B)&C&(~D));
    
    //CE = BC' + A'C'D + A'BD' {0,2,6,8,A,B,C,D,E,F}
    assign HEX_OUT[4] = (B&(~C))|((~A)&(~C)&D)|((~A)&B&(~D));
    
    //CF = ABC' + BC'D' + AC'D' + A'BCD {0,4,6,8,9,A,B,C,E,F}
    assign HEX_OUT[5] = (A&B&(~C))|(B&(~C)&(~D))|(A&(~C)&(~D))|((~A)&B&C&D);
    
    //CG = A'C'D' + ABC'D + A'B'CD {2,3,4,5,6,8,9,A,B,D,E,F}
    assign HEX_OUT[6] = ((~A)&(~C)&(~D))|(A&B&(~C)&D)|((~A)&(~B)&C&D);
    
    assign HEX_OUT[7] = DOT_IN;
    
    assign E = SEG_SELECT_IN[0];
    assign F = SEG_SELECT_IN[1];
    
    assign SEG_SELECT_OUT[0] = ~((~F)&(~E));
    assign SEG_SELECT_OUT[1] = ~((~F)&E);
    assign SEG_SELECT_OUT[2] = ~(F&(~E));
    assign SEG_SELECT_OUT[3] = ~(F&E);
    
endmodule

