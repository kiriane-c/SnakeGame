`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//  
// Create Date: 21.11.2023 11:13:14
// Design Name: 
// Module Name: Target_Gen_tb
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


module Target_Gen_tb(

    );
    
    reg CLK;
    reg RESET;
    reg TARGET_REACHED;
    wire [7:0] TARGET_ADDR_X;
    wire [6:0] TARGET_ADDR_Y;
    
    Target_Gen uut(
        .CLK(CLK),
        .RESET(RESET),
        .TARGET_REACHED(TARGET_REACHED),
        .TARGET_ADDR_X(TARGET_ADDR_X),
        .TARGET_ADDR_Y(TARGET_ADDR_Y)
    );
    
    initial begin
        CLK = 0;
        forever #50 CLK = ~CLK;
    end
    
    initial begin
        RESET = 0;
        
        #100
        
        #200 TARGET_REACHED = 1;
        #200 TARGET_REACHED = 0;
    end
endmodule
