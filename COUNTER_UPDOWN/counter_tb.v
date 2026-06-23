`timescale 1ns/1ps

module counter_tb;
   reg clk;
   reg rst;
   reg up_down;
  wire [7:0] count;


counter dut (
.clk(clk),
.rst(rst),
.up_down(up_down),
.count(count)
);

always #5 clk = ~clk;

initial begin
     clk = 0;
     rst = 1;

     repeat(10) @(posedge clk);

     rst = 0;
     up_down = 1;

     repeat(20) @(posedge clk);

     up_down = 0;
     repeat(20) @(posedge clk);

     #20;
     $finish;
end
endmodule
