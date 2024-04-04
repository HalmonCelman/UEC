/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: KK
 *
 * Description:
 * Draw rect.
 */


 `timescale 1 ns / 1 ps

 module draw_mouse
(
    input logic clk,
    input logic rst,

    input logic [11:0] x,
    input logic [11:0] y, 
    
    vga_if.in vga_in,    
    vga_if.out vga_out 
);
 
 always_ff @(posedge clk) begin
    if (rst) begin
        vga_out.vcount <= '0;
        vga_out.vsync  <= '0;
        vga_out.vblnk  <= '0;
        vga_out.hcount <= '0;
        vga_out.hsync  <= '0;
        vga_out.hblnk  <= '0;
    end else begin
        vga_out.vcount <= vga_in.vcount;
        vga_out.vsync  <= vga_in.vsync;
        vga_out.vblnk  <= vga_in.vblnk;
        vga_out.hcount <= vga_in.hcount;
        vga_out.hsync  <= vga_in.hsync;
        vga_out.hblnk  <= vga_in.hblnk;
    end
end

logic blank;

assign blank = vga_in.hblnk | vga_in.vblnk;

MouseDisplay u_MouseDisplay(
    .pixel_clk(clk),
    .xpos(x),
    .ypos(y),
    .hcount(vga_in.hcount),
    .vcount(vga_in.vcount),
    .blank(blank),
    .rgb_in(vga_in.rgb),
    .enable_mouse_display_out(),
    .rgb_out(vga_out.rgb)
);
 
 endmodule
 