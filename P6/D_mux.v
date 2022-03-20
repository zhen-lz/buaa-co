`timescale 1ns / 1ps
`include"const.v"

module D_mux (
           input [31:0] ao_M,
           input [31:0] mgrf,
           input [31:0] hilo, //global

           input [31:0] rfrd1,
           input [1:0] mfrsd_c,
           output [31:0] rs_D, //MFRSD

           input [31:0] rfrd2,
           input [1:0] mfrtd_c,
           output [31:0] rt_D //MFRTD
       );

assign rs_D = mfrsd_c==`RF_RD1 ? rfrd1:
       mfrsd_c==`AO_M ? ao_M:
       mfrsd_c==`M4 ? mgrf:
       mfrsd_c==`HILO ? hilo:
       rfrd1;

assign rt_D = mfrtd_c==`RF_RD2 ? rfrd2:
       mfrtd_c==`AO_M ? ao_M:
       mfrtd_c==`M4 ? mgrf:
       mfrtd_c==`HILO ? hilo:
       rfrd2;

endmodule //D_mux
