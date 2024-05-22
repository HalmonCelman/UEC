module uart_monitor (
    input  wire clk,
    input  wire rx,
    input  wire loopback_enable,
    output logic tx,
    output logic rx_monitor,
    output logic tx_monitor
);

logic tx_nxt;

always_ff @(posedge clk) begin
    tx <= tx_nxt;
    rx_monitor <= rx;
    tx_monitor <= tx;
end

always_comb begin
    if(loopback_enable) begin
        tx_nxt = rx;
    end else begin
        tx_nxt = '0;
    end
end

endmodule