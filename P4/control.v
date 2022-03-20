/*
 control_alu,
 dm_ReadEn
 dm_WriteEn
 control_ext
 grf_WD
 control_grf_WD
 control_grf_WA
 control_alu_data2
*/
`include "const.v"

module control (
           input [5:0] op,
           input [5:0] func,
           output [3:0] control_alu,
           output [3:0] control_ext,
           output [3:0] control_npc,
           output [3:0] control_grf_WD,
           output [3:0] control_grf_WA,
           output [3:0] control_alu_data2,
           output dm_ReadEn,
           output dm_WriteEn,
           output grf_WD
       );

assign control_alu = op==`ori ? `or_alu:
       op == `lui ? `shift16:
       op == `lw ? `addu_alu:
       op == `sw ? `addu_alu:
       op == `beq ? `equal:
       op == `r_format && func == `addu ? `addu_alu:
       op == `r_format && func == `subu ? `subu_alu:
       4'b0000;

assign control_ext = op==`ori ? `zero_ext:
       op==`lui ? `zero_ext:
       op==`lw ? `sign_ext:
       op==`sw ? `sign_ext:
       4'b0000;

assign control_npc = op==`ori ? `pc4_npc:
       op==`lui ? `pc4_npc:
       op==`lw ? `pc4_npc:
       op==`sw ? `pc4_npc:
       op==`beq ? `beq_npc:
       op==`j ? `j_npc:
       op==`jal ? `jal_npc:
       op==`r_format && func == `addu ? `pc4_npc:
       op==`r_format && func == `subu ? `pc4_npc:
       op==`r_format && func == `jr ? `jr_npc:
       4'b0000;

assign control_grf_WD = op==`ori ? `mux_grf_alu:
       op==`lui ? `mux_grf_alu:
       op==`lw ? `mux_grf_dm:
       op==`jal ? `mux_grf_pc:
       op==`r_format && func == `addu ? `mux_grf_alu:
       op==`r_format && func == `subu ? `mux_grf_alu:
       4'b0000;

assign control_grf_WA = op==`ori ? `mux_grf_rt:
       op==`lui ? `mux_grf_rt:
       op==`lw ? `mux_grf_rt:
       op==`jal ? `mux_grf_pc:
       op==`r_format && func==`addu ? `mux_grf_rd:
       op==`r_format && func==`subu ? `mux_grf_rd:
       4'b0000;

assign control_alu_data2 = op==`ori ? `mux_alu_imme32:
       op==`lui ? `mux_alu_imme32:
       op==`lw ? `mux_alu_imme32:
       op==`sw ? `mux_alu_imme32:
       op==`r_format && func==`addu ? `mux_alu_grf:
       op==`r_format && func==`subu ? `mux_alu_grf:
       4'b0000;

assign dm_ReadEn = op==`lw ? 1 : 0;

assign dm_WriteEn = op==`sw ? 1 : 0;

assign grf_WD = op ==`ori ? 1 :
       op==`lui ? 1:
       op==`lw ? 1:
       op==`jal ? 1:
       op==`r_format && func==`addu ? 1:
       op==`r_format && func==`subu ? 1 : 0;


endmodule //control
