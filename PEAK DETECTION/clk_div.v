`timescale 1ns / 1ps
// clock divider


module clk_div #(
    parameter integer DIV_RATIO = 4
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_en
);

localparam CNT_W = $clog2(DIV_RATIO);

reg [CNT_W-1:0] count;

assign clk_en = (count == DIV_RATIO-1);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        count <= 0;
    else if(count == DIV_RATIO-1)
        count <= 0;
    else
        count <= count + 1'b1;
end

endmodule
