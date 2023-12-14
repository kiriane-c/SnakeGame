`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2023 23:59:25
// Design Name: 
// Module Name: Master_SM
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


module Master_SM(
    input CLK,
    input RESET,
    input BTND,
    input BTNL,
    input BTNR,
    input BTNU,
    input DEATH,
    input [3:0] SCORE_COUNT,
    output [1:0] STATE_OUT
    );
    
    reg [1:0] Curr_State;
    reg [1:0] Next_State;
    
    reg [34:0] Curr_Count;
    reg [34:0] Next_Count;
        
     // Define parameter definitions for the states
    localparam [1:0] IDLE = 2'd0;
    localparam [1:0] PLAY = 2'd1;
    localparam [1:0] WIN = 2'd2;
    localparam [1:0] LOSE = 2'd3;
    
    always@(posedge CLK) begin
        //This is a synchronous RESET
        if(RESET) begin
            //The state is set to the reset state, this is idle
            Curr_State <= IDLE;
            Curr_Count <= 0;
        end
            //The outputs are reset to their condition
        else begin
            //For normal operations, on the rising edge of the clock,
            //the current state get to the next state.
            Curr_State <= Next_State;
            Curr_Count <= Next_Count;
        end
    end
    
    // Combinatorial logic
    always@(*) begin
        case(Curr_State)
        // Idle state
            IDLE : begin
            // If the down, left, right or up button is pressed, Play
                if(BTND || BTNL || BTNR || BTNU)
                    Next_State <= PLAY;
                else
                    Next_State <= Curr_State;
            end
                     
            // PLAY State
            PLAY : begin
                if(SCORE_COUNT == 4'd10) 
                    Next_State <= WIN;
                else if(DEATH)
                    Next_State <= LOSE;  
                else 
                    Next_State <= Curr_State;                   
            end
                        
            // WIN State
            WIN : begin
                Next_State <= Curr_State;
            end
            
            // LOSE State
            LOSE : begin
                Next_State <= Curr_State;
            end
            
            // Default
            default:
                Next_State <= IDLE;
        endcase
    end
    
    assign STATE_OUT = Curr_State;
endmodule
