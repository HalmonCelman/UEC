 /*
  * by KK
 */

 `timescale 1 ns / 1 ps

 module draw_rect_ctl_tb;
 
 localparam CLK_PERIOD = 25;     // 40 MHz
 
 logic clk, rst, mouse_left;
 
 logic [11:0] mouse_xpos, mouse_ypos, xpos, ypos;
 /**
  * Clock generation
  */
 
 initial begin
     clk = 1'b0;
     forever #(CLK_PERIOD/2) clk = ~clk;
 end
 
 draw_rect_ctl dut (
    .clk,
    .rst,
    .mouse_left,
    .mouse_xpos,
    .mouse_ypos,
    .xpos,
    .ypos
 );

 draw_rect_ctl_test u_draw_rect_ctl_test (
    .rst,
    .mouse_left,
    .mouse_xpos,
    .mouse_ypos
 );


 /**
  * Main test
  */
 
 initial begin
     rst = 1'b0;
     $display("starting simulation");

     # 30 rst = 1'b1;
     # 30 rst = 1'b0;
    
     wait(ypos > 500);
     wait(ypos < 200);
     wait(ypos < 500);

     $finish;
 end
 
 endmodule
 