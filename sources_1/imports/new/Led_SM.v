`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2023 11:29:36
// Design Name: 
// Module Name: Led_Display_SM
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


module Led_SM(
    input CLK,
    input RESET,
    input [1:0] MSM_STATE,
    output LED_OUT
    );

    //SM code
    reg Curr_State;
    reg Next_State;
    
    reg Curr_LEDs;
    reg Next_LEDs;
    
    localparam IDLE = 1'b0;
    localparam END = 1'b1;
    
    //Sequential logic
    always@(posedge CLK) begin
        if(RESET) begin
            Curr_State <= IDLE;
            Curr_LEDs <= 1'b0;
        end
        else begin
            Curr_State <= Next_State;
            Curr_LEDs <= Next_LEDs;
        end
    end
    
    always@(MSM_STATE or Curr_State) begin
        case(Curr_State)
        //Idle state
           IDLE : begin
                if(MSM_STATE == 2'd0)
                    Next_State <= Curr_State;
                else
                    Next_State <= END;
                Next_LEDs <= 1'b1;
            end

            // Finished state
            END : begin
            // Return to idle state
                Next_State <= Curr_State;
                Next_LEDs <= 1'b0;
            end
            
        endcase
    end
    
    assign LED_OUT = Curr_LEDs;

endmodule
