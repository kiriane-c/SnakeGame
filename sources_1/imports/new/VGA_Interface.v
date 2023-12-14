`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2023 22:04:30
// Design Name: 
// Module Name: VGA_Interface
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Each pixel of the VGA is coloured at the clock edge. The VGA used is 25MHz
//              while the FPGA clock is 100MHz. In order to use the VGA clock, used a counter
//              to divide it by 4.
// 
// Dependencies: Generic_counter
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA_Interface(
    input CLK,
    input [11:0] COLOUR_IN,
    output reg [9:0] ADDRH,
    output reg [8:0] ADDRV,
    output reg [11:0] COLOUR_OUT,
    output reg HS,
    output reg VS
    );
    
    //Time is vertical line
    parameter VertTimeToPulseWidthEnd = 10'd2;
    parameter VertTimeToBackPorchEnd = 10'd31;
    parameter VertTimeToDisplayTimeEnd = 10'd511;
    parameter VertTimeToFrontPorchEnd = 10'd521;
    
     //Time is horizontal line
   parameter HorzTimeToPulseWidthEnd = 10'd96;
   parameter HorzTimeToBackPorchEnd = 10'd144;
   parameter HorzTimeToDisplayTimeEnd = 10'd784;
   parameter HorzTimeToFrontPorchEnd = 10'd800;
   
   //Wires used to connect counter instantiations
   wire BitHTrigOut;
   wire BitVTrigOut;
   wire Trig25Out;
   
   //Declaration of horizontal and vertical address for each pixel
   wire [10:0] Horz_count;
   wire [10:0] Vert_count;
   
   // Counts from 0-3 (i.e 4) to step down the VGA clock
   Generic_counter # (.COUNT_WIDTH(2), .COUNT_MAX(3))
                      GCounter(
                      .CLK(CLK),
                      .RESET(1'b0),
                      .ENABLE(1'b1),
                      .TRIG_OUT(Trig25Out)
                      );
   
   // Counts up to 800 for the horizontal  
   Generic_counter # (.COUNT_WIDTH(10), .COUNT_MAX(799))
                       BitHCounter(
                       .CLK(CLK),
                       .RESET(1'b0),
                       .ENABLE(Trig25Out),
                       .TRIG_OUT(BitHTrigOut),
                       .COUNT(Horz_count)
                       );
                       
   // Counts up to 521 for the vertical                   
   Generic_counter # (.COUNT_WIDTH(10), .COUNT_MAX(520))
                      BitVCounter(
                      .CLK(CLK),
                      .RESET(1'b0),
                      .ENABLE(BitHTrigOut),
                      .TRIG_OUT(BitVTrigOut),
                      .COUNT(Vert_count)
                      );
                      
    always@(posedge CLK) begin
        if(Horz_count < HorzTimeToPulseWidthEnd)
            HS <= 1'b0;
        else
            HS <= 1'b1;
    end
    
    always@(posedge CLK) begin
        if(Vert_count < VertTimeToPulseWidthEnd)
            VS <= 1'b0;
        else
            VS <= 1'b1;
    end
    
    always@(posedge CLK) begin
        if((Horz_count >= HorzTimeToBackPorchEnd) && (Horz_count <= HorzTimeToDisplayTimeEnd) && 
        (Vert_count >= VertTimeToBackPorchEnd) && (Vert_count <= VertTimeToDisplayTimeEnd))
                COLOUR_OUT <= COLOUR_IN;
        else
            COLOUR_OUT <= 12'b0;
    end
    
    always@(posedge CLK) begin
        if((Horz_count >= HorzTimeToBackPorchEnd) && (Horz_count <= HorzTimeToDisplayTimeEnd))
            ADDRH <= Horz_count - HorzTimeToBackPorchEnd;
        else
            ADDRH <= 0;
    end
    
    always@(posedge CLK) begin
        if((Vert_count >= VertTimeToBackPorchEnd) && (Vert_count <= VertTimeToDisplayTimeEnd))
            ADDRV <= Vert_count - VertTimeToBackPorchEnd;
        else
            ADDRV <= 0;
    end
    
endmodule