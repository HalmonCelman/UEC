// by KK

`timescale 1 ns / 1 ps

module top_vga_basys3 (
    input  wire clk,
    input  wire rx,
    input  wire loopback_enable,
    output logic tx,
    output logic rx_monitor,
    output logic tx_monitor
);

top_uart u_top_uart(
    .clk,
    .rx,
    .loopback_enable,
    .tx,
    .rx_monitor,
    .tx_monitor
);

endmodule
