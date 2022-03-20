`include "const.v"

module mips (
           input clk,
           input reset
       );

//wire F级
wire [31:0] M1,NPC,PC4,IR_F;
//wire D级
wire [31:0] PC4_D,IR_D;
wire [31:0] GRD2,GRD1,MFRSD,MFRTD,Ext;

//wire E级
wire [31:0] EXT_E,GRD1_E,GRD2_E,PC4_E,IR_E;
wire [31:0] MFRSE,MFRTE,AO,M2;
//wire M级
wire [31:0] IR_M,AO_M,PC4_M,RT_M;
wire [31:0] MFRTM,MRD;
//wire W级
wire [31:0] IR_W,PC4_W,AO_W,DR_W;
wire [31:0] M4;
wire [4:0] M3;
//wire else
wire [1:0] WRSel,WDSel,PCSel;
wire BSel;
wire [3:0] ALUOp;
wire WE,MRE,MWE,Sign,Equal;

wire PCE,DRE,Reset_E; //停顿
wire [1:0] FRSD,FRTD,FRTE,FRSE;
wire FRTM; //转发


F_mux F_MUX(
          .pc4(PC4),
          .npc(NPC),
          .rfrd1(MFRSD),
          .mpc_c(PCSel),
          .new_pc(M1)
      );
F_ifu F_IFU(
          .new_pc(M1),
          .clk(clk),
          .reset(reset),
          .pc_en(PCE),
          .im(IR_F),
          .pc4(PC4)
      );
//模块实例化 IF/ID
D D_R(
      .im(IR_F),
      .pc4(PC4),
      .clk(clk),
      .reset(reset),
      .d_en(DRE),

      .ir_D(IR_D),
      .pc4_D(PC4_D)
  );
D_grf D_GRF(
          .Addr1(IR_D[25:21]),
          .Addr2(IR_D[20:16]),
          .ir_D(IR_D),
          .pc(PC4_W-4),
          .clk(clk),
          .reset(reset),
          .RD1(GRD1),
          .RD2(GRD2),

          .Addr3(M3),
          .WD(M4),
          .WE(WE)
      );
D_ext D_EXT(
          .imme16(IR_D[15:0]),
          .sign(Sign),
          .imme32(Ext)
      );
D_npc D_NPC(
          .pc4_D(PC4_D),
          .ir_D(IR_D),
          .npc(NPC)
      );
D_judge D_JUDGE(
            .mrd1(MFRSD),
            .mrd2(MFRTD),
            .equal(Equal)
        );
D_mux D_MUX(
          .ao_M(AO_M),
          .mgrf(M4),

          .rfrd1(GRD1),
          .mfrsd_c(FRSD),
          .mrs_D(MFRSD),

          .rfrd2(GRD2),
          .mfrtd_c(FRTD),
          .mrt_D(MFRTD)
      );
control Control_D(
            .ir(IR_D),
            .equal(Equal),

            .sign(Sign),
            .m_pc(PCSel)
        );
control_S Control_S(
              .ir_D(IR_D),
              .ir_E(IR_E),
              .ir_M(IR_M),
              .pc_en(PCE),
              .d_en(DRE),
              .e_reset(Reset_E)
          );
control_T Control_T_D(
              .ir_D(IR_D),
              .ir_E(IR_E),
              .ir_M(IR_M),
              .ir_W(IR_W),
              .mfrsd(FRSD),
              .mfrtd(FRTD)
          );
//模块实例化 ID/EX
E E_R(
      .ir_D(IR_D),
      .pc4_D(PC4_D),
      .ext(Ext),
      .rfrd1(GRD1),
      .rfrd2(GRD2),
      .clk(clk),
      .reset(Reset_E | reset),
      .ext_E(EXT_E),
      .rfrd1_E(GRD1_E),
      .rfrd2_E(GRD2_E),
      .pc4_E(PC4_E),
      .ir_E(IR_E)
  );
E_alu E_ALU(
          .data1(MFRSE),
          .data2(M2),
          .alu_c(ALUOp),
          .result(AO)
      );
E_mux E_MUX(
          .ao_M(AO_M),
          .mgrf(M4),
          .rs_E(GRD1_E),
          .mfrse_c(FRSE),
          .mrs_E(MFRSE),

          .rt_E(GRD2_E),
          .mfrte_c(FRTE),
          .mrt_E(MFRTE),

          .ext_E(EXT_E),
          .malub_c(BSel),
          .malub(M2)
      );
control Control_E(
            .ir(IR_E),
            .equal(1'b0), //无效

            .alu(ALUOp),
            .m_alu_b(BSel)
        );
control_T Control_T_E(
              .ir_D(IR_D),
              .ir_E(IR_E),
              .ir_M(IR_M),
              .ir_W(IR_W),
              .mfrse(FRSE),
              .mfrte(FRTE)
          );
//模块实例化 EX/MEM
M M_R(
      .ir_E(IR_E),
      .pc4_E(PC4_E),
      .alu(AO),
      .mfrte(MFRTE),
      .clk(clk),
      .reset(reset),
      .ir_M(IR_M),
      .pc4_M(PC4_M),
      .ao_M(AO_M),
      .rt_M(RT_M)
  );
M_dm M_DM(
         .addr(AO_M),
         .WD(MFRTM),
         .ir_M(IR_M),
         .pc(PC4_M-4),
         .r_en(MRE),
         .w_en(MWE),
         .clk(clk),
         .reset(reset),
         .RD(MRD)
     );
M_mux M_MUX(
          .rt_M(RT_M),
          .mgrf(M4),
          .mfrtm_c(FRTM),
          .mrt_M(MFRTM)
      );
control Control_M(
            .ir(IR_M),
            .equal(1'b0), //无效

            .r_en(MRE),
            .w_en(MWE)
        );
control_T Control_T_M(
              .ir_D(IR_D),
              .ir_E(IR_E),
              .ir_M(IR_M),
              .ir_W(IR_W),
              .mfrtm(FRTM)
          );
//模块实例化 MEM/WB
W W_R(
      .ir_M(IR_M),
      .pc4_M(PC4_M),
      .ao_M(AO_M),
      .dm(MRD),
      .clk(clk),
      .reset(reset),
      .ir_W(IR_W),
      .pc4_W(PC4_W),
      .ao_W(AO_W),
      .dr_W(DR_W)
  );
W_mux W_MUX(
          .ir_W(IR_W),
          .ma3_c(WRSel),
          .ma3(M3),

          .dr_W(DR_W),
          .ao_W(AO_W),
          .pc4_W(PC4_W),
          .mWD_c(WDSel),
          .mWD(M4)
      );
control Control_W(
            .ir(IR_W),
            .equal(1'b0),

            .WE(WE),
            .m_a3(WRSel),
            .m_WD(WDSel)
        );

endmodule //mips
