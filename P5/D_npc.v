`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:48:56 11/30/2021
// Design Name:
// Module Name:    D_npc
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

module D_npc (
           input [31:0] pc4_D,
           input [31:0] ir_D,
           output [31:0] npc
       );

assign npc= (ir_D[31:26]==`beq) ? pc4_D + { { 14{ir_D[15]} },ir_D[15:0],2'b0 }:
				(ir_D[31:26]==`j | ir_D[31:26]==`jal) ? {pc4_D[31:28],ir_D[25:0],2'b0}:
				`zero;

endmodule //D_npc

