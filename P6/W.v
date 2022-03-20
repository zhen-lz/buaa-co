`timescale 1ns / 1ps
`include "const.v"

module W (
           input [31:0] ir_M,
           input [31:0] pc_M,
           input [31:0] ao_M,
           input [31:0] dm,
           input [31:0] hilo_M,
           input clk,
           input reset,
           output [31:0] ir_W,
           output [31:0] pc_W,
           output [31:0] ao_W,
           output [31:0] dr_W,
           output [31:0] hilo_W,

           input [31:0] control_M,
           output [31:0] control_W
       );

reg [31:0] IR;
reg [31:0] PC;
reg [31:0] AO;
reg [31:0] DR;
reg [31:0] HILO;
reg [31:0] CONTROL;

initial begin
    IR=0;
    PC=0;
    AO=0;
    DR=0;
    HILO=0;
    CONTROL=0;
end

assign ir_W=IR;
assign pc_W=PC;
assign ao_W=AO;
assign dr_W=DR;
assign hilo_W=HILO;
assign control_W=CONTROL;

always @(posedge clk) begin
    if(reset) begin
        IR<=0;
        PC<=0;
        AO<=0;
        DR<=0;
        HILO<=0;
        CONTROL<=0;
    end
    else begin
        IR<=ir_M;
        PC<=pc_M;
        AO<=ao_M;
        DR<=dm;
        HILO<=hilo_M;
        CONTROL<=control_M;
    end
end

endmodule //MW
