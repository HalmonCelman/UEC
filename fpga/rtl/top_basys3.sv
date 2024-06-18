// by KK

`timescale 1 ns / 1 ps

module top_basys3 (
    input  wire clk,
    input wire rst,
    input  wire rx,
    input  wire sendBtn,
    output logic tx,
    output logic [3:0] an,
    output logic [6:0] seg,
    output logic dp
);

(* KEEP = "TRUE" *)
(* ASYNC_REG = "TRUE" *)

logic clk50MHz;

always_ff @(posedge clk) begin
    if(rst) begin
        clk50MHz <= '0;
    end
    else begin
        clk50MHz <= ~clk50MHz;
    end
end

top u_top(
    .clk(clk50MHz),
    .rst,
    .rx,
    .sendBtn,
    .tx,
    .an,
    .seg,
    .dp
);

endmodule
