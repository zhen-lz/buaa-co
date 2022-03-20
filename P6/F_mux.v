`timescale 1ns / 1ps
`include "const.v"

module F_mux(
           input [31:0] pc_F,
           input [31:0] npc,
           input [31:0] jrrs,
           input [1:0] pc_c,
           output [31:0] new_pc
       );

assign new_pc = (pc_c==`PC4 ? pc_F + 4:
                 pc_c==`NPC ? npc:
                 pc_c==`JRRS ? jrrs:
                 pc_F + 4);

endmodule
