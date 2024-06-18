// by KK

`timescale 1 ns / 1 ps

module top (
    input wire clk,
    input wire rst,
    input wire PCenBtn,
    input wire extCtlBtn,
    input wire micRstBtn,
    input wire [5:0] ctrlBtns,
    output logic [3:0] an,
    output logic [6:0] seg,
    output logic dp
);

logic [3:0][3:0] hex;

microDebug u_microDebug(
    .clk,
    .rst,
    .micRstBtn,
    .PCenBtn,
    .extCtlBtn,
    .mode(ctrlBtns[1:0]),
    .register(ctrlBtns[5:2]),
    .monitorValue(hex[0:3])
);

disp_hex_mux u_disp_hex_mux(
    .clk,
    .reset(rst),
    .an({an[0], an[1], an[2], an[3]}),
    .sseg({dp, seg[0], seg[1], seg[2], seg[3], seg[4], seg[5], seg[6]}),
    .dp_in('1),
    .hex0(hex[0]),
    .hex1(hex[1]),
    .hex2(hex[2]),
    .hex3(hex[3])
);

endmodule
