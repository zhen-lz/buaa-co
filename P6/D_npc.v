`timescale 1ns / 1ps
`include "const.v"

`define Op 31:26
`define Func 5:0
`define Rt 20:16

module D_npc (
           input [31:0] pc_D,
           input [31:0] ir_D,
           input judge,
           output [31:0] npc
       );

wire b;
wire j;

assign b = ir_D[`Op]==`beq | ir_D[`Op]==`bne | ir_D[`Op]==`blez | ir_D[`Op]==`bgtz | (ir_D[`Op]==`spc & ir_D[`Rt]==`bltz) | (ir_D[`Op]==`spc & ir_D[`Rt]==`bgez);
assign j = ir_D[`Op]==`j | ir_D[`Op]==`jal;

assign npc= (b ? ( judge ? (pc_D + 4 + { { 14{ir_D[15]} },ir_D[15:0],2'b0 })  : pc_D + 4) :
             j ? {pc_D[31:28],ir_D[25:0],2'b0}:
             `zero);

endmodule //D_npc

