`timescale 1ns / 1ps
`include "const.v"

module E (
           input [31:0] ir_D,
           input [31:0] pc_D,
           input [31:0] ext,
           input [31:0] rfrd1,
           input [31:0] rfrd2,
           input clk,
           input reset,
           output [31:0] ir_E,
           output [31:0] pc_E,
           output [31:0] ext_E,
           output [31:0] rfrd1_E,
           output [31:0] rfrd2_E,

           input [31:0] control_D,
           output [31:0] control_E
       );

reg [31:0] IR;
reg [31:0] PC;
reg [31:0] EXT;
reg [31:0] RFRD1;
reg [31:0] RFRD2;
reg [31:0] CONTROL;

initial begin
    IR=0;
    PC=0;
    EXT=0;
    RFRD1=0;
    RFRD2=0;
    CONTROL=0;
end

always @(posedge clk) begin
    if (reset) begin
        IR<=0;
        PC<=0;
        EXT<=0;
        RFRD1<=0;
        RFRD2<=0;
        CONTROL<=0;
    end
    else begin
        IR<=ir_D;
        PC<=pc_D;
        EXT<=ext;
        RFRD1<=rfrd1;
        RFRD2<=rfrd2;
        CONTROL<=control_D;
    end
end

assign ir_E=IR;
assign pc_E=PC;
assign ext_E=EXT;
assign rfrd1_E=RFRD1;
assign rfrd2_E=RFRD2;
assign control_E=CONTROL;

endmodule //DE
