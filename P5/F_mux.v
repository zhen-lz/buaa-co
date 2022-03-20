`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:52:05 11/30/2021 
// Design Name: 
// Module Name:    F_mux 
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

module F_mux (
           input [31:0] pc4,
           input [31:0] npc,
           input [31:0] rfrd1,
           input [1:0] mpc_c,
           output [31:0] new_pc //M1
       );

assign new_pc = mpc_c==`PC4 ? pc4:
					 mpc_c==`NPC ? npc:
					 mpc_c==`RFRD1 ? rfrd1:
					 pc4;

endmodule //F_mux
