`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2023 16:09:19
// Design Name: 
// Module Name: Generic_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Generic module used as counter for many modules
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Generic_counter(
    CLK,
    RESET,
    ENABLE,
    TRIG_OUT,
    COUNT
    );
    
    parameter COUNT_WIDTH = 4;
    parameter COUNT_MAX = 9;
    
    input CLK;
    input RESET;
    input ENABLE;
    output TRIG_OUT;
    output [COUNT_WIDTH-1:0] COUNT;
    
    reg [COUNT_WIDTH-1:0] count_value = 0;
    reg trig_value;
    
    always@(posedge CLK) begin
        if(RESET)
            count_value <= 0;
        else begin
            if(ENABLE) begin
                if(count_value == COUNT_MAX)
                    count_value <= 0;
                else
                    count_value <= count_value + 1;
            end
        end
    end
    
    always@(posedge CLK) begin
        if(RESET)
            trig_value <= 0;
        else begin
            if(ENABLE && (count_value == COUNT_MAX))
                trig_value <= 1;
            else
                trig_value <= 0;
        end
    end
    
    assign COUNT = count_value;
    assign TRIG_OUT = trig_value;
    
endmodule
