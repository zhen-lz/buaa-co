`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:44:48 11/30/2021 
// Design Name: 
// Module Name:    const 
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
//global
`define zero 32'b0
//÷∏¡Ó–≈∫≈
`define lui 6'b001111
`define ori 6'b001101
`define lw 6'b100011
`define sw 6'b101011
`define beq 6'b000100
`define j 6'b000010
`define jal 6'b000011
//R-format
`define r_format 6'b0
`define addu 6'b100001
`define subu 6'b100011
`define jr 6'b001000

//control of mux--pc
`define PC4 2'b00
`define NPC 2'b01
`define RFRD1 2'b10
//control of mux--mfrsd & mfrtd
`define RF_RD1 2'b00
`define RF_RD2 2'b00
`define AO_M 2'b01
`define M4 2'b10
//control of mux--mfrse & mfrte
`define RS_E 2'b00
`define RT_E 2'b00
//`define AO_M 2'b01
//`define M4 2'b10
//control of mux--Addr3
`define Art 2'b00
`define Ard 2'b01
`define A31 2'b10
//control of mux--WD
`define DR_W 2'b00
`define AO_W 2'b01
`define PC4_W 2'b10


//control of alu
`define defa 4'b0000
`define addu_a 4'b0000
`define subu_a 4'b0001
`define and_a 4'b0010
`define or_a 4'b0011
`define lui_a 4'b0100
