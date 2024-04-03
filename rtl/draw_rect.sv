/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: KK
 *
 * Description:
 * Draw rect.
 */


 `timescale 1 ns / 1 ps

 module draw_rect 
#(
    parameter X = 200,
    parameter Y = 100,
    parameter W = 400,
    parameter H = 400,
    parameter COLOR = 12'hF00
)
(
    input  logic clk,
    input  logic rst,
 
    vga_if.in vga_in,    
    vga_if.out vga_out 
);
 
logic [11:0] rgb_nxt;
 
 always_ff @(posedge clk) begin
    if (rst) begin
        vga_out.vcount <= '0;
        vga_out.vsync  <= '0;
        vga_out.vblnk  <= '0;
        vga_out.hcount <= '0;
        vga_out.hsync  <= '0;
        vga_out.hblnk  <= '0;
        vga_out.rgb    <= '0;
    end else begin
        vga_out.vcount <= vga_in.vcount;
        vga_out.vsync  <= vga_in.vsync;
        vga_out.vblnk  <= vga_in.vblnk;
        vga_out.hcount <= vga_in.hcount;
        vga_out.hsync  <= vga_in.hsync;
        vga_out.hblnk  <= vga_in.hblnk;
        vga_out.rgb    <= rgb_nxt;
    end
end
 
always_comb begin
    if(vga_in.hcount >= X
    && vga_in.hcount < X+W
    && vga_in.vcount >= Y
    && vga_in.vcount < Y+H ) begin 
        rgb_nxt = COLOR;
    end else begin
        rgb_nxt = vga_in.rgb;
    end
end
 
 
 endmodule
 