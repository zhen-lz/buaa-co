`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:45:59 11/30/2021
// Design Name:
// Module Name:    control_T
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
`define Op 31:26
`define Func 5:0
`define Rs 25:21
`define Rt 20:16
`define Rd 15:11
module control_T (
           input [31:0] ir_D,
           input [31:0] ir_E,
           input [31:0] ir_M,
           input [31:0] ir_W,

           output [1:0] mfrsd,
           output [1:0] mfrtd,
           output [1:0] mfrse,
           output [1:0] mfrte,
           output mfrtm
       );

wire cal_r_M;
wire cal_i_M;
wire cal_r_W;
wire cal_i_W;
wire ld_W;
wire jal_W;

wire rsd;
wire rtd;
wire rse;
wire rte;
wire rtm;

assign cal_r_M = (ir_M[`Op]==`r_format & ir_M[`Func]==`addu) | (ir_M[`Op]==`r_format & ir_M[`Func]==`subu);
assign cal_i_M = (ir_M[`Op]==`ori) | (ir_M[`Op]==`lui);

assign cal_r_W = (ir_W[`Op]==`r_format & ir_W[`Func]==`addu) | (ir_W[`Op]==`r_format & ir_W[`Func]==`subu);
assign cal_i_W = (ir_W[`Op]==`ori) | (ir_W[`Op]==`lui);
assign ld_W = ir_W[`Op]==`lw;
assign jal_W = ir_W[`Op]==`jal;
//数据供给端

assign rsd = (ir_D[`Op]==`beq) | (ir_D[`Op]==`r_format & ir_D[`Func]==`jr);
assign rtd = ir_D[`Op]==`beq;

assign rse = (ir_E[`Op]==`r_format & ir_E[`Func]==`addu) | (ir_E[`Op]==`r_format & ir_E[`Func]==`subu) |
				 (ir_E[`Op]==`lui | ir_E[`Op]==`ori) |
				 ir_E[`Op]==`lw |
				 ir_E[`Op]==`sw;
assign rte = (ir_E[`Op]==`r_format & ir_E[`Func]==`addu) | (ir_E[`Op]==`r_format & ir_E[`Func]==`subu) |
				 ir_E[`Op]==`sw;
assign rtm = ir_M[`Op]==`sw;
//数据需求端

assign mfrsd = rsd & cal_r_M & ir_D[`Rs]==ir_M[`Rd] ? (ir_D[`Rs] == 0 ? 0 : 1) :
					rsd & cal_i_M & ir_D[`Rs]==ir_M[`Rt] ? (ir_D[`Rs] == 0 ? 0 : 1):
					rsd & cal_r_W & ir_D[`Rs]==ir_W[`Rd] ? (ir_D[`Rs] == 0 ? 0 : 2):
					rsd & cal_i_W & ir_D[`Rs]==ir_W[`Rt] ? (ir_D[`Rs] == 0 ? 0 : 2):
					rsd & ld_W & ir_D[`Rs]==ir_W[`Rt] ? (ir_D[`Rs] == 0 ? 0 : 2):
					rsd & jal_W & ir_D[`Rs]==5'd31 ? 2:
					0;
assign mfrtd = rtd & cal_r_M & ir_D[`Rt]==ir_M[`Rd] ? (ir_D[`Rt] == 0 ? 0 : 1) :
					rtd & cal_i_M & ir_D[`Rt]==ir_M[`Rt] ? (ir_D[`Rt] == 0 ? 0 : 1):
					rtd & cal_r_W & ir_D[`Rt]==ir_W[`Rd] ? (ir_D[`Rt] == 0 ? 0 : 2):
					rtd & cal_i_W & ir_D[`Rt]==ir_W[`Rt] ? (ir_D[`Rt] == 0 ? 0 : 2):
					rtd & ld_W & ir_D[`Rt]==ir_W[`Rt] ? (ir_D[`Rt] == 0 ? 0 : 2):
					rtd & jal_W & ir_D[`Rt]==5'd31 ? 2:
					0;
assign mfrse = rse & cal_r_M & ir_E[`Rs]==ir_M[`Rd] ? (ir_E[`Rs] == 0 ? 0 : 1) :
					rse & cal_i_M & ir_E[`Rs]==ir_M[`Rt] ? (ir_E[`Rs] == 0 ? 0 : 1):
					rse & cal_r_W & ir_E[`Rs]==ir_W[`Rd] ? (ir_E[`Rs] == 0 ? 0 : 2):
					rse & cal_i_W & ir_E[`Rs]==ir_W[`Rt] ? (ir_E[`Rs] == 0 ? 0 : 2):
					rse & ld_W & ir_E[`Rs]==ir_W[`Rt] ? (ir_E[`Rs] == 0 ? 0 : 2):
					rse & jal_W & ir_E[`Rs]==5'd31 ? 2:
					0;
assign mfrte = rte & cal_r_M & ir_E[`Rt]==ir_M[`Rd] ? (ir_E[`Rt] == 0 ? 0 : 1):
					rte & cal_i_M & ir_E[`Rt]==ir_M[`Rt] ? (ir_E[`Rt] == 0 ? 0 : 1):
					rte & cal_r_W & ir_E[`Rt]==ir_W[`Rd] ? (ir_E[`Rt] == 0 ? 0 : 2):
					rte & cal_i_W & ir_E[`Rt]==ir_W[`Rt] ? (ir_E[`Rt] == 0 ? 0 : 2):
					rte & ld_W & ir_E[`Rt]==ir_W[`Rt] ? (ir_E[`Rt] == 0 ? 0 : 2):
					rte & jal_W & ir_E[`Rt]==5'd31 ? 2:
					0;

assign mfrtm = rtm & cal_r_W & ir_M[`Rt]==ir_W[`Rd] ? (ir_M[`Rt] == 0 ? 0 : 1) :
					rtm & cal_i_W & ir_M[`Rt]==ir_W[`Rt] ? (ir_M[`Rt] == 0 ? 0 : 1):
					rtm & ld_W & ir_M[`Rt]==ir_W[`Rt] ? (ir_M[`Rt] == 0 ? 0 : 1):
					rtm & jal_W & ir_M[`Rt]==5'd31 ? 1:
					0;

endmodule //control_T
