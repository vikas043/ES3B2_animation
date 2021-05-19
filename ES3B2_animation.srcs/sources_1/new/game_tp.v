`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Warwick
// Engineer: Vikas Sajanani
// 
// Create Date: 07.05.2021 10:53:59
// Design Name: 
// Module Name: game_tp
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

//module and port declaration
module game_tp(
    input clk,
    output [3:0] pix_r,
    output [3:0] pix_g,
    output [3:0] pix_b,
    output hsync,
    output vsync,
    output led1_B,
    output led2_B,
    output led1_R,
    output led2_R,
    output led1_G,
    output led2_G
    );
    //clock for VGA
   wire pix_clk;
   
//register to hold current LED state
   reg led1_b=0;
   reg led2_b=0;
   reg led1_g=0;
   reg led2_g=0;
   reg led1_r=0;
   reg led2_r=0;
//assigning LED output to corresponding registers
   assign led1_B=led1_b;
   assign led2_B=led2_b;
   assign led1_G=led1_g;
   assign led2_G=led2_g;
   assign led1_R=led1_r;
   assign led2_R=led2_r;
 
//holds color input for VGA module
   wire [3:0] draw_r_Sig;
   wire [3:0] draw_g_Sig;
   wire [3:0] draw_b_Sig;
//holds color output from draw logic module
   wire [3:0] draw_r_Sig1;
   wire [3:0] draw_g_Sig1;
   wire [3:0] draw_b_Sig1;
// assigning output of draw logic to wire holding VGA input
   assign draw_r_Sig=draw_r_Sig1;
   assign draw_g_Sig=draw_g_Sig1;
   assign draw_b_Sig=draw_b_Sig1;
   
   wire [10:0] curr_x;
   wire [10:0] curr_y;
 
//clock for VGA 106.47 MHz using IP 
clk_wiz_0 inst(.clk_out1(pix_clk),.clk_in1(clk));
 
//Generating a 60 Hz game clock  
   reg game_clk = 0;
   reg [20:0] clk_div = 0;
   
    
   always@(posedge clk) begin
    if(clk_div == 1666667) begin
        clk_div <= 21'd0;
        game_clk <= !game_clk;
    end 
    else begin
        clk_div <= clk_div +1;
    end
   end
  
//initializing position of two blocks 
   reg [10:0] blkpos_x = 11'd505;
   reg [10:0] blkpos_y = 11'd400;
   reg [10:0] blk2pos_x = 11'd875;
   reg [10:0] blk2pos_y = 11'd400;
   
   //register indicating direction of moment
   reg [3:0] mov;
   //counter indicating which bit of mov register is set
   reg [1:0] mov_cntrl;

   // generating 1 Hz block clock for animation
   reg [8:0] clk_div_2 = 0;
   reg blk_clk=0;
   
   always@(posedge game_clk)
       begin
       if (clk_div_2==60)begin
       clk_div_2 <= 9'd0;
       blk_clk=!blk_clk;
       //mov_x=!mov_x; 
       end
       else begin
       clk_div_2 <= clk_div_2+1;
       end
       end
       
//mov controller counts till 0-3 every second
       always@(posedge blk_clk)
       begin
       if (mov_cntrl==3)
       begin
       mov_cntrl <= 2'd0;
       end
       else begin
       mov_cntrl <= mov_cntrl+1;
       end
       end
//based on value of mov controller direction is set
always@(posedge game_clk) 
      begin
        case(mov_cntrl)
        2'b00:mov=4'b0001;
        2'b01:mov=4'b0010;
        2'b10:mov=4'b0100;
        2'b11:mov=4'b1000;
        default:mov=4'b0000;
        endcase
       end 
       
//incrementing or decrementing block position based on
//current direction or phase with LED handling
      always@(posedge game_clk) 
      begin

       if (mov[0])begin
        blkpos_x <= blkpos_x+3;
        blkpos_y <= blkpos_y;
        blk2pos_x<=blk2pos_x-3;
        blk2pos_y<=blk2pos_y;
        led1_b<=1;
        led2_b<=1;
        led1_g<=0;
        led2_g<=0;
        led1_r<=0;
        led2_r<=0;
        end
        else if (mov[1])begin
        blkpos_x <= blkpos_x;
        blkpos_y <= blkpos_y+3;
        blk2pos_x <= blk2pos_x;
        blk2pos_y <= blk2pos_y-3;  
        led1_b<=0;
        led2_b<=0;
        led1_g<=1;
        led2_g<=1;
        led1_r<=0;
        led2_r<=0;
        end
        else if (mov[2])begin
        blkpos_x <= blkpos_x;
        blkpos_y <= blkpos_y-3;
        blk2pos_x <= blk2pos_x;
        blk2pos_y <= blk2pos_y+3;
        led1_b<=0;
        led2_b<=0;
        led1_g<=0;
        led2_g<=0;
        led1_r<=1;
        led2_r<=1;  
        end
        else if (mov[3])begin
        blkpos_x <= blkpos_x-3;
        blkpos_y <= blkpos_y;
        blk2pos_x <= blk2pos_x+3;
        blk2pos_y <= blk2pos_y;
        led1_b<=1;
        led2_b<=1;
        led1_g<=1;
        led2_g<=1;
        led1_r<=1;
        led2_r<=1;
        end
        else 
        begin
        blkpos_x <= blkpos_x;
        blkpos_y <= blkpos_y; 
        end
       end 
             
    //instantiating VGA
    vga_out inst_1 (
        .clk(pix_clk),
        .pix_r_IN(draw_r_Sig),
        .pix_g_IN(draw_g_Sig),
        .pix_b_IN(draw_b_Sig),
        .pix_r(pix_r),
        .pix_g(pix_g),
        .pix_b(pix_b),
        .curr_x(curr_x),
        .curr_y(curr_y),
        .hsync(hsync),
        .vsync(vsync)
     );
     //instantiating draw logic
     drawblock inst_2 (
        .clk(pix_clk),
        .brd_ctrl(mov_ctrl),
        .blkpos_x(blkpos_x),
        .blkpos_y(blkpos_y),
        .blk2pos_x(blk2pos_x),
        .blk2pos_y(blk2pos_y),
        .curr_x(curr_x),
        .curr_y(curr_y),
        .draw_r(draw_r_Sig1),
        .draw_g(draw_g_Sig1),
        .draw_b(draw_b_Sig1)
    );

endmodule
