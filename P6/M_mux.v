`timescale 1ns / 1ps
`include "const.v"

module M_mux (
           input [31:0] rt_M,
           input [31:0] mgrf,
           input mfrtm_c,
           output [31:0] mrt_M //MFRTM
       );

assign mrt_M = mfrtm_c ? mgrf : rt_M;

endmodule //M_mux
