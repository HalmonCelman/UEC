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

// VGA signals from background timing and rect
vga_if vga_tim(), vga_bg(), vga_rect();
/**
 * Signals assignments
 */

assign vs = vga_rect.vsync;
assign hs = vga_rect.hsync;
assign {r,g,b} = vga_rect.rgb;

wire [11:0] xpos;
wire [11:0] ypos;

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

draw_rect u_draw_rect (
    .clk,
    .rst,

    .x(xpos),
    .y(ypos),
    
    .vga_in(vga_bg),
    .vga_out(vga_rect)
);

MouseCtl u_MouseCtl (
    .clk(clk100MHz),
    .rst,
    .ps2_clk,
    .ps2_data,
    .xpos,
    .ypos
);

endmodule
