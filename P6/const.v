`timescale 1ns / 1ps

//global
`define zero 32'b0
//指令
`define lb 6'b100000
`define lbu 6'b100100
`define lh 6'b100001
`define lhu 6'b100101
`define lw 6'b100011

`define sb 6'b101000
`define sh 6'b101001
`define sw 6'b101011

`define addi 6'b001000
`define addiu 6'b001001
`define ori 6'b001101
`define xori 6'b001110
`define lui 6'b001111
`define slti 6'b001010
`define sltiu 6'b001011

`define beq 6'b000100
`define bne 6'b000101
`define blez 6'b000110
`define bgtz 6'b000111

`define j 6'b000010
`define jal 6'b000011
//spcial
`define spc 6'b000001
`define bltz 5'b00000
`define bgez 5'b00001
//R-format
`define r_format 6'b0
`define add 6'b100000
`define addu 6'b100001
`define sub 6'b100010
`define subu 6'b100011
`define and_ins 6'b100100
`define or_ins 6'b100101
`define xor_ins 6'b100110
`define nor_ins 6'b100111
`define sllv 6'b000100
`define srav 6'b000111
`define srlv 6'b000110
`define slt 6'b101010
`define sltu 6'b101011

`define sll 6'b000000
`define sra 6'b000011
`define srl 6'b000010

`define mult 6'b011000
`define multu 6'b011001
`define div 6'b011010
`define divu 6'b011011

`define mfhi 6'b010000
`define mflo 6'b010010
`define mthi 6'b010001
`define mtlo 6'b010011


`define jr 6'b001000
`define jalr 6'b001001

//////////////////////
//control of mux--pc
`define PC4 2'b00
`define NPC 2'b01
`define JRRS 2'b10
//control of mux--mfrsd & mfrtd
`define RF_RD1 2'b00
`define RF_RD2 2'b00
`define AO_M 2'b01
`define M4 2'b10
`define HILO 2'b11
//control of mux--mfrse & mfrte
`define RS_E 2'b00
`define RT_E 2'b00
//`define AO_M 2'b01
//`define M4 2'b10
//`define HILO 2'b11
//control of mux--Addr3   M3
`define Art 2'b00
`define Ard 2'b01
`define A31 2'b10
//control of mux--WD   M4
`define DR_W 2'b00
`define AO_W 2'b01
`define PC_W 2'b10
`define HILO_W 2'b11

//control of be_s
`define nos 4'b0000
`define sb_c 4'b0001
`define sh_c 4'b0010
`define sw_c 4'b0011

//control of ex_l
`define lw_c 4'b0000
`define lbu_c 4'b0001
`define lb_c 4'b0010
`define lh_c 4'b0011
`define lhu_c 4'b0100

//control of judge
`define beq_j 4'b0000
`define bne_j 4'b0001
`define blez_j 4'b0010
`define bgez_j 4'b0011
`define bltz_j 4'b0100
`define bgtz_j 4'b0101

//control of mult/div
`define multu_a 4'b0000
`define mult_a 4'b0001
`define divu_a 4'b0010
`define div_a 4'b0011
`define mthi_a 4'b0100
`define mtlo_a 4'b0101

//control of alu
`define addu_a 5'b00000
`define add_a 5'b00001
`define subu_a 5'b00010
`define sub_a 5'b00011
`define and_a 5'b00100
`define or_a 5'b00101
`define xor_a 5'b00110
`define nor_a 5'b00111
`define sllv_a 5'b01000
`define srav_a 5'b01001
`define srlv_a 5'b01010
`define sltu_a 5'b01011
`define slt_a 5'b01100
`define sll_a 5'b01101
`define sra_a 5'b01110
`define srl_a 5'b01111
`define lui_a 5'b10000
