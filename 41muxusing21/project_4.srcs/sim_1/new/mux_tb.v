`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2026 14:56:55
// Design Name: 
// Module Name: mux_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux_tb;
wire a,b,c,d,s0,s1;
wire y;
wire w1,w2;

mux m1 (.a(a),.b(b),.s0(s0),.y(w1));
mux m2(.a(c),.bdb),.s0(s0),.y(w2));
mux m3 (.a(w1),.b(w2),.s0(s1),.y(y));





endmodule
