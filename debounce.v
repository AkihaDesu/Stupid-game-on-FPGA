module debounce(
    input clk, rst,
    input in,
	output reg out
    );

parameter delay_max = 20'd250000;

reg [31:0] delay_cnt;
reg        key_reg;

always @(posedge clk,posedge rst) begin 
    if (rst) begin 
        key_reg   <= 1'b0;
        delay_cnt <= 20'd0;
    end
    else begin
        key_reg <= in;
        if(key_reg != in)
            delay_cnt <= 20'd0;//10ms delay on 25Mhz clk
        else if(key_reg == in) begin
                 if(delay_cnt < delay_max)
                     delay_cnt <= delay_cnt + 1'b1;
                 else
                     delay_cnt <= delay_cnt;
             end           
    end   
end

always @(posedge clk, posedge rst) begin 
    if (rst) begin 
        out <= 1'b0;          
    end
    else begin
        if(delay_cnt == delay_max - 1'b1) begin
            out <= in;
        end
        else begin
            out <= out; 
        end  
    end   
end
    
endmodule 