`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2026 15:40:10
// Design Name: 
// Module Name: com
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


module com(
input a,b,
output y0,y1,y2
    );
    
    assign y0 = (a==b)?1:0;
    assign y1 = (a>b)?1:0;
    assign y2 = (a<b)?1:0;
      
endmodule
