// by KK

`timescale 1 ns / 1 ps

module top_uart (
    input  wire clk,
    input  wire rx,
    input  wire loopback_enable,
    output logic tx,
    output logic rx_monitor,
    output logic tx_monitor
);

(* KEEP = "TRUE" *)
(* ASYNC_REG = "TRUE" *)

uart_monitor u_uart_monitor(
    .clk,
    .rx,
    .loopback_enable,
    .tx,
    .rx_monitor,
    .tx_monitor
);

endmodule
