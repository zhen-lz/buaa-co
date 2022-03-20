`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:50:19 11/30/2021 
// Design Name: 
// Module Name:    DE 
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

module E (
           input [31:0] ir_D,
           input [31:0] pc4_D,
           input [31:0] ext,
           input [31:0] rfrd1,
           input [31:0] rfrd2,
           input clk,
           input reset,
           output [31:0] ext_E,
           output [31:0] rfrd1_E,
           output [31:0] rfrd2_E,
           output [31:0] pc4_E,
           output [31:0] ir_E
       );

reg [31:0] IR;
reg [31:0] PC4;
reg [31:0] EXT;
reg [31:0] RFRD1;
reg [31:0] RFRD2;

initial begin
    IR=0;
    PC4=0;
    EXT=0;
    RFRD1=0;
    RFRD2=0;
end

always @(posedge clk) begin
    if (reset) begin
        IR<=0;
        PC4<=0;
        EXT<=0;
        RFRD1<=0;
        RFRD2<=0;
    end
    else begin
        IR<=ir_D;
        PC4<=pc4_D;
        EXT<=ext;
        RFRD1<=rfrd1;
        RFRD2<=rfrd2;
    end
end

assign ir_E=IR;
assign pc4_E=PC4;
assign ext_E=EXT;
assign rfrd1_E=RFRD1;
assign rfrd2_E=RFRD2;

endmodule //DE
