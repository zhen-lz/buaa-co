`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:48:02 11/30/2021
// Design Name:
// Module Name:    D_judge
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`include"const.v"

module D_judge (
           input [31:0] mrd1,
           input [31:0] mrd2,
           output equal
       );

assign equal= mrd1==mrd2;

endmodule //D_judge
