`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:49 11/30/2021 
// Design Name: 
// Module Name:    W_mux 
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
`define Rt 20:16
`define Rd 15:11
module W_mux (
           input [31:0] ir_W,
           input [1:0] ma3_c,
           output [4:0] ma3, //M3

           input [31:0] dr_W,
           input [31:0] ao_W,
           input [31:0] pc4_W,
           input [1:0] mWD_c,
           output [31:0] mWD //M4

       );

assign ma3 = ma3_c==`Art ? ir_W[`Rt]:
				 ma3_c==`Ard ? ir_W[`Rd]:
				 ma3_c==`A31 ? 5'd31:
				 ir_W[`Rt];

assign mWD = mWD_c==`DR_W ? dr_W:
				 mWD_c==`AO_W ? ao_W:
			    mWD_c==`PC4_W ? pc4_W+4:
             dr_W;

endmodule //W_mux
