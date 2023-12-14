`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2023 19:47:19
// Design Name: 
// Module Name: Target_Gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Generates a new target randomly each time a target is ate
// 
// Dependencies: Snake_Ctrl
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Target_Gen(
    input CLK,
    input RESET,
    input TARGET_REACHED,
    output reg [7:0] TARGET_ADDR_X,
    output reg [6:0] TARGET_ADDR_Y
    );
    
    reg [6:0] lfsr7_out = 7'd60;
    reg [7:0] lfsr8_out = 8'd80;
    
    // Constants for screen dimensions
    parameter SCREEN_WIDTH = 150;
    parameter SCREEN_HEIGHT = 110;
    
    always@(posedge CLK) begin
    // If reset, gives lfsr initial values
        if(RESET) begin    
            lfsr7_out <= 7'd60;
            lfsr8_out <= 8'd80;
        end
    // Else for the 7 bits lfsr, XNOR the 5th end 6th bits
    // For the 8 bits lfsr XNOR the 4th, 5th, 6th and 7th bits
        else begin
            lfsr7_out <= {lfsr7_out[5:0], (~(lfsr7_out[6]^lfsr7_out[5]))};
            lfsr8_out <= {lfsr8_out[6:0], ~(lfsr8_out[7]^(~lfsr8_out[6])^(~lfsr8_out[5])^(~lfsr8_out[4]))};
        end
    end
    
    always@(posedge CLK) begin
        if(RESET) begin
        // If reset, target address takes initial values (in this case, the middle of the screen)
            TARGET_ADDR_X <= 8'd80; 
            TARGET_ADDR_Y <= 7'd60;
        end
        else begin
        // Is the target if ate, the target is generated at a new position. Verify that this
        // new position is within the screens display
            if(TARGET_REACHED) begin
                TARGET_ADDR_X <= (lfsr8_out >= SCREEN_WIDTH) ? (lfsr8_out - SCREEN_WIDTH) : lfsr8_out; 
                TARGET_ADDR_Y <= (lfsr7_out >= SCREEN_HEIGHT) ? (lfsr7_out - SCREEN_HEIGHT) : lfsr7_out;
            end
        end
    end
endmodule