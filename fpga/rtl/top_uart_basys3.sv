// by KK

`timescale 1 ns / 1 ps

module top_vga_basys3 (
    input  wire clk,
    input wire rst,
    input  wire rx,
    input  wire sendBtn,
    output logic tx
);

logic clk50MHz;

always_ff @(posedge clk) begin
    if(rst) begin
        clk50MHz <= '0;
    end
    else begin
        clk50MHz <= ~clk50MHz;
    end
end

top_uart u_top_uart(
    .clk(clk50MHz),
    .rst,
    .rx,
    .sendBtn,
    .tx
);

endmodule
