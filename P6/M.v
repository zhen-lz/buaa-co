`timescale 1ns / 1ps
`include "const.v"

module M (
           input [31:0] ir_E,
           input [31:0] pc_E,
           input [31:0] alu,
           input [31:0] mfrte,
           input [31:0] hilo,
           input clk,
           input reset,
           output [31:0] ir_M,
           output [31:0] pc_M,
           output [31:0] ao_M,
           output [31:0] rt_M,
           output [31:0] hilo_M,

           input [31:0] control_E,
           output [31:0] control_M
       );

reg [31:0] IR;
reg [31:0] PC;
reg [31:0] AO;
reg [31:0] RT;
reg [31:0] HILO;
reg [31:0] CONTROL;

initial begin
    IR=0;
    PC=0;
    AO=0;
    RT=0;
    HILO=0;
    CONTROL=0;
end

assign ir_M=IR;
assign pc_M=PC;
assign ao_M=AO;
assign rt_M=RT;
assign hilo_M=HILO;
assign control_M=CONTROL;

always @(posedge clk) begin
    if(reset) begin
        IR<=0;
        PC<=0;
        AO<=0;
        RT<=0;
        HILO<=0;
        CONTROL<=0;
    end
    else begin
        IR<=ir_E;
        PC<=pc_E;
        AO<=alu;
        RT<=mfrte;
        HILO<=hilo;
        CONTROL<=control_E;
    end
end


endmodule //EM
