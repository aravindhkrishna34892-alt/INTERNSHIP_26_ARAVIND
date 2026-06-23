`timescale 1 ns/10 ps
module counter(
    input  wire  clk,
    input  wire  rst,
    input  wire  up_down,
    output reg[7:0]  count
);

always @ (posedge clk) begin
   if (rst)
       count <= 8'b00000000;
  else if (up_down)
      count <= count + 1'b1;
  else
     count <= count - 1'b1;
end
endmodule  
