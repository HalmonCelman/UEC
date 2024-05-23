// by KK

`timescale 1 ns / 1 ps

module top_uart (
    input  wire clk,
    input wire rst,
    input  wire rx,
    input  wire sendBtn,
    output logic tx,
    output logic [3:0] an,
    output logic [6:0] seg,
    output logic dp
);

logic buttonTick, rx_empty, readByte, readByte_nxt;
logic [7:0] rec_data;

uart u_uart(
    .clk,
    .reset(rst),
    .rd_uart(),
    .wr_uart(),
    .rx,
    .w_data(rec_data),
    .tx_full(),
    .rx_empty(rx_empty),
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

disp_hex_mux u_disp_hex_mux(
    .clk,
    .reset(rst),
    .an({an[0], an[1], an[2], an[3]}),
    .sseg({dp, seg[0], seg[1], seg[2], seg[3], seg[4], seg[5], seg[6]}),
    .dp_in('1),
    .hex0(1),
    .hex1(2),
    .hex2(3),
    .hex3(4)
);

endmodule
