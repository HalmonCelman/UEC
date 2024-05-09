/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * The project top module.
 */

`timescale 1 ns / 1 ps

module top_vga (
    input  logic clk,
    input  logic clk100MHz,
    input  logic rst,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b,

    inout logic ps2_clk,
    inout logic ps2_data
);


/**
 * Local variables and signals
 */

// VGA signals from background timing, rect, and mouse
vga_if vga_tim(), vga_bg(), vga_rect(), vga_mouse(), vga_rect_char();
/**
 * Signals assignments
 */

assign vs = vga_rect_char.vsync;
assign hs = vga_rect_char.hsync;
assign {r,g,b} = vga_rect_char.rgb;
logic [11:0] x;
logic [11:0] y;

logic [11:0] mouse_x, mouse_y;
logic mouse_left;

logic [11:0] pixel_addr;
logic [11:0] rgb_pixel;

logic [7:0] char_xy;
logic [3:0] char_line;
logic [6:0] char_code;
logic [7:0] char_pixels;

/**
 * Submodules instances
 */

vga_timing u_vga_timing (
    .clk,
    .rst,
    .vga(vga_tim)
);

draw_bg u_draw_bg (
    .clk,
    .rst,
    .vga_in(vga_tim),
    .vga_out(vga_bg)
);

image_rom u_image_rom(
    .clk,
    .address(pixel_addr),
    .rgb(rgb_pixel)
);

import rect_pkg::*;

draw_rect#(
    .H(RECT_HEIGHT),
    .W(RECT_WIDTH)
) u_draw_rect (
    .clk,
    .rst,
    .x,
    .y,
    .pixel_addr,
    .rgb_pixel,
    .vga_in(vga_bg),
    .vga_out(vga_rect)
);

draw_rect_ctl u_draw_rect_ctl (
    .clk,
    .rst,
    .mouse_left(mouse_left),
    .mouse_xpos(mouse_x),
    .mouse_ypos(mouse_y),
    .xpos(x),
    .ypos(y)
);

draw_mouse u_draw_mouse (
    .clk,
    .rst,
    .x(mouse_x),
    .y(mouse_y),
    .vga_in(vga_rect),
    .vga_out(vga_mouse)
);

draw_rect_char #(
    .X(200),
    .Y(50)
) u_draw_rect_char (
    .clk,
    .rst,
    .vga_in(vga_mouse),
    .vga_out(vga_rect_char),

    .char_line,
    .char_xy,
    .char_pixels
);

font_rom u_font_rom (
    .clk,
    .addr({char_code, char_line}),
    .char_line_pixels(char_pixels)
);

char_rom_16x16 u_char_rom_16x16 (
    .clk,
    .char_code,
    .char_xy
);

mouse_control u_mouse_control(
    .clk100MHz,
    .clk40MHz(clk),
    .left(mouse_left),
    .rst,
    .ps2_clk,
    .ps2_data,
    .x(mouse_x),
    .y(mouse_y)
);

endmodule
