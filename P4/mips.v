`include "ifu.v"
`include "npc.v"
`include "grf.v"
`include "alu.v"
`include "dm.v"
`include "mux.v"
`include "ext.v"
`include "control.v"


module mips(
           input clk,
           input reset
       );

wire [31:0] npc,pc;
wire [31:0] imme32;
wire [5:0] op,func;
wire [4:0] rs, rt, rd,shamt;
wire [15:0] imme16;
wire [25:0] addr;

wire [3:0] control_alu,control_ext,control_npc,control_grf_WD,control_grf_WA, control_alu_data2;
wire control_dm_ReadEn,  control_dm_WriteEn, control_grf_WDEn;

wire [31:0] grf_RD1,grf_RD2;
wire [31:0] alu_result;
wire alu_judge;

wire [31:0] dm_ReadData;
wire [31:0] ext_imme32;

wire [31:0] mux_WriteData;
wire [4:0] mux_WriteAddr;
wire [31:0] mux_data2;

ifu IFU(.npc (npc),
        .clk (clk),
        .reset (reset),

        .pc (pc),
        .op (op),
        .func (func),
        .rs (rs),
        .rt (rt),
        .rd (rd),
        .shamt (shamt),
        .imme16 (imme16),
        .addr (addr));

control CONT(
            .op(op),
            .func(func),

            .control_alu(control_alu),
            .control_ext(control_ext),
            .control_npc(control_npc),
            .control_grf_WD(control_grf_WD),
            .control_grf_WA(control_grf_WA),
            .control_alu_data2(control_alu_data2),
            .dm_ReadEn(control_dm_ReadEn),
            .dm_WriteEn(control_dm_WriteEn),
            .grf_WD (control_grf_WDEn)
        );



grf GRF(
        .DataAddr1 (rs),
        .DataAddr2 (rt),
        .DataWriteAddr (mux_WriteAddr),
        .DataWrite (mux_WriteData),
        .pc (pc),
        .clk (clk),
        .reset (reset),
        .WD (control_grf_WDEn),

        .DataRead1 (grf_RD1),
        .DataRead2 (grf_RD2)
    );

alu ALU(
        .data1 (grf_RD1),
        .data2 (mux_data2),
        .control_alu (control_alu),

        .result (alu_result),
        .judge (alu_judge)
    );

dm DM(
       .ReadAddr (alu_result),
       .WriteAddr (alu_result),
       .WriteData (grf_RD2),
       .pc (pc),
       .ReadEn (control_dm_ReadEn),
       .WriteEn (control_dm_WriteEn),
       .clk(clk),
       .reset (reset),

       .ReadData (dm_ReadData)
   );

ext EXT(
        .imme16 (imme16),
        .control_ext (control_ext),

        .imme32 (ext_imme32)
    );

npc NPC(
        .pc(pc),
        .control_npc (control_npc),
        .alu_judge (alu_judge),
        .addr (addr),
        .grf_data1 (grf_RD1),
        .imme16 (imme16),

        .npc (npc)
    );

mux MUX(
        .alu_result (alu_result),
        .pc (pc),
        .dm_data (dm_ReadData),
        .rt (rt),
        .rd (rd),
        .control_grf_WD (control_grf_WD),
        .control_grf_WA (control_grf_WA),

        .WriteData (mux_WriteData),
        .WriteAddr (mux_WriteAddr),

        .grf_data2 (grf_RD2),
        .imme32 (ext_imme32),
        .control_alu_data2 (control_alu_data2),

        .data2 (mux_data2)
    );


endmodule
