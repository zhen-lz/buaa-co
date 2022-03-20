`timescale 1ns / 1ps
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

           output [1:0] mfrsd_c,
           output [1:0] mfrtd_c,
           output [1:0] mfrse_c,
           output [1:0] mfrte_c,
           output mfrtm_c
       );

wire cal_r_M;
wire cal_i_M;
wire md_r_M;
wire cal_r_W;
wire cal_i_W;
wire md_r_W;
wire ld_W;
wire jalr_W;
wire jal_W;


wire rsd;
wire rtd;
wire rse;
wire rte;
wire rtm;

assign cal_r_M = ir_M[`Op]==`r_format & (ir_M[`Func]==`add | ir_M[`Func]== `addu | ir_M[`Func]==`sub | ir_M[`Func]==`subu |
        ir_M[`Func]==`and_ins | ir_M[`Func]==`or_ins | ir_M[`Func]==`xor_ins | ir_M[`Func]==`nor_ins |
        ir_M[`Func]==`sllv | ir_M[`Func]==`srav | ir_M[`Func]==`srlv |
        ir_M[`Func]==`slt | ir_M[`Func]==`sltu |
        ir_M[`Func]==`sll | ir_M[`Func]==`sra | ir_M[`Func]==`srl);
assign cal_i_M = (ir_M[`Op]==`addi | ir_M[`Op]==`addiu | ir_M[`Op]==`ori | ir_M[`Op]==`xori | ir_M[`Op]==`lui | ir_M[`Op]==`slti | ir_M[`Op]==`sltiu);
assign md_r_M = ir_M[`Op]==`r_format & (ir_M[`Func]==`mfhi | ir_M[`Func]==`mflo);

assign cal_r_W = ir_W[`Op]==`r_format & (ir_W[`Func]==`add | ir_W[`Func]== `addu | ir_W[`Func]==`sub | ir_W[`Func]==`subu |
        ir_W[`Func]==`and_ins | ir_W[`Func]==`or_ins | ir_W[`Func]==`xor_ins | ir_W[`Func]==`nor_ins |
        ir_W[`Func]==`sllv | ir_W[`Func]==`srav | ir_W[`Func]==`srlv |
        ir_W[`Func]==`slt | ir_W[`Func]==`sltu |
        ir_W[`Func]==`sll | ir_W[`Func]==`sra | ir_W[`Func]==`srl);
assign cal_i_W = (ir_W[`Op]==`addi | ir_W[`Op]==`addiu | ir_W[`Op]==`ori | ir_W[`Op]==`xori | ir_W[`Op]==`lui | ir_W[`Op]==`slti | ir_W[`Op]==`sltiu);
assign md_r_W = ir_W[`Op]==`r_format & (ir_W[`Func]==`mfhi | ir_W[`Func]==`mflo);
assign ld_W = ir_W[`Op]==`lw;
assign jalr_W = ir_W[`Op]==`jalr;
assign jal_W = ir_W[`Op]==`jal;
//数据供给端

wire b;
wire jr;
wire cal_r_E;
wire cal_i_E;
wire md_E;
wire md_w_E;
wire ld_E;
wire sd_E;
wire sd_M;

assign b = ir_D[`Op]==`beq | ir_D[`Op]==`bne | ir_D[`Op]==`blez | ir_D[`Op]==`bgtz |(ir_D[`Op]==`spc & (ir_D[`Rt]==`bltz | ir_D[`Rt]==`bgez));
assign jr = ir_D[`Op]==`jr | ir_D[`Op]==`jalr;
assign cal_r_E = ir_E[`Op]==`r_format & (ir_E[`Func]==`add | ir_E[`Func]== `addu | ir_E[`Func]==`sub | ir_E[`Func]==`subu |
        ir_E[`Func]==`and_ins | ir_E[`Func]==`or_ins | ir_E[`Func]==`xor_ins | ir_E[`Func]==`nor_ins |
        ir_E[`Func]==`sllv | ir_E[`Func]==`srav | ir_E[`Func]==`srlv |
        ir_E[`Func]==`slt | ir_E[`Func]==`sltu |
        ir_E[`Func]==`sll | ir_E[`Func]==`sra | ir_E[`Func]==`srl);
assign cal_i_E = (ir_E[`Op]==`addi | ir_E[`Op]==`addiu | ir_E[`Op]==`ori | ir_E[`Op]==`xori | ir_E[`Op]==`lui | ir_E[`Op]==`slti | ir_E[`Op]==`sltiu);
assign md_E = ir_E[`Op]==`r_format & (ir_E[`Func]==`mult | ir_E[`Func]==`multu | ir_E[`Func]==`div | ir_E[`Func]==`divu);
assign md_w_E = ir_E[`Op]==`r_format & (ir_E[`Func]==`mthi | ir_E[`Func]==`mtlo);
assign ld_E = ir_E[`Op]==`lb | ir_E[`Op]==`lbu | ir_E[`Op]==`lh | ir_E[`Op]==`lhu | ir_E[`Op]==`lw;
assign sd_E = ir_E[`Op]==`sb | ir_E[`Op]==`sh | ir_E[`Op]==`sw;
assign sd_M = ir_M[`Op]==`sb | ir_M[`Op]==`sh | ir_M[`Op]==`sw;

assign rsd = b | jr;
assign rtd = b;
assign rse = cal_r_E | cal_i_E | md_E | md_w_E | ld_E | sd_E;
assign rte = cal_r_E | md_E | sd_E;
assign rtm = sd_M;
//数据需求端

assign mfrsd_c = rsd & cal_r_M & ir_D[`Rs]==ir_M[`Rd] ? (ir_D[`Rs] == 0 ? 0 : 1) :
       rsd & cal_i_M & ir_D[`Rs]==ir_M[`Rt] ? (ir_D[`Rs] == 0 ? 0 : 1):
       rsd & md_r_M & ir_D[`Rs]==ir_M[`Rd] ? (ir_D[`Rs] == 0 ? 0 : 3):
       rsd & cal_r_W & ir_D[`Rs]==ir_W[`Rd] ? (ir_D[`Rs] == 0 ? 0 : 2):
       rsd & cal_i_W & ir_D[`Rs]==ir_W[`Rt] ? (ir_D[`Rs] == 0 ? 0 : 2):
       rsd & md_r_W & ir_D[`Rs]==ir_W[`Rt] ? (ir_D[`Rs] == 0 ? 0 : 2):
       rsd & ld_W & ir_D[`Rs]==ir_W[`Rt] ? (ir_D[`Rs] == 0 ? 0 : 2):
       rsd & jalr_W & ir_D[`Rs]==ir_W[`Rd] ? (ir_D[`Rs] == 0 ? 0 : 2):
       rsd & jal_W & ir_D[`Rs]==5'd31 ? 2:
       0;
assign mfrtd_c = rtd & cal_r_M & ir_D[`Rt]==ir_M[`Rd] ? (ir_D[`Rt] == 0 ? 0 : 1) :
       rtd & cal_i_M & ir_D[`Rt]==ir_M[`Rt] ? (ir_D[`Rt] == 0 ? 0 : 1):
       rtd & md_r_M & ir_D[`Rt]==ir_M[`Rd] ? (ir_D[`Rt] == 0 ? 0 : 3):
       rtd & cal_r_W & ir_D[`Rt]==ir_W[`Rd] ? (ir_D[`Rt] == 0 ? 0 : 2):
       rtd & cal_i_W & ir_D[`Rt]==ir_W[`Rt] ? (ir_D[`Rt] == 0 ? 0 : 2):
       rtd & md_r_W & ir_D[`Rt]==ir_W[`Rd] ? (ir_D[`Rt] == 0 ? 0 : 2):
       rtd & ld_W & ir_D[`Rt]==ir_W[`Rt] ? (ir_D[`Rt] == 0 ? 0 : 2):
       rtd & jalr_W & ir_D[`Rt]==ir_W[`Rd] ? (ir_D[`Rt] == 0 ? 0 : 2):
       rtd & jal_W & ir_D[`Rt]==5'd31 ? 2:
       0;
assign mfrse_c = rse & cal_r_M & ir_E[`Rs]==ir_M[`Rd] ? (ir_E[`Rs] == 0 ? 0 : 1) :
       rse & cal_i_M & ir_E[`Rs]==ir_M[`Rt] ? (ir_E[`Rs] == 0 ? 0 : 1):
       rse & md_r_M & ir_E[`Rs]==ir_M[`Rd] ? (ir_E[`Rs] == 0 ? 0 : 3):
       rse & cal_r_W & ir_E[`Rs]==ir_W[`Rd] ? (ir_E[`Rs] == 0 ? 0 : 2):
       rse & cal_i_W & ir_E[`Rs]==ir_W[`Rt] ? (ir_E[`Rs] == 0 ? 0 : 2):
       rse & md_r_W & ir_E[`Rs]==ir_W[`Rd] ? (ir_E[`Rs] == 0 ? 0 : 2):
       rse & ld_W & ir_E[`Rs]==ir_W[`Rt] ? (ir_E[`Rs] == 0 ? 0 : 2):
       rse & jalr_W & ir_E[`Rs]==ir_W[`Rd] ? (ir_E[`Rs] == 0 ? 0 : 2):
       rse & jal_W & ir_E[`Rs]==5'd31 ? 2:
       0;
assign mfrte_c = rte & cal_r_M & ir_E[`Rt]==ir_M[`Rd] ? (ir_E[`Rt] == 0 ? 0 : 1):
       rte & cal_i_M & ir_E[`Rt]==ir_M[`Rt] ? (ir_E[`Rt] == 0 ? 0 : 1):
       rte & md_r_M & ir_E[`Rt]==ir_M[`Rd] ? (ir_E[`Rt] == 0 ? 0 : 3):
       rte & cal_r_W & ir_E[`Rt]==ir_W[`Rd] ? (ir_E[`Rt] == 0 ? 0 : 2):
       rte & cal_i_W & ir_E[`Rt]==ir_W[`Rt] ? (ir_E[`Rt] == 0 ? 0 : 2):
       rte & md_r_W & ir_E[`Rt]==ir_W[`Rd] ? (ir_E[`Rt] == 0 ? 0 : 2):
       rte & ld_W & ir_E[`Rt]==ir_W[`Rt] ? (ir_E[`Rt] == 0 ? 0 : 2):
       rte & jalr_W & ir_E[`Rt]==ir_W[`Rd] ? (ir_E[`Rt] == 0 ? 0 : 2):
       rte & jal_W & ir_E[`Rt]==5'd31 ? 2:
       0;

assign mfrtm_c = rtm & cal_r_W & ir_M[`Rt]==ir_W[`Rd] ? (ir_M[`Rt] == 0 ? 0 : 1) :
       rtm & cal_i_W & ir_M[`Rt]==ir_W[`Rt] ? (ir_M[`Rt] == 0 ? 0 : 1):
       rtm & md_r_W & ir_M[`Rt]==ir_W[`Rd] ? (ir_M[`Rt] == 0 ? 0 : 1):
       rtm & ld_W & ir_M[`Rt]==ir_W[`Rt] ? (ir_M[`Rt] == 0 ? 0 : 1):
       rtm & jalr_W & ir_M[`Rt]==ir_W[`Rd] ? (ir_M[`Rt] == 0 ? 0 : 1):
       rtm & jal_W & ir_M[`Rt]==5'd31 ? 1:
       0;

endmodule //control_T
