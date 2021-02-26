module vga_drive(
    input vga_clk, rst,
    input [2:0] rgb_data,
    output hsync, vsync,
    output [2:0] vga_rgb,
    output [9:0] posx,
    output [9:0] posy
);                             

wire in_disp_area;

reg  [9:0] h_cnt;
reg  [9:0] v_cnt;

always @(posedge vga_clk, posedge rst) begin         
    if (rst)
        h_cnt <= 10'd0;                                  
    else begin
        if(h_cnt < 799)                                               
            h_cnt <= h_cnt + 1'b1;                               
        else 
            h_cnt <= 10'd0;  
    end
end
always @(posedge vga_clk, posedge rst) begin         
    if (rst)
        v_cnt <= 10'd0;                                  
    else if(h_cnt == 799) begin
        if(v_cnt < 524)                                               
            v_cnt <= v_cnt + 1'b1;                               
        else 
            v_cnt <= 10'd0;  
    end
end                                 

assign hsync  = (h_cnt <= 10'd95)? 1'b0 : 1'b1;
assign vsync  = (v_cnt <= 10'd1)? 1'b0 : 1'b1;

assign in_disp_area = (((h_cnt >= 10'd144) && (h_cnt < 10'd784)) && ((v_cnt >= 10'd35) && (v_cnt < 10'd525)))? 1'b1 : 1'b0;

assign vga_rgb = in_disp_area? rgb_data : 3'd0;

assign posx = in_disp_area? (h_cnt - 10'd143) : 10'd0;
assign posy = in_disp_area? (v_cnt -10'd34) : 10'd0;

endmodule 