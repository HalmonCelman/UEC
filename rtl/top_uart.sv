// by KK

`timescale 1 ns / 1 ps

module top_uart (
    input  wire clk,
    input wire rst,
    input  wire rx,
    input  wire sendBtn,
    output logic tx
);

(* KEEP = "TRUE" *)
(* ASYNC_REG = "TRUE" *)

logic buttonTick;
logic [7:0] rec_data;

uart u_uart(
    .clk,
    .reset(rst),
    .rd_uart(buttonTick),
    .wr_uart(buttonTick),
    .rx,
    .w_data(rec_data),
    .tx_full(),
    .rx_empty(),
    .tx,
    .r_data(rec_data)
);

debounce u_debounce(
    .clk,
    .reset(rst),
    .sw(sendBtn),
    .db_level(),
    .db_tick(buttonTick)
);

endmodule
