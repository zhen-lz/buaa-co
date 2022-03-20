`include "const.v"

`include "F_mux.v"
`include "F_pc.v"
`include "D.v"
`include "D_ext.v"
`include "D_grf.v"
`include "D_judge.v"
`include "D_mux.v"
`include "D_npc.v"
`include "E.v"
`include "E_alu.v"
`include "E_multdiv.v"
`include "E_mux.v"
`include "M.v"
`include "M_bes.v"
`include "M_exl.v"
`include "M_mux.v"
`include "W.v"
`include "W_mux.v"

`include "control.v"
`include "control_S.v"
`include "control_T.v"



module mips (
           input clk,
           input reset,
           input [31:0] i_inst_rdata,
           input [31:0] m_data_rdata,
           output [31:0] i_inst_addr,
           output [31:0] m_data_addr,
           output [31:0] m_data_wdata,
           output [3:0] m_data_byteen,
           output [31:0] m_inst_addr,
           output w_grf_we,
           output [4:0] w_grf_addr,
           output [31:0] w_grf_wdata,
           output [31:0] w_inst_addr
       );

//wire define
//F
wire [31:0] PC_F,IR_F,M1;
//D
wire [31:0] PC_D,IR_D,RFRD1,RFRD2,MFRSD,MFRTD,NPC,EXT;
//E
wire [31:0] PC_E,IR_E,MFRSE,MFRTE,CONT_E,EXT_E,RFRD1_E,RFRD2_E,AO,HI,LO,M2,M5;
//M
wire [31:0] PC_M,IR_M,CONT_M,MFRTM,AO_M,RT_M,HILO_M,MRD;
//W
wire [31:0] PC_W,IR_W,CONT_W,AO_W,DR_W,HILO_W,M4;
wire [4:0] M3;

//control
wire WE,Sign,Judge,Busy,Start;
wire [1:0] WRSel,WDSel,PCSel;
wire BSel,MDSel;
wire [3:0] JudgeOp,BeOp,ExOp,MDOp;
wire [4:0] ALUOp;

wire PCE,DRE,Reset_E;//停顿
wire [1:0] FRSD,FRTD,FRSE,FRTE;
wire FRTM;//转发
//F级
F_mux F_MUX(
          .pc_F(PC_F),
          .npc(NPC),
          .jrrs(MFRSD),
          .pc_c(PCSel),

          .new_pc(M1)
      );

F_pc F_PC(
         .new_pc(M1),
         .clk(clk),
         .reset(reset),
         .en(PCE),

         .pc_F(PC_F)
     );

assign i_inst_addr = PC_F;
assign IR_F = i_inst_rdata;

//D级
D D(
      .pc_F(PC_F),
      .ir_F(IR_F),
      .clk(clk),
      .reset(reset),
      .en(DRE),

      .pc_D(PC_D),
      .ir_D(IR_D)
  );
D_grf D_GRF(
          .Addr1(IR_D[25:21]),
          .Addr2(IR_D[20:16]),
          .clk(clk),
          .reset(reset),

          .pc(PC_W),
          .Addr3(M3),
          .WD(M4),
          .WE(WE),

          .RD1(RFRD1),
          .RD2(RFRD2)
      );
D_ext D_EXT(
          .imme16(IR_D[15:0]),
          .sign(Sign),

          .imme32 (EXT)
      );
D_judge D_JUDGE(
            .data1(MFRSD),
            .data2(MFRTD),
            .judge_c(JudgeOp),

            .judge(Judge)
        );
D_npc D_NPC(
          .pc_D(PC_D),
          .ir_D(IR_D),
          .judge(Judge),

          .npc(NPC)
      );
D_mux D_MUX(
          .ao_M(AO_M),
          .mgrf(M4),
          .hilo(HILO_M),

          .rfrd1(RFRD1),
          .mfrsd_c(FRSD),
          .rs_D(MFRSD),

          .rfrd2(RFRD2),
          .mfrtd_c(FRTD),
          .rt_D(MFRTD)
      );
control CONTROL_D(
            .ir(IR_D),

            .sign(Sign),
            .judge_c(JudgeOp),
            .m_pc(PCSel)
        );
control_S CONTROL_S_D(
              .ir_D(IR_D),
              .ir_E(IR_E),
              .ir_M(IR_M),
              .busy(Busy),

              .pc_en(PCE),
              .d_en(DRE),
              .e_reset(E_Reset)
          );
control_T CONTROL_T_D(
              .ir_D(IR_D),
              .ir_E(IR_E),
              .ir_M(IR_M),
              .ir_W(IR_W),

              .mfrsd_c(FRSD),
              .mfrtd_c(FRTD)
          );

assign w_grf_we = WE;
assign w_grf_addr = M3;
assign w_grf_wdata = M4;
assign w_inst_addr = PC_W;
//E级
E E(
      .ir_D(IR_D),
      .pc_D(PC_D),
      .ext(EXT),
      .rfrd1(RFRD1),
      .rfrd2(RFRD2),
      .clk(clk),
      .reset(reset | Reset_E),

      .ir_E(IR_E),
      .pc_E(PC_E),
      .ext_E(EXT_E),
      .rfrd1_E(RFRD1_E),
      .rfrd2_E(RFRD2_E),

      .control_D(32'b0),
      .control_E(CONT_E)
  );
E_alu E_ALU(
          .data1(MFRSE),
          .data2(MFRTE),
          .s(IR_E[10:6]),
          .alu_c(ALUOp),

          .result(AO)
      );
E_multdiv E_MULTDIV(
              .data1(MFRSE),
              .data2(MFRTE),
              .start(Start),
              .md_c(MDOp),
              .clk(clk),
              .reset(reset),

              .busy(Busy),
              .HI(HI),
              .LO(LO)
          );
E_mux E_MUX(
          .ao_M(AO_M),
          .mgrf(M4),
          .hilo(HILO_M),

          .rs_E(RFRD1_E),
          .mfrse_c(FRSE),
          .mrs_E(MFRSE),

          .rt_E(RFRD2_E),
          .mfrte_c(FRTE),
          .mrt_E(MFRTE),

          .ext_E(EXT_E),
          .malub_c(BSel),
          .malub(M2),

          .hi(HI),
          .lo(LO),
          .hilo_c(MDSel),
          .mdout(M5)
      );
control CONTROL_E(
            .ir(IR_D),

            .alu_c(ALUOp),
            .md_s(Start),
            .md_c(MDOp),
            .m_md(MDSel),
            .m_alu_b(BSel)
        );
control_T CONTROL_T_E(
              .ir_D(IR_D),
              .ir_E(IR_E),
              .ir_M(IR_M),
              .ir_W(IR_W),

              .mfrse_c(FRSE),
              .mfrte_c(FRTE)
          );


//M级
M M(
      .ir_E(IR_E),
      .pc_E(PC_E),
      .alu(AO),
      .mfrte(MFRTE),
      .hilo(M5),
      .clk(clk),
      .reset(reset),

      .ir_M(IR_M),
      .pc_M(PC_M),
      .ao_M(AO_M),
      .rt_M(RT_M),
      .hilo_M(HILO_M),

      .control_E(CONT_E),
      .control_M(CONT_M)
  );
M_bes M_BES(
          .a(AO_M[1:0]),
          .bes_c(BeOp),

          .byteen(m_data_byteen)
      );
M_exl M_EXL(
          .a(AO_M[1:0]),
          .din(m_data_rdata),
          .exl_c(ExOp),

          .dout(MRD)
      );
M_mux M_MUX(
          .rt_M(RT_M),
          .mgrf(M4),
          .mfrtm_c(FRTM),
          .mrt_M(MFRTM)
      );
control CONTROL_M(
            .ir(IR_D),

            .bes_c(BeOp),
            .exl_c(ExOp)
        );
control_T CONTROL_T_M(
              .ir_D(IR_D),
              .ir_E(IR_E),
              .ir_M(IR_M),
              .ir_W(IR_W),

              .mfrtm_c(FRTM)
          );

assign m_data_addr = MFRTM;
assign m_data_wdata = RT_M;
assign m_inst_addr = PC_M;

//W级
W W(
      .ir_M(IR_M),
      .pc_M(PC_M),
      .ao_M(AO_M),
      .dm(MRD),
      .hilo_M(HILO_M),
      .clk(clk),
      .reset(reset),

      .ir_W(IR_W),
      .pc_W(PC_W),
      .ao_W(AO_W),
      .dr_W(DR_W),
      .hilo_W(HILO_W),

      .control_M(CONT_M),
      .control_W(CONT_W)
  );
W_mux W_MUX(
          .ir_W(IR_W),
          .ma3_c(WDSel),
          .ma3(M3),

          .dr_W(DR_W),
          .ao_W(AO_W),
          .pc_W(PC_W),
          .hilo_W(HILO_W),
          .mWD_c(WRSel),
          .mWD(M4)
      );
control CONTROL_W(
            .ir(IR_D),

            .WE(WE),
            .m_a3(WDSel),
            .m_WD(WRSel)
        );


endmodule //mips
