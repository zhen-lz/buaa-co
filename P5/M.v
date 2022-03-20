`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:51:26 11/30/2021 
// Design Name: 
// Module Name:    EM 
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

module M (
           input [31:0] ir_E,
           input [31:0] pc4_E,
           input [31:0] alu,
           input [31:0] mfrte,
           input clk,
           input reset,
           output [31:0] ir_M,
           output [31:0] pc4_M,
           output [31:0] ao_M,
           output [31:0] rt_M
       );

reg [31:0] IR;
reg [31:0] PC4;
reg [31:0] AO;
reg [31:0] RT;

initial begin
    IR=0;
    PC4=0;
    AO=0;
    RT=0;
end

assign ir_M=IR;
assign pc4_M=PC4;
assign ao_M=AO;
assign rt_M=RT;

always @(posedge clk) begin
    if(reset) begin
        IR<=0;
        PC4<=0;
        AO<=0;
        RT<=0;
    end
    else begin
        IR<=ir_E;
        PC4<=pc4_E;
        AO<=alu;
        RT<=mfrte;
    end
end


endmodule //EM
