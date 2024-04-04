/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */


`timescale 1 ns / 1 ps

module draw_bg (
    input  logic clk,
    input  logic rst,

    vga_if.in vga_in,
    vga_if.out vga_out
);

import vga_pkg::*;

/*
 parameters for drawing
*/
`define LK_X 65
`define  LK_X_END 335
`define  RK_X 465
`define  RK_X_END 735

`define  K_Y 30
`define K_Y_END 570

`define R 270
`define L_W 20

/**
 * Local variables and signals
 */

logic [11:0] rgb_nxt;


/**
 * Internal logic
 */

always_ff @(posedge clk) begin : bg_ff_blk
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


function bit circle(input [10:0] x, [10:0] y, int X0, Y0, RI, WIDTH);
    if( ((x - X0)*(x - X0) + (y - Y0) * (y - Y0) <= (RI + WIDTH) * (RI + WIDTH)) &&     // external loop
        ((x - X0)*(x - X0) + (y - Y0) * (y - Y0) >= (RI) * (RI)) )                      // internal loop
    return 1'b1;         
    else
    return 1'b0;
endfunction

always_comb begin : bg_comb_blk
    if (vga_in.vblnk || vga_in.hblnk) begin             // Blanking region:
        rgb_nxt = 12'h0_0_0;                    // - make it it black.
    end else begin                              // Active region:
        if (vga_in.vcount == 0)                     // - top edge:
            rgb_nxt = 12'hf_f_0;                // - - make a yellow line.
        else if (vga_in.vcount == VER_PIXELS - 1)   // - bottom edge:
            rgb_nxt = 12'hf_0_0;                // - - make a red line.
        else if (vga_in.hcount == 0)                // - left edge:
            rgb_nxt = 12'h0_f_0;                // - - make a green line.
        else if (vga_in.hcount == HOR_PIXELS - 1)   // - right edge:
            rgb_nxt = 12'h0_0_f;                // - - make a blue line.
        
        // first K
        else if(vga_in.hcount >= `LK_X && vga_in.hcount <= `LK_X + `L_W && vga_in.vcount >= `K_Y  && vga_in.vcount <= `K_Y_END)                  // left line
            rgb_nxt = 12'h6_3_f;                // light blue color
        else if(circle(vga_in.hcount, vga_in.vcount, `LK_X, `K_Y, `R, `L_W) &&                                            // first circle
        vga_in.hcount >= `LK_X &&                                                                                                // only one quarter
        vga_in.vcount >= `K_Y )                     
            rgb_nxt = 12'h6_3_f;                // light blue color
        else if(circle(vga_in.hcount, vga_in.vcount, `LK_X, `K_Y_END, `R, `L_W) &&                                        // second circle
        vga_in.hcount >= `LK_X &&                                                                                                // only one quarter
        vga_in.vcount <= `K_Y_END )                     
            rgb_nxt = 12'h6_3_f;                // light blue color

        // second K
        else if(vga_in.hcount >= `RK_X && vga_in.hcount <= `RK_X + `L_W && vga_in.vcount >= `K_Y  && vga_in.vcount <= `K_Y_END)                  // left line
            rgb_nxt = 12'h6_3_f;                // light blue color
        else if(circle(vga_in.hcount, vga_in.vcount, `RK_X, `K_Y, `R, `L_W) &&                                            // first circle
        vga_in.hcount >= `RK_X &&                                                                                                // only one quarter
        vga_in.vcount >= `K_Y )                     
            rgb_nxt = 12'h6_3_f;                // light blue color
        else if(circle(vga_in.hcount, vga_in.vcount, `RK_X, `K_Y_END, `R, `L_W) &&                                        // second circle
        vga_in.hcount >= `RK_X &&                                                                                                // only one quarter
        vga_in.vcount <= `K_Y_END )                     
            rgb_nxt = 12'h6_3_f;                // light blue color

        else                                    // The rest of active display pixels:
            rgb_nxt = 12'h8_8_8;                // - fill with gray.
    end
end

endmodule
