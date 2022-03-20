`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:46:25 11/30/2021 
// Design Name: 
// Module Name:    D_ext 
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
`include "const.v"

module D_ext (
           input [15:0] imme16,
           input sign,
           output [31:0] imme32
       );

assign imme32 = sign ? {{16{imme16[15]}},imme16} : {{16{1'b0}},imme16};

endmodule //D_ext
