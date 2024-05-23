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

logic buttonTick, rx_empty, readByte, readByte_nxt, rcv_tick;
logic [7:0] rec_data;

logic [3:0] hex0, hex1, hex2, hex3;

make_numbers u_make_numbers(
    .clk,
    .rst,
    .data_in(rec_data),
    .rx_empty,

    .char1({hex0,hex1}),
    .char2({hex2,hex3}),
    .readByte(rcv_tick) 
);

uart u_uart(
    .clk,
    .reset(rst),
    .rd_uart(rcv_tick),
    .wr_uart(buttonTick),
    .rx,
    .w_data({hex0,hex1}),
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
    .hex0,
    .hex1,
    .hex2,
    .hex3
);

endmodule
