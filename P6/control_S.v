`timescale 1ns / 1ps
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
           input busy,
           output pc_en,
           output d_en,
           output e_reset
       );
//需求
wire b;
wire jr;
wire cal_r_D;
wire cal_i_D;
wire md;
wire md_w;
wire ld_D;
wire sd;
//供给
wire cal_r_E;
wire cal_i_E;
wire md_r;
wire jal_E;
wire jalr_E;
wire ld_E;

wire jal_M;
wire jalr_M;
wire ld_M;

assign b = ir_D[`Op]==`beq | ir_D[`Op]==`bne | ir_D[`Op]==`blez | ir_D[`Op]==`bgtz |(ir_D[`Op]==`spc & (ir_D[`Rt]==`bltz | ir_D[`Rt]==`bgez));
assign jr = ir_D[`Op]==`jr | ir_D[`Op]==`jalr;
assign cal_r_D = ir_D[`Op]==`r_format & (ir_D[`Func]==`add | ir_D[`Func]== `addu | ir_D[`Func]==`sub | ir_D[`Func]==`subu |
        ir_D[`Func]==`and_ins | ir_D[`Func]==`or_ins | ir_D[`Func]==`xor_ins | ir_D[`Func]==`nor_ins |
        ir_D[`Func]==`sllv | ir_D[`Func]==`srav | ir_D[`Func]==`srlv |
        ir_D[`Func]==`slt | ir_D[`Func]==`sltu |
        ir_D[`Func]==`sll | ir_D[`Func]==`sra | ir_D[`Func]==`srl);
assign cal_i_D = (ir_D[`Op]==`addi | ir_D[`Op]==`addiu | ir_D[`Op]==`ori | ir_D[`Op]==`xori | ir_D[`Op]==`lui | ir_D[`Op]==`slti | ir_D[`Op]==`sltiu);
assign md = ir_D[`Op]==`r_format & (ir_D[`Func]==`mult | ir_D[`Func]==`multu | ir_D[`Func]==`div | ir_D[`Func]==`divu);
assign md_w = ir_D[`Op]==`r_format & (ir_D[`Func]==`mthi | ir_D[`Func]==`mtlo);
assign ld_D = ir_D[`Op]==`lb | ir_D[`Op]==`lbu | ir_D[`Op]==`lh | ir_D[`Op]==`lhu | ir_D[`Op]==`lw;
assign sd = ir_D[`Op]==`sb | ir_D[`Op]==`sh | ir_D[`Op]==`sw;

assign cal_r_E = ir_E[`Op]==`r_format & (ir_E[`Func]==`add | ir_E[`Func]== `addu | ir_E[`Func]==`sub | ir_E[`Func]==`subu |
        ir_E[`Func]==`and_ins | ir_E[`Func]==`or_ins | ir_E[`Func]==`xor_ins | ir_E[`Func]==`nor_ins |
        ir_E[`Func]==`sllv | ir_E[`Func]==`srav | ir_E[`Func]==`srlv |
        ir_E[`Func]==`slt | ir_E[`Func]==`sltu |
        ir_E[`Func]==`sll | ir_E[`Func]==`sra | ir_E[`Func]==`srl);
assign cal_i_E = (ir_E[`Op]==`addi | ir_E[`Op]==`addiu | ir_E[`Op]==`ori | ir_E[`Op]==`xori | ir_E[`Op]==`lui | ir_E[`Op]==`slti | ir_E[`Op]==`sltiu);
assign md_r =  ir_E[`Op]==`r_format & (ir_E[`Func]==`mfhi | ir_E[`Func]==`mflo);
assign jal_E = ir_E[`Op]==`jal;
assign jalr_E = ir_E[`Op]==`jalr;
assign ld_E = ir_E[`Op]==`lb | ir_E[`Op]==`lbu | ir_E[`Op]==`lh | ir_E[`Op]==`lhu | ir_E[`Op]==`lw;

assign jal_M = ir_M[`Op]==`jal;
assign jalr_M = ir_M[`Op]==`jalr;
assign ld_M = ir_M[`Op]==`lb | ir_M[`Op]==`lbu | ir_M[`Op]==`lh | ir_M[`Op]==`lhu | ir_M[`Op]==`lw;

wire stall_b;
wire stall_jr;
wire stall_cal_r;
wire stall_cal_i;
wire stall_ld;
wire stall_sd;
wire stall_md;
wire stall_md_w;
wire stall_md_b;
wire stall;

assign stall_b = (b & cal_r_E &(ir_D[`Rs]==ir_E[`Rd] | ir_D[`Rt]==ir_E[`Rd])) |
       (b & cal_i_E &(ir_D[`Rs]==ir_E[`Rt] | ir_D[`Rt]==ir_E[`Rt])) |
       (b & md_r &(ir_D[`Rs]==ir_E[`Rd] | ir_D[`Rt]==ir_E[`Rd])) |
       (b & ld_E &(ir_D[`Rs]==ir_E[`Rt] | ir_D[`Rt]==ir_E[`Rt])) |
       (b & ld_M &(ir_D[`Rs]==ir_M[`Rt] | ir_D[`Rt]==ir_M[`Rt])) |
       (b & jalr_E &(ir_D[`Rs]==ir_E[`Rd] | ir_D[`Rt]==ir_E[`Rd])) |
       (b & jalr_M &(ir_D[`Rs]==ir_M[`Rd] | ir_D[`Rt]==ir_M[`Rd])) |
       (b & jal_E &(ir_D[`Rs]==5'd31 | ir_D[`Rt]==5'd31)) |
       (b & jal_M &(ir_D[`Rs]==5'd31 | ir_D[`Rt]==5'd31));

assign stall_jr = (jr & cal_r_E &(ir_D[`Rs]==ir_E[`Rd])) |
       (jr & cal_i_E &(ir_D[`Rs]==ir_E[`Rt])) |
       (jr & md_r &(ir_D[`Rs]==ir_E[`Rd])) |
       (jr & ld_E &(ir_D[`Rs]==ir_E[`Rt])) |
       (jr & ld_M &(ir_D[`Rs]==ir_M[`Rt])) |
       (jr & jalr_E &(ir_D[`Rs]==ir_E[`Rd])) |
       (jr & jalr_M &(ir_D[`Rs]==ir_M[`Rd])) |
       (jr & jal_E &(ir_D[`Rs]==5'd31)) |
       (jr & jal_M &(ir_D[`Rs]==5'd31));

assign stall_cal_r = (cal_r_D & ld_E & (ir_D[`Rs]==ir_E[`Rt] | ir_D[`Rt]==ir_E[`Rt])) |
       (cal_r_D & jalr_E & (ir_D[`Rs]==ir_E[`Rd] | ir_D[`Rt]==ir_E[`Rd])) |
       (cal_r_D & jal_E & (ir_D[`Rs]==5'd31 | ir_D[`Rt]==5'd31));

assign stall_cal_i = (cal_i_D & ld_E & ir_D[`Rs]==ir_E[`Rt]) |
       (cal_i_D & jalr_E & ir_D[`Rs]==ir_E[`Rd]) |
       (cal_i_D & jal_E & ir_D[`Rs]==5'd31);

assign stall_ld = (ld_D & ld_E &(ir_D[`Rs]==ir_E[`Rt])) |
       (ld_D & jalr_E & ir_D[`Rs]==ir_E[`Rd]) |
       (ld_D & jal_E & ir_D[`Rs]==5'd31);

assign stall_sd = sd & ld_E &(ir_D[`Rs]==ir_E[`Rt]) |
       (sd & jalr_E & ir_D[`Rs]==ir_E[`Rd]) |
       (sd & jal_E & ir_D[`Rs]==5'd31);

assign stall_md = (md & ld_E & (ir_D[`Rs]==ir_E[`Rt] | ir_D[`Rt]==ir_E[`Rt])) |
       (md & jalr_E & (ir_D[`Rs]==ir_E[`Rd] | ir_D[`Rt]==ir_E[`Rd])) |
       (md & jal_E & (ir_D[`Rs]==5'd31 | ir_D[`Rt]==5'd31));

assign stall_md_w = (md_w & ld_E & ir_D[`Rs]==ir_E[`Rt]) |
       (md_w & jalr_E & ir_D[`Rs]==ir_E[`Rd]) |
       (md_w & jal_E & ir_D[`Rs]==5'd31);

assign stall_md_b = md & busy;

assign stall = stall_b | stall_jr | stall_cal_r | stall_cal_i | stall_ld | stall_sd |stall_md | stall_md_w | stall_md_b;

assign pc_en = !stall;
assign d_en = !stall;
assign e_reset = stall;

endmodule //control_S

          /*
          wire ld;
          wire sd;
          wire b;
          wire j;
          wire jr;
          wire md;
          wire md_rw;
           
          assign cal_r = ir[`Op]==`r_format & (ir[`Func]==`add | ir[`Func]== `addu | ir[`Func]==`sub | ir[`Func]==`subu |
                                               ir[`Func]==`and_ins | ir[`Func]==`or_ins | ir[`Func]==`xor_ins | ir[`Func]==`nor_ins |
                                               ir[`Func]==`sllv | ir[`Func]==`srav | ir[`Func]==`srlv |
                                               ir[`Func]==`slt | ir[`Func]==`sltu |
                                               ir[`Func]==`sll | ir[`Func]==`sra | ir[`Func]==`srl);
           
          assign cal_i = (ir[`Op]==`addi | ir[`Op]==`addiu | ir[`Op]==`ori | ir[`Op]==`xori | ir[`Op]==`lui | ir[`Op]==`slti | ir[`Op]==`sltiu);
           
          assign ld = ir[`Op]==`lb | ir[`Op]==`lbu | ir[`Op]==`lh | ir[`Op]==`lhu | ir[`Op]==`lw;
           
          assign sd = ir[`Op]==`sb | ir[`Op]==`sh | ir[`Op]==`sw;
           
          assign b = ir[`Op]==`beq | ir[`Op]==`bne | ir[`Op]==`blez | ir[`Op]==`bgtz |(ir[`Op]==`spc & (ir[`Rt]==`bltz | ir[`Rt]==`bgez));
           
          assign j = ir[`Op]==`j | ir[`Op]==`jal;
           
          assign jr = ir[`Op]==`jr | ir[`Op]==`jalr;
           
          assign md = ir[`Op]==`r_format & (ir[`Func]==`mult | ir[`Func]==`multu | ir[`Func]==`div | ir[`Func]==`divu);
           
          assign md_rw = ir[`Op]==`r_format & (ir[`Func]==`mfhi | ir[`Func]==`mflo | ir[`Func]==`mthi | ir[`Func]==`mtlo);
          */
