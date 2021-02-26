module pong(
    input vga_clk, rst,
    input [9:0] posx, posy,
    input btn_up, btn_down,
    output reg [2:0] rgb_data
);    

parameter paddle_width  = 10'd20;
parameter paddle_length = 10'd120;

parameter ball_width = 10'd20;

reg [9:0] ball_x;
reg [9:0] ball_y;
reg [21:0] div_cnt;
reg x_direction;
reg y_direction;

reg [9:0] paddle_y;

reg [7:0] score;

wire [1:0] key_state;
debounce key_debounce_up(   .clk(vga_clk),
                                .rst(rst),
                                .in(btn_up),
                                .out(key_state[0]));
debounce key_debounce_down( .clk(vga_clk),
                                .rst(rst),
                                .in(btn_down),
                                .out(key_state[1]));

//only update graph every 5ms, refresh rate is 200hz
wire updatable;
assign updatable = (div_cnt == 22'd125000 - 1'b1) ? 1'b1: 1'b0;
always @(posedge vga_clk ,posedge rst) begin         
    if (rst)
        div_cnt <= 22'd0;
    else begin
        if(div_cnt < 22'd125000 - 1'b1) 
            div_cnt <= div_cnt + 1'b1;
        else
            div_cnt <= 22'd0;
    end
end

//detect collision
always @(posedge vga_clk ,posedge rst) begin         
    if (rst) begin
        //1 as positive, 0 as negative
        x_direction <= 1'b1;
        y_direction <= 1'b1;
        score <= 8'd0;
    end
    else begin
        //change direction when hit paddle and borders
        if (((ball_x == paddle_width) || (ball_x == 10'd640 - paddle_width - ball_width)) &&
            ((ball_y > paddle_y + paddle_length) || (ball_y + ball_width < paddle_y)))
            score <= 8'd0;
        else if (ball_x == paddle_width)begin
            x_direction <= 1'b1;
            score <= score + 1'b1;
        end               
        else if (ball_x == 10'd640 - paddle_width - ball_width) begin
            x_direction <= 1'b0;
            score <= score + 1'b1;
            end              
        else
            x_direction <= x_direction;
            
        if (ball_y == 1'b0)
            y_direction <= 1'b1;                
        else
        if (ball_y + ball_width == 10'd480)
            y_direction <= 1'b0;               
        else
            y_direction <= y_direction;
    end
end

//update ball
always @(posedge vga_clk, posedge rst) begin         
    if (rst) begin
        ball_x <= 22'd320;
        ball_y <= 22'd240;
    end
    else if(updatable) begin
        if(x_direction) 
            ball_x <= ball_x + 1'b1;
        else
            ball_x <= ball_x - 1'b1;
        if(y_direction) 
            ball_y <= ball_y + 1'b1;
        else
            ball_y <= ball_y - 1'b1;
    end
    else begin
        ball_x <= ball_x;
        ball_y <= ball_y;
    end
end

//update paddle
always @(posedge vga_clk, posedge rst) begin         
    if (rst) begin
        paddle_y <= 10'd100;
    end
    else if(updatable) begin
        case (key_state)
            2'b00: paddle_y <= paddle_y;
            //up
            2'b01: begin
                if (paddle_y == 1'b0)
                    paddle_y <= paddle_y;
                else
                    paddle_y <= paddle_y - 1'b1;
            end
            //down
            2'b10: begin
                if (paddle_y + paddle_length == 10'd480)
                    paddle_y <= paddle_y;
                else
                    paddle_y <= paddle_y + 1'b1; 
            end
            2'b11: paddle_y <= paddle_y;
            default: paddle_y <= paddle_y;
        endcase
    end
    else begin
        paddle_y <= paddle_y;
    end
end

//fill colors
always @(posedge vga_clk, posedge rst) begin         
    if (rst) 
        rgb_data <= 3'b000;
    else begin
        //fill ball and paddle with white
        if((posx >= ball_x) && (posx < ball_x + ball_width) &&
           (posy >= ball_y) && (posy < ball_y + ball_width))
            rgb_data <= 3'b111;
        else if (posx < paddle_width && posy >= paddle_y && posy <= paddle_y + paddle_length ||
                 posx >= 10'd640 - paddle_width && posy >= paddle_y && posy <= paddle_y + paddle_length) begin
            rgb_data <= 3'b111;
        end
        //fill background with black
        else
            rgb_data <= 3'b000;
    end
end
endmodule 