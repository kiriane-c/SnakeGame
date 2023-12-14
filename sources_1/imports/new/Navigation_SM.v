`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2023 00:14:04
// Design Name: 
// Module Name: Navigation_SM
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


module Navigation_SM(
    input CLK,
    input RESET,
    input BTND,
    input BTNL,
    input BTNR,
    input BTNU,
    output [1:0] STATE_OUT
    );
    
    reg [1:0] Curr_State;
    reg [1:0] Next_State;
    
    // Define parameter definitions for the states
    localparam [1:0] UP = 2'd0;
    localparam [1:0] RIGHT = 2'd1;
    localparam [1:0] DOWN = 2'd2;
    localparam [1:0] LEFT = 2'd3;
       
    always@(posedge CLK) begin
        //This is a synchronous RESET
        if(RESET) 
            //The state is set to the UP state, this my idle
            Curr_State <= UP;
            //The outputs are reset to their condition
        else
            //For normal operations, on the rising edge of the clock,
            //the current state gets to the next state.
            Curr_State <= Next_State;
    end
    
    always@(Curr_State or BTND or BTNL or BTNR or BTNU) begin
        case(Curr_State)
        // UP state
            UP : begin
                if(BTNR)
                // If the right button is pressed, go RIGHT
                    Next_State <= RIGHT;
                else if(BTNL)
                // If the left button is pressed, go LEFT
                    Next_State <= LEFT;
                else
                    Next_State <= Curr_State;
            end
            
            // RIGHT state
            RIGHT : begin
                if(BTNU)
                // If the up button is pressed, go UP
                    Next_State <= UP;
                else if(BTND)
                // If the down button is pressed, go DOWN
                    Next_State <= DOWN;
                else
                    Next_State <= Curr_State;
            end
            
            // DOWN state
            DOWN : begin
                if(BTNR)
                // If the right button is pressed, go RIGHT
                    Next_State <= RIGHT;
                else if(BTNL)
                // If the left button is pressed, go LEFT
                    Next_State <= LEFT;
                else
                    Next_State <= Curr_State;
            end
            
            // LEFT state
            LEFT : begin
                if(BTNU)
                // If the up button is pressed, go UP
                    Next_State <= UP;
                else if(BTND)
                // If the down button is pressed, go DOWN
                    Next_State <= DOWN;
                else
                    Next_State <= Curr_State;
            end
            
            default:
                Next_State <= UP;
        endcase
    end
    
    assign STATE_OUT = Curr_State;
endmodule
