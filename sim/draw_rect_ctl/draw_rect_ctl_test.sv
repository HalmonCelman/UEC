 /*
  * by KK
 */

 `timescale 1 ns / 1 ps

 module draw_rect_ctl_test(
     input wire rst,
     output logic mouse_left,
     output logic [11:0] mouse_xpos,
     output logic [11:0] mouse_ypos
 );
 
 initial begin

     mouse_left = '0;
     mouse_xpos = '0;
     mouse_ypos = 500;

     @(negedge rst);

     #100 mouse_left = 1'b1;
     #100 mouse_left = 1'b0;

 end
 
 endmodule
 