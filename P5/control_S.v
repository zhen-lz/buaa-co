`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:45:20 11/30/2021
// Design Name:
// Module Name:    control_S
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

module control_S (
           input [31:0] ir_D,
           input [31:0] ir_E,
           input [31:0] ir_M,
           output pc_en,
           output d_en,
           output e_reset
       );

wire cal_r_D;
wire cal_r_E;
wire cal_i_D;
wire cal_i_E;
wire ld_D;
wire ld_E;
wire ld_M;
wire jal_E;
wire jal_M;
wire st;
wire beq;
wire jr;


assign beq = ir_D[`Op]==`beq;
assign jr = ir_D[`Op]==`r_format & ir_D[`Func]==`jr;
assign cal_r_D = (ir_D[`Op]==`r_format & ir_D[`Func]==`addu) | (ir_D[`Op]==`r_format & ir_D[`Func]==`subu);
assign cal_i_D = ir_D[`Op]==`ori | ir_D[`Op]==`lui;
assign ld_D = ir_D[`Op]==`lw;
assign st = ir_D[`Op]==`sw;

assign cal_r_E = (ir_E[`Op]==`r_format & ir_E[`Func]==`addu) | (ir_E[`Op]==`r_format & ir_E[`Func]==`subu);
assign cal_i_E = ir_E[`Op]==`ori | ir_E[`Op]==`lui;
assign ld_E = ir_E[`Op]==`lw;
assign jal_E = ir_E[`Op]==`jal;

assign ld_M = ir_M[`Op]==`lw;
assign jal_M = ir_M[`Op]==`jal;

wire stall_b;
wire stall_jr;
wire stall_cal_r;
wire stall_cal_i;
wire stall_ld;
wire stall_st;
wire stall;

assign stall_b = (beq & cal_r_E &(ir_D[`Rs]==ir_E[`Rd] | ir_D[`Rt]==ir_E[`Rd])) |
					  (beq & cal_i_E &(ir_D[`Rs]==ir_E[`Rt] | ir_D[`Rt]==ir_E[`Rt])) |
					  (beq & ld_E &(ir_D[`Rs]==ir_E[`Rt] | ir_D[`Rt]==ir_E[`Rt])) |
					  (beq & ld_M &(ir_D[`Rs]==ir_M[`Rt] | ir_D[`Rt]==ir_M[`Rt]))|
					  (beq & jal_E &(ir_D[`Rs]==5'd31 | ir_D[`Rt]==5'd31))|
					  (beq & jal_M &(ir_D[`Rs]==5'd31 | ir_D[`Rt]==5'd31));
assign stall_jr = (jr & cal_r_E &(ir_D[`Rs]==ir_E[`Rd])) |
						(jr & cal_i_E &(ir_D[`Rs]==ir_E[`Rt])) |
						(jr & ld_E &(ir_D[`Rs]==ir_E[`Rt])) |
						(jr & ld_M &(ir_D[`Rs]==ir_M[`Rt]))|
						(jr & jal_E &(ir_D[`Rs]==5'd31))|
						(jr & jal_M &(ir_D[`Rs]==5'd31));
assign stall_cal_r = (cal_r_D & ld_E & (ir_D[`Rs]==ir_E[`Rt] | ir_D[`Rt]==ir_E[`Rt])) |
							(cal_r_D & jal_E & (ir_D[`Rs]==5'd31 | ir_D[`Rt]==5'd31));
assign stall_cal_i = (cal_i_D & ld_E & ir_D[`Rs]==ir_E[`Rt])|
							(cal_i_D & jal_E & ir_D[`Rs]==5'd31);
assign stall_ld = (ld_D & ld_E &(ir_D[`Rs]==ir_E[`Rt]))|
						(ld_D & jal_E & ir_D[`Rs]==5'd31);
assign stall_st = st & ld_E &(ir_D[`Rs]==ir_E[`Rt])|
						(st & jal_E & ir_D[`Rs]==5'd31);

assign stall = stall_b | stall_jr | stall_cal_r | stall_cal_i | stall_ld | stall_st;

assign pc_en = !stall;
assign d_en = !stall;
assign e_reset = stall;

endmodule //control_S
