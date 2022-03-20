`timescale 1ns / 1ps
`include "const.v"
`define Op 31:26
`define Func 25:21
`define Rt 20:16

module control (
           input [31:0] ir,

           output reg sign,
           output reg WE,
           output reg [3:0] bes_c,
           output reg [3:0] exl_c,
           output reg [3:0] judge_c,
           output reg [4:0] alu_c,
           output reg md_s,
           output reg [3:0] md_c,
           output reg m_md,
           output reg [1:0] m_pc,
           output reg m_alu_b,
           output reg [1:0] m_a3,
           output reg [1:0] m_WD
       );

wire cal_r;
wire cal_i;
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

always @* begin
    case ({cal_r,cal_i,ld,sd,b,j,jr,md,md_rw})
        9'b100000000: begin
            sign = 0;
            WE = 1;
            bes_c = `nos;
            exl_c = `lw_c;
            judge_c=`beq_j;
            md_s=0;
            md_c=`multu_a;
            m_md=0;
            m_pc = `PC4;
            m_alu_b = 0;
            m_a3 = `Ard;
            m_WD = `AO_W;
            case (ir[`Func])
                `add:
                    alu_c=`add_a;
                `addu:
                    alu_c=`addu_a;
                `sub:
                    alu_c=`sub_a;
                `subu:
                    alu_c=`subu_a;
                `and_ins:
                    alu_c=`and_a;
                `or_ins:
                    alu_c=`or_a;
                `xor_ins:
                    alu_c=`xor_a;
                `nor_ins:
                    alu_c=`nor_a;
                `sllv:
                    alu_c=`sllv_a;
                `srav:
                    alu_c=`srav_a;
                `srlv:
                    alu_c=`srlv_a;
                `slt:
                    alu_c=`slt_a;
                `sltu:
                    alu_c=`sltu_a;
                `sll:
                    alu_c=`sll_a;
                `sra:
                    alu_c=`sra_a;
                `srl:
                    alu_c=`srl_a;
                default:
                    alu_c=`addu_a;
            endcase
        end
        9'b010000000: begin
            WE = 1;
            bes_c = `nos;
            exl_c = `lw_c;
            judge_c=`beq_j;
            md_s=0;
            md_c=`multu_a;
            m_md=0;
            m_pc = `PC4;
            m_alu_b = 1;
            m_a3 = `Art;
            m_WD = `AO_W;
            case (ir[`Op])
                `addi: begin
                    sign=1;
                    alu_c=`add_a;
                end
                `addiu: begin
                    sign=1;
                    alu_c=`addu_a;
                end
                `ori: begin
                    sign=0;
                    alu_c=`or_a;
                end
                `xori: begin
                    sign=0;
                    alu_c=`xor_a;
                end
                `lui: begin
                    sign=0;
                    alu_c=`lui_a;
                end
                `slti: begin
                    sign=1;
                    alu_c=`slt_a;
                end
                `sltiu: begin
                    sign=1;
                    alu_c=`sltu_a;
                end
                default: begin
                    sign=0;
                    alu_c=`addu_a;
                end
            endcase
        end
        9'b001000000: begin
            sign=1;
            WE=1;
            bes_c = `nos;
            judge_c=`beq_j;
            alu_c=`addu_a;
            md_s=0;
            md_c=`multu_a;
            m_md=0;
            m_pc=`PC4;
            m_alu_b=1;
            m_a3= `Art;
            m_WD=`DR_W;
            case (ir[`Op])
                `lb:
                    exl_c=`lb_c;
                `lbu:
                    exl_c=`lbu_c;
                `lh:
                    exl_c=`lh_c;
                `lhu:
                    exl_c=`lhu_c;
                `lw:
                    exl_c=`lw_c;
                default:
                    exl_c=`lw_c;
            endcase
        end
        9'b000100000: begin
            sign = 1;
            WE = 0;
            exl_c=`lw_c;
            judge_c=`beq_j;
            alu_c=`addu_a;
            md_s=0;
            md_c=`multu_a;
            m_md=0;
            m_pc=`PC4;
            m_alu_b=1;
            m_a3= `Art;
            m_WD=`DR_W;
            case (ir[`Op])
                `sb:
                    bes_c = `sb_c;
                `sh:
                    bes_c = `sh_c;
                `sw:
                    bes_c = `sw_c;
                default:
                    bes_c = `nos;
            endcase
        end
        9'b000010000: begin
            sign = 0;
            WE = 0;
            bes_c=`nos;
            exl_c=`lw_c;
            alu_c=`addu_a;
            md_s=0;
            md_c=`multu_a;
            m_md=0;
            m_pc=`NPC;
            m_alu_b=0;
            m_a3= `Art;
            m_WD=`DR_W;
            case (ir[`Op])
                `beq:
                    judge_c=`beq_j;
                `bne:
                    judge_c=`bne_j;
                `blez:
                    judge_c=`blez_j;
                `bgtz:
                    judge_c=`bgtz_j;
                `spc: begin
                    case (ir[`Rt])
                        `bltz:
                            judge_c=`bltz_j;
                        `bgez:
                            judge_c=`bgez_j;
                        default:
                            judge_c=`beq_j;
                    endcase
                end
                default:
                    judge_c=`beq_j;
            endcase
        end
        9'b000001000: begin
            sign = 0;
            bes_c=`nos;
            exl_c=`lw_c;
            judge_c=`beq_j;
            alu_c=`addu_a;
            md_s=0;
            md_c=`multu_a;
            m_md=0;
            m_pc=`NPC;
            m_alu_b=0;

            case (ir[`Op])
                `j: begin
                    WE = 0;
                    m_a3= `Art;
                    m_WD=`DR_W;
                end
                `jal: begin
                    WE = 1;
                    m_a3= `A31;
                    m_WD=`PC_W;
                end
                default: begin
                    WE = 0;
                    m_a3= `Art;
                    m_WD=`DR_W;
                end
            endcase
        end
        9'b000000100: begin
            sign = 0;
            bes_c=`nos;
            exl_c=`lw_c;
            judge_c=`beq_j;
            alu_c=`addu_a;
            md_s=0;
            md_c=`multu_a;
            m_md=0;
            m_pc=`JRRS;
            m_alu_b=0;
            case (ir[`Func])
                `jr: begin
                    WE = 0;
                    m_a3= `Art;
                    m_WD=`DR_W;
                end
                `jalr: begin
                    WE = 1;
                    m_a3= `Ard;
                    m_WD=`PC_W;
                end
                default: begin
                    WE = 0;
                    m_a3= `Art;
                    m_WD=`DR_W;
                end
            endcase
        end
        9'b000000010: begin
            sign = 0;
            WE = 0;
            bes_c=`nos;
            exl_c=`lw_c;
            judge_c=`beq_j;
            alu_c=`addu_a;
            md_s=1;
            m_md=0;
            m_pc=`PC4;
            m_alu_b=0;
            m_a3= `Art;
            m_WD=`DR_W;
            case (ir[`Func])
                `multu:
                    md_c=`multu_a;
                `mult:
                    md_c=`mult_a;
                `divu:
                    md_c=`divu_a;
                `div:
                    md_c=`div_a;
                default:
                    md_c=`multu_a;
            endcase
        end
        9'b000000001: begin
            sign = 0;
            bes_c=`nos;
            exl_c=`lw_c;
            judge_c=`beq_j;
            alu_c=`addu_a;
            md_s=0;
            m_pc=`PC4;
            m_alu_b=0;
            case (ir[`Func])
                `mfhi: begin
                    WE = 1;
                    md_c=`multu_a;
                    m_md=0;
                    m_a3= `Ard;
                    m_WD=`HILO_W;
                end
                `mflo: begin
                    WE = 1;
                    md_c=`multu_a;
                    m_md=1;
                    m_a3= `Ard;
                    m_WD=`HILO_W;
                end
                `mthi: begin
                    WE = 0;
                    md_c=`mthi_a;
                    m_md=0;
                    m_a3= `Art;
                    m_WD=`DR_W;
                end
                `mtlo: begin
                    WE = 1;
                    md_c=`mtlo_a;
                    m_md=0;
                    m_a3= `Art;
                    m_WD=`DR_W;
                end
                default: begin
                    WE = 0;
                    md_c=`multu_a;
                    m_md=0;
                    m_a3= `Art;
                    m_WD=`DR_W;
                end
            endcase
        end
    endcase
end

endmodule //control
