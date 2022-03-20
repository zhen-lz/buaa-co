`timescale 1ns / 1ps
`include "const.v"
`define Rt 20:16
`define Rd 15:11

module W_mux (
           input [31:0] ir_W,
           input [1:0] ma3_c,
           output [4:0] ma3, //M3

           input [31:0] dr_W,
           input [31:0] ao_W,
           input [31:0] pc_W,
           input [31:0] hilo_W,
           input [1:0] mWD_c,
           output [31:0] mWD //M4

       );

assign ma3 = ma3_c==`Art ? ir_W[`Rt]:
       ma3_c==`Ard ? ir_W[`Rd]:
       ma3_c==`A31 ? 5'd31:
       ir_W[`Rt];

assign mWD = mWD_c==`DR_W ? dr_W:
       mWD_c==`AO_W ? ao_W:
       mWD_c==`PC_W ? pc_W+8:
       mWD_c==`HILO_W ? hilo_W:
       dr_W;

endmodule //W_mux
