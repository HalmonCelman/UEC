module draw_rect_ctl(
    input logic clk,
    input logic rst,
    input logic mouse_left,
    input logic [11:0] mouse_xpos,
    input logic [11:0] mouse_ypos,

    output logic [11:0] xpos,
    output logic [11:0] ypos
);

logic [11:0] xpos_nxt;
logic [11:0] ypos_nxt;

enum {MOUSE, FREE, DOWN} state, state_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        xpos <= '0;
        ypos <= '0;
        state <= MOUSE;
    end else begin
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
        state <= state_nxt;
    end
end

always_comb begin
    if(state == MOUSE && mouse_left == 0) begin
        state_nxt = MOUSE;
        xpos_nxt = mouse_xpos;
        ypos_nxt = mouse_ypos;
    end
    else if(ypos < 100) begin
        state_nxt = FREE;
        xpos_nxt = xpos;
        ypos_nxt = ypos+1;
    end else begin
        state_nxt = DOWN;
        xpos_nxt = xpos;
        ypos_nxt = ypos;
    end
end

endmodule