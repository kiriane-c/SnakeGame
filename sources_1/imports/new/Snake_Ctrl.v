`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2023 21:15:07
// Design Name: 
// Module Name: Snake_Ctrl
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


module Snake_Ctrl(
    input CLK,
    input RESET,
    input PAUSE,
    input [1:0] MSM_STATE,
    input [1:0] NAV_STATE,
    input [7:0] TARGET_ADDR_X,
    input [6:0] TARGET_ADDR_Y,
    input [9:0] PIXEL_ADDR_X,
    input [8:0] PIXEL_ADDR_Y,
    output reg DEATH,
    output reg TARGET_REACHED,
    output reg [11:0] COLOUR_OUT
    );
        
    parameter SnakeLength = 50;
    parameter MaxY = 120;
    parameter MaxX = 160;
    
    // Define color codes
    // Red
    parameter COLOR_TARGET = 12'h00F;
    // Yellow
    parameter COLOR_SNAKE = 12'h0FF;
    // Blue
    parameter COLOR_BACKGROUND = 12'hF00;
    
    // Define the 2 dimensionnal snake
    reg [7:0] SnakeState_X [0: SnakeLength -1];
    reg [6:0] SnakeState_Y [0: SnakeLength -1];
    
    // Define the address of the snake used when moving
    reg [7:0] Snake_Addr_X;
    reg [6:0] Snake_Addr_Y;
    
    // Define the increase in length
    reg [7:0] IncreaseLength = 0;
                    
    integer i;
    integer j;
    integer k;
    
    //Changing position of snake registers
    //Shift the SnakeState X and Y
    
    wire [23:0] Counter;
        
    Generic_counter # (.COUNT_WIDTH(24), .COUNT_MAX(9999999))
                        GCounter(
                        .CLK(CLK),
                        .RESET(1'b0),
                        .ENABLE(1'b1),
                        .COUNT(Counter)
                        );   
    
    genvar PixNo;
    generate
        for(PixNo = 0; PixNo < SnakeLength - 1; PixNo = PixNo + 1) 
        begin : PixShift
            always@(posedge CLK) begin
            //Sets the initial position of the snake
                if(RESET) begin
                    SnakeState_X[PixNo + 1] <= 80;
                    SnakeState_Y[PixNo + 1] <= 100;
                end
                else begin
                    if(PAUSE) begin
                        SnakeState_X[PixNo] <= SnakeState_X[PixNo];
                        SnakeState_Y[PixNo] <= SnakeState_Y[PixNo];
                    end
                    
                    else if(Counter == 0) begin
                        SnakeState_X[PixNo + 1] <= SnakeState_X[PixNo];
                        SnakeState_Y[PixNo + 1] <= SnakeState_Y[PixNo];
                    end
                end
                // The snake does not really moves. The apparent movement is due to the
                // colouring of the next 2D pixel after a period (i.e the snake speeds)
                // So when the counter is 0, the next part of the snake takes its previous
                // part.
                    
            end
        end
    endgenerate
    
    // Replace top snake state with new one based on direction
    always@(posedge CLK) begin
        // Give the snake an initial position when reset or when the master state is Idle
        if(RESET || MSM_STATE == 2'd0) begin
            SnakeState_X[0] <= 80;
            SnakeState_Y[0] <= 100;
        end
        else begin
            if(Counter == 0) begin
                case(NAV_STATE)
                // In the vertical axis, moves up till 0 or down till 120 (480/4)
                // So if while moving up, the Y part of the snake's head is the 0 pixel, 
                // then the head is the 120 pixel
                    2'd0 : begin
                        if(SnakeState_Y[0] == 0)
                            SnakeState_Y[0] <= MaxY;
                        else if(PAUSE)
                            SnakeState_Y[0] <= SnakeState_Y[0];
                        else
                            SnakeState_Y[0] <= SnakeState_Y[0] - 1;
                    end
                // In the horizontal axis, moves right till 0 or left till 160 (640/4)
                // So if while moving right, the X part of the snake's head is the 160 pixel, 
                // then the head is the 0 pixel
                    2'd1 : begin
                        if(SnakeState_X[0] == MaxX)
                            SnakeState_X[0] <= 0;
                        else if(PAUSE)
                            SnakeState_X[0] <= SnakeState_X[0];
                        else
                            SnakeState_X[0] <= SnakeState_X[0] + 1;
                    end
                // In the vertical axis, moves up till 0 or down till 120 (480/4)
                // So if while moving down, the Y part of the snake's head is the 120 pixel, 
                // then the head is the 0 pixel
                    2'd2 : begin
                        if(SnakeState_Y[0] == MaxY)
                            SnakeState_Y[0] <= 0;
                       else if(PAUSE)
                            SnakeState_Y[0] <= SnakeState_Y[0];
                        else
                            SnakeState_Y[0] <= SnakeState_Y[0] + 1;
                    end
                // In the horizontal axis, moves right till 0 or left till 160 (640/4)
                // So if while moving left, the X part of the snake's head is the 0 pixel, 
                // then the head is the 160 pixel
                    2'd3 : begin
                        if(SnakeState_X[0] == 0)
                            SnakeState_X[0] <= MaxX;
                        else if(PAUSE)
                            SnakeState_X[0] <= SnakeState_X[0];
                        else
                            SnakeState_X[0] <= SnakeState_X[0] - 1;
                    end
                endcase
            end
        end
    end
    
    // Determine color based on Snake address and Target address
    always@(posedge CLK) begin
    // Checks if the current pixel is part of the target
        if(PIXEL_ADDR_X[9:2] == TARGET_ADDR_X && PIXEL_ADDR_Y[8:2] == TARGET_ADDR_Y)
            COLOUR_OUT <= COLOR_TARGET;
        // Check if the current pixel is part of the background
        else
            COLOUR_OUT <= COLOR_BACKGROUND;
        
        // The snake is a 2D memory so each bits must be checked to determine if the current
        // pixel is part of the snake
        for(i = 0; i < SnakeLength - 40; i = i+1) begin
            if(SnakeState_X[i] == PIXEL_ADDR_X[9:2] && SnakeState_Y[i] == PIXEL_ADDR_Y[8:2]) begin
                    COLOUR_OUT <= COLOR_SNAKE;
            end
        end
        // Try this for growth : Increase SnakeLength to 15
        for(j = 0; j < IncreaseLength; j = j+1) begin
            if(SnakeState_X[SnakeLength-40+j] == PIXEL_ADDR_X[9:2] && SnakeState_Y[SnakeLength-40+j] == PIXEL_ADDR_Y[8:2])
                COLOUR_OUT <= COLOR_SNAKE;
        end
    end    
                            
    // Additional logic for checking if the snake reached the target 
    // Combinatorial logic. Does not depends on the clock 
    always@(*) begin
        if(RESET)
            TARGET_REACHED <= 0;
        else begin
            // Assuming TARGET_ADDR is the address of the target pixel
            if((SnakeState_X[0] == TARGET_ADDR_X) && (SnakeState_Y[0] == TARGET_ADDR_Y)) begin
                TARGET_REACHED <= 1;
            end
            else begin
                TARGET_REACHED <= 0;
            end
        end
    end
    
    // Logic for the increase in length after the target has been reached
    always@(posedge CLK) begin
        if(RESET)
            IncreaseLength <= 0;
        else begin
            if(TARGET_REACHED)
                IncreaseLength <= IncreaseLength + 2;
        end
    end
    
    // Logic where the snake dies if it bites itself
    always@(posedge CLK) begin
        if(RESET) begin
           DEATH <= 0;
       end
       else begin
       // If the snake head comes in contact with any part of the snake's body while growing or not, it dies
            for(k = 1; k < SnakeLength; k = k + 1) begin
                if(k <= 10 * IncreaseLength*2) begin
                    if((SnakeState_X[0] == SnakeState_X[k]) && (SnakeState_Y[0] == SnakeState_Y[k])) begin
                        DEATH <= 1;
                    end
                    else begin
                        DEATH <= 0;
                    end
                end
            end
        end      
    end
    
endmodule
