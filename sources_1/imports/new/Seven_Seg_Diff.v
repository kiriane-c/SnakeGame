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
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Seven_Seg_Diff(
    input [1:0] SEG_SELECT_IN,
    input [4:0] BIN_IN,
    input DOT_IN,
    output reg [3:0] SEG_SELECT_OUT,
    output reg [7:0] HEX_OUT
);

    always@(SEG_SELECT_IN) begin
        case(SEG_SELECT_IN)
            2'b00 : SEG_SELECT_OUT <= 4'b1110;
            2'b01 : SEG_SELECT_OUT <= 4'b1101;
            2'b10 : SEG_SELECT_OUT <= 4'b1011;
            2'b11 : SEG_SELECT_OUT <= 4'b0111;
            default: SEG_SELECT_OUT <= 4'b1111;
        endcase
    end

    always@(BIN_IN or DOT_IN) begin
        case(BIN_IN)
           5'h0 : HEX_OUT[6:0] <= 7'b1000000;
           5'h1 : HEX_OUT[6:0] <= 7'b1111001;
           5'h2 : HEX_OUT[6:0] <= 7'b0100100;
           5'h3 : HEX_OUT[6:0] <= 7'b0110000;
          
           5'h4 : HEX_OUT[6:0] <= 7'b0011001;
           5'h5 : HEX_OUT[6:0] <= 7'b0010010;
           5'h6 : HEX_OUT[6:0] <= 7'b0000010;
           5'h7 : HEX_OUT[6:0] <= 7'b1111000;
         
           5'h8 : HEX_OUT[6:0] <= 7'b0000000;
           5'h9 : HEX_OUT[6:0] <= 7'b0011000;
           5'hA : HEX_OUT[6:0] <= 7'b0001000;
           5'hB : HEX_OUT[6:0] <= 7'b0000011;
          
           5'hC : HEX_OUT[6:0] <= 7'b1000110;
           5'hD : HEX_OUT[6:0] <= 7'b0100001;
           5'hE : HEX_OUT[6:0] <= 7'b0000110;
           5'hF : HEX_OUT[6:0] <= 7'b0001110;
           
          //16 = H
           5'h10 : HEX_OUT[6:0] <= 7'b0001001;
          //17 = I
           5'h11 : HEX_OUT[6:0] <= 7'b1001111;
          //18 = L
           5'h12 : HEX_OUT[6:0] <= 7'b1000111;
          //19 = P
           5'h13 : HEX_OUT[6:0] <= 7'b0001100;
          //20 = t
           5'h14 : HEX_OUT[6:0] <= 7'b0000111;
          //21 = y
           5'h15 : HEX_OUT[6:0] <= 7'b0010001;
          //22 = n
           5'h16 : HEX_OUT[6:0] <= 7'b0001000;
            
           default : HEX_OUT[6:0] <= 7'b1111111;
        endcase
        HEX_OUT[7] <= ~DOT_IN;
    end
endmodule


/*
    VHDL syntaxe
    
    library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;
    
    entity Decoding_The_World is
    port(
        SEG_SELECT_IN : in std_logic_vector(1 downto 0);
        BIN_IN : in std_logic_vector(3 downto 0);
        DOT_IN : in std_logic;
        SEG_SELECT_OUT : out std_logic_vector(3 downto 0);
        HEX_OUT : out std_logic_vector(7 downto 0)
    );
    
    end entity Decoding_The_World;
    
    architecture Decoding_The_World_arch of Decoding_The_World is
        signal A, B, C, D, E, F : std_logic;
        
        begin
            B <= BIN_IN[0];
            A <= BIN_IN[1];
            D <= BIN_IN[2];
            C <= BIN_IN[3];
            
            HEX_OUT[0] <= ----------------------------
            |
            |
            |
    
    end architecture;
*/
