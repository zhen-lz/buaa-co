`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:44:16 11/30/2021 
// Design Name: 
// Module Name:    control 
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

module control (
           input [31:0] ir,
           input equal,

           output reg sign,
           output reg WE,
           output reg r_en,
           output reg w_en,
           output reg [3:0] alu,
           output reg [1:0] m_pc,
           output reg m_alu_b,
           output reg [1:0] m_a3,
           output reg [1:0] m_WD

       );

always @* begin
    case (ir[31:26])
        `lui: begin
            sign = 1;
            WE = 1;
            r_en = 0;
            w_en = 0;
            alu = `lui_a;
            m_pc = `PC4;
            m_alu_b = 1;
            m_a3 = `Art;
            m_WD = `AO_W;
        end
        `ori: begin
            sign = 0;
            WE = 1;
            r_en = 0;
            w_en = 0;
            alu = `or_a;
            m_pc = `PC4;
            m_alu_b = 1;
            m_a3 = `Art;
            m_WD = `AO_W;
        end
        `lw: begin
            sign = 1;
            WE = 1;
            r_en = 1;
            w_en = 0;
            alu = `addu_a;
            m_pc = `PC4;
            m_alu_b = 1;
            m_a3 = `Art;
            m_WD = `DR_W;
        end
        `sw: begin
            sign = 1;
            WE = 0;
            r_en = 0;
            w_en = 1;
            alu = `addu_a;
            m_pc = `PC4;
            m_alu_b = 1;
            m_a3 = `Art;
            m_WD = `DR_W;
        end
        `beq: begin
            sign = 0;
            WE = 0;
            r_en = 0;
            w_en = 0;
            alu = `addu_a;
            m_pc = equal ? `NPC : `PC4;
            m_alu_b = 0;
            m_a3 = `Art;
            m_WD = `DR_W;
        end
        `j: begin
            sign = 0;
            WE = 0;
            r_en = 0;
            w_en = 0;
            alu = `addu_a;
            m_pc = `NPC;
            m_alu_b = 0;
            m_a3 = `Art;
            m_WD = `DR_W;
        end
        `jal: begin
            sign = 0;
            WE = 1;
            r_en = 0;
            w_en = 0;
            alu = `addu_a;
            m_pc = `NPC;
            m_alu_b = 0;
            m_a3 = `A31;
            m_WD = `PC4_W;
        end
        `r_format : begin
            case (ir[5:0])
                `addu: begin
                    sign = 0;
                    WE = 1;
                    r_en = 0;
                    w_en = 0;
                    alu = `addu_a;
                    m_pc = `PC4;
                    m_alu_b = 0;
                    m_a3 = `Ard;
                    m_WD = `AO_W;
                end
                `subu: begin
                    sign = 0;
                    WE = 1;
                    r_en = 0;
                    w_en = 0;
                    alu = `subu_a;
                    m_pc = `PC4;
                    m_alu_b = 0;
                    m_a3 = `Ard;
                    m_WD = `AO_W;
                end
                `jr: begin
                    sign = 0;
                    WE = 0;
                    r_en = 0;
                    w_en = 0;
                    alu = `addu_a;
                    m_pc = `RFRD1;
                    m_alu_b = 0;
                    m_a3 = `Art;
                    m_WD = `DR_W;
                end
                default: begin
                    sign = 0;
                    WE = 0;
                    r_en = 0;
                    w_en = 0;
                    alu = `addu_a;
                    m_pc = `PC4;
                    m_alu_b = 0;
                    m_a3 = `Art;
                    m_WD = `DR_W;
                end
            endcase
        end
        default: begin
            sign = 0;
            WE = 0;
            r_en = 0;
            w_en = 0;
            alu = `addu_a;
            m_pc = `PC4;
            m_alu_b = 0;
            m_a3 = `Art;
            m_WD = `DR_W;
        end
    endcase
end

endmodule //control
