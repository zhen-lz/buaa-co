`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:51:05 11/30/2021 
// Design Name: 
// Module Name:    E_mux 
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

module E_mux (
           input [31:0] ao_M,
           input [31:0] mgrf, //global

           input [31:0] rs_E,
           input [1:0] mfrse_c,
           output [31:0] mrs_E, //MFRSE

           input [31:0] rt_E,
           input [1:0] mfrte_c,
           output [31:0] mrt_E, //MFRTE

           input [31:0] ext_E,
           input malub_c,
           output [31:0] malub //M2
       );

assign mrs_E = mfrse_c==`RS_E ? rs_E:
					mfrse_c==`AO_M ? ao_M:
					mfrse_c==`M4 ? mgrf:
					rs_E;

assign mrt_E = mfrte_c==`RT_E ? rt_E:
					mfrte_c==`AO_M ? ao_M:
					mfrte_c==`M4 ? mgrf:
					rt_E;

assign malub = malub_c ? ext_E : mrt_E;

endmodule //E_mux
