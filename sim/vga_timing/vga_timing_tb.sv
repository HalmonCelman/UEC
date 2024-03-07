/**
 *  Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for vga_timing module.
 */

`timescale 1 ns / 1 ps

module vga_timing_tb;

import vga_pkg::*;


/**
 *  Local parameters
 */

localparam CLK_PERIOD = 25;     // 40 MHz


/**
 * Local variables and signals
 */

logic clk;
logic rst;

wire [10:0] vcount, hcount;
wire        vsync,  hsync;
wire        vblnk,  hblnk;


/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end


/**
 * Reset generation
 */

initial begin
                       rst = 1'b0;
    #(1.25*CLK_PERIOD) rst = 1'b1;
                       rst = 1'b1;
    #(2.00*CLK_PERIOD) rst = 1'b0;
end


/**
 * Dut placement
 */

vga_timing dut(
    .clk,
    .rst,
    .vcount,
    .vsync,
    .vblnk,
    .hcount,
    .hsync,
    .hblnk
);

/**
 * Tasks and functions
 */
 // Here you can declare tasks with immediate assertions (assert).

bit reseted;
task signals_initialized;
    assert(hcount == '0)    else $error("hcount is not 0 at start");
    assert(vcount == '0)    else $error("vcount is not 0 at start");
    assert(hblnk == '0)     else $error("hblnk is not 0 at start");
    assert(vblnk == '0)     else $error("vblnk is not 0 at start");
    assert(hsync == '0)     else $error("hsync is not 0 at start");
    assert(vsync == '0)     else $error("vsync is not 0 at start");
endtask;

/**
 * Assertions
 */

// Here you can declare concurrent assertions (assert property).
// counters check
assert property (@(posedge clk) ((rst == 1) || (reseted == 0) || (hcount < HOR_TOTAL_TIME))) else $error("hcount out of range");
assert property (@(posedge clk) ((rst == 1) || (reseted == 0) || (vcount < VER_TOTAL_TIME))) else $error("vcount out of range");

// hblnk check
assert property (@(posedge clk) ((hcount >= HOR_BLANK_START && hcount < HOR_BLANK_START + HOR_BLANK_TIME) |-> ( hblnk == 1 || rst == 1 || reseted == 0))) else $error("hblnk isn't going up");
assert property (@(posedge clk) ((hcount < HOR_BLANK_START || hcount > HOR_BLANK_START + HOR_BLANK_TIME) |-> (hblnk == 0 || rst == 1 || reseted == 0))) else $error("hblnk isn't going down");

// hsync check
assert property (@(posedge clk) ((hcount >= HOR_SYNC_START && hcount < HOR_SYNC_START + HOR_SYNC_TIME) |-> ( hsync == 1 || rst == 1 || reseted == 0))) else $error("hsync isn't going up");
assert property (@(posedge clk) ((hcount < HOR_SYNC_START || hcount > HOR_SYNC_START + HOR_SYNC_TIME) |-> (hsync == 0 || rst == 1 || reseted == 0))) else $error("hsync isn't going down");

// vblnk check
assert property (@(posedge clk) ((vcount >= VER_BLANK_START && vcount < VER_BLANK_START + VER_BLANK_TIME) |-> ( vblnk == 1 || rst == 1 || reseted == 0))) else $error("vblnk isn't going up");
assert property (@(posedge clk) ((vcount < VER_BLANK_START || vcount > VER_BLANK_START + VER_BLANK_TIME) |-> (vblnk == 0 || rst == 1 || reseted == 0))) else $error("vblnk isn't going down");

// vsync check
assert property (@(posedge clk) ((vcount >= VER_SYNC_START && vcount < VER_SYNC_START + VER_SYNC_TIME) |-> ( vsync == 1 || rst == 1 || reseted == 0))) else $error("vsync isn't going up");
assert property (@(posedge clk) ((vcount < VER_SYNC_START || vcount > VER_SYNC_START + VER_SYNC_TIME) |-> (vsync == 0 || rst == 1 || reseted == 0))) else $error("vsync isn't going down");


/**
 * Main test
 */

initial begin
    reseted = 0;

    @(posedge rst);
    @(negedge rst);

    reseted = 1;

    signals_initialized();

    wait (vsync == 1'b0);
    @(negedge vsync)
    @(negedge vsync)

    $finish;
end

endmodule
