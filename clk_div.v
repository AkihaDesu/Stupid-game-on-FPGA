module clk_div(
    input clock,
    input rst,
    output reg vga_clk
);
    reg clk_tmp;
    always @(posedge clk_tmp or posedge rst) begin
        if (rst)
            vga_clk <= 0;
        else
            vga_clk <= ~vga_clk;
    end
    always @(posedge clock or posedge rst) begin
        if (rst)
            clk_tmp <= 0;
        else
            clk_tmp <= ~clk_tmp;
    end
endmodule