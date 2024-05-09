/*
    by KK

    module controlling rect with defined dimensions in rect_pkg
    
    - outputs defines top left corner of rect
    - outputs follows mouse_xpos and mouse_ypos until "click" (positive edge triggered) of the left button of  mouse
    then rect is falling with acceleration defined by DVY parameter
    - when rect reaches bottom it bounce with elasticity coefficient defined by K parameter
    then it will continue to go up until it reaches minimum speed 
    then it will fall again and all this cycle over and over again
    - at any moment can follow back mouse - it will happen when user clicks left button of mouse again

*/

module draw_rect_ctl
#(
    parameter K = 80,   // elasticity coefficient [%]
    parameter DVY = 1   // acceleration px/0.1s^2
)
(
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

logic [5:0] dy, dy_nxt; //up to 64 pixels at once

// prescalers for main clock
localparam clock_divide_ctr = 400000 - 1; // 100Hz - 40MHz / (clock_divide_ctr+1)
localparam clock_divide_second_ctr = 10 - 1; // 10Hz - 100Hz / (clock_divide_second_ctr+1) 

// confirm mouse click - positive edge triggered click
logic mouse_left_prv, mouse_pressed;    


logic [11:0] xpos_nxt;
logic [11:0] ypos_nxt;

// slow counters "clock" generation of 100Hz and 10Hz
logic [18:0] slow_ctr;
logic [18:0] slow_ctr_nxt;
logic [3:0] very_slow_ctr;
logic [3:0] very_slow_ctr_nxt;

enum {MOUSE, GO_DOWN, GO_UP} state, state_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        xpos            <= '0;
        ypos            <= '0;
        dy              <= '0;
        state           <= MOUSE;
        slow_ctr        <= '0;
        very_slow_ctr   <= '0;
        mouse_left_prv  <= '0;
    end else begin
        slow_ctr        <= slow_ctr_nxt;
        very_slow_ctr   <= very_slow_ctr_nxt;
        dy              <= dy_nxt;
        xpos            <= xpos_nxt;
        ypos            <= ypos_nxt;
        mouse_left_prv  <= mouse_left;
        state           <= state_nxt;
    end
end

always_comb begin
    mouse_pressed = ~mouse_left_prv & mouse_left; // confirm rising edge on mouse

    case(state)                             // FSM
        MOUSE: begin   
            if(mouse_pressed && ypos <= VER_PIXELS - RECT_HEIGHT) begin
                state_nxt = GO_DOWN;
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
        
        GO_DOWN: begin
            if(mouse_pressed) begin
                state_nxt = MOUSE;
            end else if(ypos >= VER_PIXELS - RECT_HEIGHT) begin    // bounce if too low
                state_nxt = GO_UP;
            end else begin
                state_nxt = GO_DOWN;
            end
            
            // if bounce then another speed - elasticity coefficient
            if(slow_ctr == (clock_divide_ctr-1)) begin
                xpos_nxt = xpos;
                ypos_nxt = ypos + dy;

                if(very_slow_ctr == (clock_divide_second_ctr-1)) begin
                    dy_nxt = ((state_nxt == GO_UP) ? (K*dy/100): dy) + DVY; 
                end else begin
                    dy_nxt = (state_nxt == GO_UP) ? (K*dy/100): dy;
                end

            end else begin
                xpos_nxt = xpos;
                ypos_nxt = ypos;
                
                dy_nxt = (state_nxt == GO_UP) ? (K*dy/100): dy;
            end
        end

        GO_UP: begin
            if(mouse_pressed) begin
                state_nxt = MOUSE;
            end else if(dy < DVY) begin // if your speed is low (you're at highest point) go down 
                state_nxt = GO_DOWN;
            end else begin
                state_nxt = GO_UP;
            end

            if(slow_ctr == (clock_divide_ctr-1)) begin
                xpos_nxt = xpos;
                ypos_nxt = ypos - dy;

                if(very_slow_ctr == clock_divide_second_ctr) begin
                    if(dy) begin
                        dy_nxt = dy - DVY;
                    end else begin
                        dy_nxt = '0;
                    end
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

        if(state_nxt == GO_UP) begin                        // if you're going up then 10Hz clock is reversed
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