`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:48:26 11/30/2021 
// Design Name: 
// Module Name:    D_mux 
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
`include"const.v"

module D_mux (
           input [31:0] ao_M,
           input [31:0] mgrf, //global

           input [31:0] rfrd1,
           input [1:0] mfrsd_c,
           output [31:0] mrs_D, //MFRSD

           input [31:0] rfrd2,
           input [1:0] mfrtd_c,
           output [31:0] mrt_D //MFRTD
       );

assign mrs_D = mfrsd_c==`RF_RD1 ? rfrd1:
					mfrsd_c==`AO_M ? ao_M:
					mfrsd_c==`M4 ? mgrf:
					rfrd1;

assign mrt_D = mfrtd_c==`RF_RD2 ? rfrd2:
					mfrtd_c==`AO_M ? ao_M:
					mfrtd_c==`M4 ? mgrf:
					rfrd2;

endmodule //D_mux
