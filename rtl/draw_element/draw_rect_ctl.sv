module draw_rect_ctl(
    input logic clk,
    input logic rst,
    input logic mouse_left,
    input logic [11:0] mouse_xpos,
    input logic [11:0] mouse_ypos,

    output logic [11:0] xpos,
    output logic [11:0] ypos
);

import vga_pkg::*;
import rect_pkg::*;

logic [3:0] dy, dy_nxt; //up to 16 pixels

localparam K = 0.8;
localparam dvy = 1;
localparam clock_divide_ctr = 2;
localparam clock_divide_second_ctr = 10;

logic mouse_left_prv, mouse_pressed;

logic [11:0] xpos_nxt;
logic [11:0] ypos_nxt;

logic [18:0] slow_ctr;
logic [18:0] slow_ctr_nxt;
logic [3:0] very_slow_ctr;
logic [3:0] very_slow_ctr_nxt;

enum {MOUSE, FREE, BOUNCE} state, state_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        xpos <= '0;
        ypos <= '0;
        dy <= '0;
        state <= MOUSE;
        slow_ctr <= '0;
        very_slow_ctr <= '0;
        mouse_left_prv <= '0;
    end else begin
        slow_ctr <= slow_ctr_nxt;
        very_slow_ctr <= very_slow_ctr_nxt;
        dy <= dy_nxt;
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
        mouse_left_prv <= mouse_left;
        state <= state_nxt;
    end
end

always_comb begin
    mouse_pressed = ~mouse_left_prv & mouse_left; // confirm rising edge on mouse

    case(state)                             // FSM
        MOUSE: begin   
            if(mouse_pressed && ypos <= VER_PIXELS - RECT_HEIGHT) begin
                state_nxt = FREE;
            end else begin
                state_nxt = MOUSE;
            end

            if(slow_ctr == (clock_divide_ctr-1)) begin
                xpos_nxt = mouse_xpos;
                ypos_nxt = mouse_ypos;
            end else begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
            end

            dy_nxt = '0;
        end
        FREE: begin
            if(mouse_pressed) begin
                state_nxt = MOUSE;
            end else if(ypos + dy >= VER_PIXELS - RECT_HEIGHT) begin
                state_nxt = BOUNCE;
            end else begin
                state_nxt = FREE;
            end
            
            if(slow_ctr == (clock_divide_ctr-1)) begin
                xpos_nxt = xpos;
                ypos_nxt = ypos + dy;

                if(very_slow_ctr == (clock_divide_second_ctr-1)) begin
                    dy_nxt = dy + dvy;
                end else begin
                    dy_nxt = dy;
                end

            end else begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
                
                dy_nxt = dy;
            end
        end
        BOUNCE: begin
            if(mouse_pressed) begin
                state_nxt = MOUSE;
            end else if(dy < dvy && (ypos - dy < VER_PIXELS - RECT_HEIGHT)) begin
                state_nxt = FREE;
            end else begin
                state_nxt = BOUNCE;
            end

            if(slow_ctr == (clock_divide_ctr-1)) begin
                xpos_nxt = xpos;
                ypos_nxt = ypos - dy;

                if(very_slow_ctr == clock_divide_second_ctr) begin
                    dy_nxt = dy - dvy;
                end else begin
                    dy_nxt = dy;
                end

            end else begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
            
                dy_nxt = dy;
            end
        end
        default: begin
            state_nxt = MOUSE;
            xpos_nxt = mouse_xpos;
            ypos_nxt = mouse_ypos;
            dy_nxt = '0;
        end
    endcase

    if(state != state_nxt) begin
        slow_ctr_nxt = '0;
        very_slow_ctr_nxt = very_slow_ctr;
    end else if(slow_ctr >= clock_divide_ctr) begin         // generate sub-clocks
        slow_ctr_nxt = '0;

        if(state_nxt == BOUNCE) begin
            if(very_slow_ctr == '0) begin
                very_slow_ctr_nxt = clock_divide_second_ctr;
            end else begin
                very_slow_ctr_nxt = very_slow_ctr - 1;
            end
        end else begin
            if(very_slow_ctr >= clock_divide_second_ctr) begin
                very_slow_ctr_nxt = '0;
            end else begin
                very_slow_ctr_nxt = very_slow_ctr + 1;
            end
        end

    end else begin
        slow_ctr_nxt = slow_ctr + 1;
        very_slow_ctr_nxt = very_slow_ctr;
    end
    
end

endmodule