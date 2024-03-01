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

    input  logic [10:0] vcount_in,
    input  logic        vsync_in,
    input  logic        vblnk_in,
    input  logic [10:0] hcount_in,
    input  logic        hsync_in,
    input  logic        hblnk_in,

    output logic [10:0] vcount_out,
    output logic        vsync_out,
    output logic        vblnk_out,
    output logic [10:0] hcount_out,
    output logic        hsync_out,
    output logic        hblnk_out,

    output logic [11:0] rgb_out
);

import vga_pkg::*;

/*
 parameters for drawing
*/
localparam LK_X = 65;
localparam LK_X_END = 335;
localparam RK_X = 465;
localparam RK_X_END = 735;

localparam K_Y = 30;
localparam K_Y_END = 570;

localparam R = 270;
localparam L_W = 20;

`define SQ(x) (x*x)  // squared value

/**
 * Local variables and signals
 */

logic [11:0] rgb_nxt;


/**
 * Internal logic
 */

always_ff @(posedge clk) begin : bg_ff_blk
    if (rst) begin
        vcount_out <= '0;
        vsync_out  <= '0;
        vblnk_out  <= '0;
        hcount_out <= '0;
        hsync_out  <= '0;
        hblnk_out  <= '0;
        rgb_out    <= '0;
    end else begin
        vcount_out <= vcount_in;
        vsync_out  <= vsync_in;
        vblnk_out  <= vblnk_in;
        hcount_out <= hcount_in;
        hsync_out  <= hsync_in;
        hblnk_out  <= hblnk_in;
        rgb_out    <= rgb_nxt;
    end
end

always_comb begin : bg_comb_blk
    if (vblnk_in || hblnk_in) begin             // Blanking region:
        rgb_nxt = 12'h0_0_0;                    // - make it it black.
    end else begin                              // Active region:
        if (vcount_in == 0)                     // - top edge:
            rgb_nxt = 12'hf_f_0;                // - - make a yellow line.
        else if (vcount_in == VER_PIXELS - 1)   // - bottom edge:
            rgb_nxt = 12'hf_0_0;                // - - make a red line.
        else if (hcount_in == 0)                // - left edge:
            rgb_nxt = 12'h0_f_0;                // - - make a green line.
        else if (hcount_in == HOR_PIXELS - 1)   // - right edge:
            rgb_nxt = 12'h0_0_f;                // - - make a blue line.

        // Add your code here.
        // first K
        else if(hcount_in >= LK_X && hcount_in <= LK_X + L_W && vcount_in >= K_Y  && vcount_in <= K_Y_END)                  // left line
            rgb_nxt = 12'h6_3_f;                // light blue color
        else if(myUtilities#(LK_X, K_Y, R, L_W)::circle(hcount_in, vcount_in) &&                                            // first circle
        hcount_in >= LK_X &&                                                                                                // only one quarter
        vcount_in >= K_Y )                     
            rgb_nxt = 12'h6_3_f;                // light blue color
        else if(myUtilities#(LK_X, K_Y_END, R, L_W)::circle(hcount_in, vcount_in) &&                                        // second circle
        hcount_in >= LK_X &&                                                                                                // only one quarter
        vcount_in <= K_Y_END )                     
            rgb_nxt = 12'h6_3_f;                // light blue color

        // second K
        else if(hcount_in >= RK_X && hcount_in <= RK_X + L_W && vcount_in >= K_Y  && vcount_in <= K_Y_END)                  // left line
            rgb_nxt = 12'h6_3_f;                // light blue color
        else if(myUtilities#(RK_X, K_Y, R, L_W)::circle(hcount_in, vcount_in) &&                                            // first circle
        hcount_in >= RK_X &&                                                                                                // only one quarter
        vcount_in >= K_Y )                     
            rgb_nxt = 12'h6_3_f;                // light blue color
        else if(myUtilities#(RK_X, K_Y_END, R, L_W)::circle(hcount_in, vcount_in) &&                                        // second circle
        hcount_in >= RK_X &&                                                                                                // only one quarter
        vcount_in <= K_Y_END )                     
            rgb_nxt = 12'h6_3_f;                // light blue color    

        else                                    // The rest of active display pixels:
            rgb_nxt = 12'h8_8_8;                // - fill with gray.
    end
end

virtual class myUtilities#(parameter X0, parameter Y0, parameter RI, parameter WIDTH);
    static function bit circle(bit [10:0] x,bit[10:0] y);
        if( ((x - X0)*(x - X0) + (y - Y0) * (y - Y0) <= (RI + WIDTH) * (RI + WIDTH)) &&     // external loop
            ((x - X0)*(x - X0) + (y - Y0) * (y - Y0) >= (RI) * (RI)) ) return 1'b1;         // internal loop
        else
        return 1'b0;
    endfunction
endclass

endmodule
