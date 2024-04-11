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
    parameter W = 48,
    parameter H = 64
)
(
    input logic clk,
    input logic rst,

    input logic [11:0] x,
    input logic [11:0] y, 
    
    input logic [11:0] rgb_pixel,
    output logic [11:0] pixel_addr,

    vga_if.in vga_in,    
    vga_if.out vga_out 
);
 
logic [11:0] rgb_nxt;
logic [11:0] pixel_addr_nxt;

localparam DELAY=1;

logic [10:0] [DELAY:0] hcount_d;
logic [10:0] [DELAY:0] vcount_d;
logic [DELAY:0] hblnk_d;
logic [DELAY:0] vblnk_d;
logic [DELAY:0] hsync_d;
logic [DELAY:0] vsync_d;

logic [1:0] [11:0] rgb_d;
 
always_ff @(posedge clk) begin
    if (rst) begin
        vga_out.vcount <= '0;
        vga_out.vsync  <= '0;
        vga_out.vblnk  <= '0;
        vga_out.hcount <= '0;
        vga_out.hsync  <= '0;
        vga_out.hblnk  <= '0;
        vga_out.rgb    <= '0;
        pixel_addr     <= '0;

        hcount_d       <= '0;
        vcount_d       <= '0;
        hblnk_d        <= '0;
        vblnk_d        <= '0;
        hsync_d        <= '0;
        vsync_d        <= '0;

        rgb_d          <= '0;
    end else begin
        {vga_out.hcount, hcount_d} <= {hcount_d, vga_in.hcount}; 
        {vga_out.vcount, vcount_d} <= {vcount_d, vga_in.vcount};
        {vga_out.hblnk, hblnk_d} <= {hblnk_d, vga_in.hblnk};
        {vga_out.vblnk, vblnk_d} <= {vblnk_d, vga_in.vblnk};
        {vga_out.hsync, hsync_d} <= {hsync_d, vga_in.hsync};
        {vga_out.vsync, vsync_d} <= {vsync_d, vga_in.vsync};    

        vga_out.rgb    <= rgb_nxt;
        pixel_addr     <= pixel_addr_nxt;

        rgb_d[0] <= vga_in.rgb;
        rgb_d[1] <= rgb_d[0];
    end
end
 
always_comb begin
    if(vga_in.hcount >= x
    && vga_in.hcount < x+W
    && vga_in.vcount >= y
    && vga_in.vcount < y+H ) begin
        pixel_addr_nxt = {6'(vga_in.vcount - y), 6'(vga_in.hcount - x)};
    end else begin
        pixel_addr_nxt = '0;
    end

    if(vga_in.hcount > x+1
    && vga_in.hcount <= x+W+1
    && vga_in.vcount >= y
    && vga_in.vcount < y+H ) begin
        rgb_nxt = rgb_pixel;
    end else begin
        rgb_nxt = rgb_d[1];
    end
end
 
 
 endmodule
 