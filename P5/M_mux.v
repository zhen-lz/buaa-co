`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:10 11/30/2021 
// Design Name: 
// Module Name:    M_mux 
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

module M_mux (
           input [31:0] rt_M,
           input [31:0] mgrf,
           input mfrtm_c,
           output [31:0] mrt_M //MFRTM
       );
       
assign mrt_M = mfrtm_c ? mgrf : rt_M;

endmodule //M_mux
