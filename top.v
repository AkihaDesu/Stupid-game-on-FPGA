module top(
    input clk, rst,
    input btn_up, btn_down,                     
    output hsync, vsync,
    output [2:0] vga_rgb
    ); 

wire vga_clk_w;
wire [2:0] rgb_data_w;
wire [9:0] posx_w;
wire [9:0] posy_w;

clk_div clk_div_u(  .clock(clk),
                    .rst(rst),
                    .vga_clk(vga_clk_w));

vga_drive vga_driver_u( .vga_clk (vga_clk_w),    
                        .rst (rst),
                        .hsync (hsync),
                        .vsync (vsync),
                        .vga_rgb (vga_rgb),
                        .rgb_data (rgb_data_w), 
                        .posx (posx_w), 
                        .posy (posy_w)); 
    
pong pong_u(.vga_clk (vga_clk_w),
            .rst (rst),
            .btn_up(btn_up),
            .btn_down(btn_down),
            .posx (posx_w),
            .posy (posy_w),
            .rgb_data (rgb_data_w));   
    
endmodule 