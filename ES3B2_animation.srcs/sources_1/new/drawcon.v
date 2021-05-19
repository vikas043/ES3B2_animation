`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Warwick
// Engineer: Vikas Sajanani
// 
// Create Date: 07.05.2021 11:37:58
// Design Name: 
// Module Name: drawblock
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


module drawblock(
    input clk,
    input [1:0] brd_ctrl,
    input [10:0] blkpos_x,
    input [10:0] blkpos_y,
    input [10:0] blk2pos_x,
    input [10:0] blk2pos_y,
    input [10:0] curr_x,
    input [10:0] curr_y,
    output [3:0] draw_r,
    output [3:0] draw_g,
    output [3:0] draw_b
    );

    
    //initializing colors for individual elements
    reg [3:0] bg_r,bg_g,bg_b = 0;
    reg [3:0] blk_r,blk_g,blk_b = 0;
    reg [3:0] blk2_r,blk2_g,blk2_b = 0;

    // background colour
    //Attempt at clocked assignment of border color
    always@(posedge clk) begin
        if((curr_x < 11'd10) || (curr_x > 11'd1430) || (curr_y < 11'd10) || (curr_y > 11'd890)) begin
            if (brd_ctrl==0)begin
            bg_r <= 4'b0000;
            bg_g <= 4'b0000;
            bg_b <= 4'b1111;
            end
            else if (brd_ctrl==1)begin
            bg_r <= 4'b0000;
            bg_g <= 4'b1111;
            bg_b <= 4'b0000;
            end
            else if (brd_ctrl==2)begin
            bg_r <= 4'b1111;
            bg_g <= 4'b0000;
            bg_b <= 4'b0000;
            end
            else if (brd_ctrl==3)begin
            bg_r <= 4'b1111;
            bg_g <= 4'b1111;
            bg_b <= 4'b1111;
            end
            else begin
            bg_r <= 4'b1111;
            bg_g <= 4'b1111;
            bg_b <= 4'b1111;
            end
        end
        else if((curr_x < 11'd840) && (curr_x > 11'd580) && (curr_y < 11'd600) && (curr_y > 11'd300)) begin
            bg_r <= 4'b1111;
            bg_g <= 4'b0000;
            bg_b <= 4'b0011;
        end
        else begin
            bg_r <= 4'b0000;
            bg_g <= 4'b0000;
            bg_b <= 4'b0000;
        end
    end
      
    // block colour
//block detection sets width
//additional conditions identify phase in animation
    always@* begin
        if((curr_x-blkpos_x<50)&&(curr_x-blkpos_x>=0)&&(curr_y-blkpos_y<50)&&(curr_y-blkpos_y>=0)&&(curr_x < 11'd840) && (curr_x > 11'd580) && (curr_y < 11'd600) && (curr_y > 11'd300)) 

        begin
        blk_r <= 4'b1111;
        blk_g <= 4'b0000;
        blk_b <= 4'b0011;
         /*
         blk_r <= 4'b0011;
         blk_g <= 4'b0011;
         blk_b <= 4'b1111;
         */        
        end
        else if ((curr_x-blkpos_x<100)&&(curr_x-blkpos_x>=0)&&(curr_y-blkpos_y<100)&&(curr_y-blkpos_y>=0)&&((curr_x >= 11'd840) || (curr_x <= 11'd580)))
        begin
        blk_r <= 4'b0011;
        blk_g <= 4'b0011;
        blk_b <= 4'b1111; 
        end
        else if ((curr_x-blkpos_x<50)&&(curr_x-blkpos_x>=0)&&(curr_y-blkpos_y<50)&&(curr_y-blkpos_y>=0)&&((curr_y >= 11'd600) || (curr_y <= 11'd300)) )
        begin
        blk_r <= 4'b0000;
        blk_g <= 4'b1111;
        blk_b <= 4'b0000; 
        end
        else begin
            blk_r <= 4'b0000;
            blk_g <= 4'b0000;
            blk_b <= 4'b0000;
        end
    end
    
     // block2 colour
    always@* begin
        if((curr_x-blk2pos_x<50)&&(curr_x-blk2pos_x>=0)&&(curr_y-blk2pos_y<50)&&(curr_y-blk2pos_y>=0)&&(curr_x < 11'd840) && (curr_x > 11'd580) && (curr_y < 11'd600) && (curr_y > 11'd300)) 
        begin
        blk2_r <= 4'b1111;
        blk2_g <= 4'b0000;
        blk2_b <= 4'b0011;
         /*
         blk_r <= 4'b0011;
         blk_g <= 4'b0011;
         blk_b <= 4'b1111;
         */        
        end
        else if ((curr_x-blk2pos_x<100)&&(curr_x-blk2pos_x>=0)&&(curr_y-blk2pos_y<100)&&(curr_y-blk2pos_y>=0)&&((curr_x >= 11'd840) || (curr_x <= 11'd580)))
        begin
        blk2_r <= 4'b0011;
        blk2_g <= 4'b0011;
        blk2_b <= 4'b1111; 
        end
        else if ((curr_x-blk2pos_x<50)&&(curr_x-blk2pos_x>=0)&&(curr_y-blk2pos_y<50)&&(curr_y-blk2pos_y>=0)&&((curr_y >= 11'd600) || (curr_y <= 11'd300)))
        begin
        blk2_r <= 4'b0000;
        blk2_g <= 4'b1111;
        blk2_b <= 4'b0000; 
        end
        else begin
            blk2_r <= 4'b0000;
            blk2_g <= 4'b0000;
            blk2_b <= 4'b0000;
        end
    end
//assigning final color in priority order of elements
    assign draw_r = (blk_r != 4'b0000) ? blk_r : (blk2_r != 4'b0000) ? blk2_r : bg_r;
    assign draw_g = (blk_g != 4'b0000) ? blk_g : (blk2_g != 4'b0000) ? blk2_g : bg_g;
    assign draw_b = (blk_b != 4'b0000) ? blk_b : (blk2_b != 4'b0000) ? blk2_b : bg_b;  

endmodule
