`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:25 11/30/2021 
// Design Name: 
// Module Name:    MW 
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

module W (
           input [31:0] ir_M,
           input [31:0] pc4_M,
           input [31:0] ao_M,
           input [31:0] dm,
           input clk,
           input reset,
           output [31:0] ir_W,
           output [31:0] pc4_W,
           output [31:0] ao_W,
           output [31:0] dr_W
       );

reg [31:0] IR;
reg [31:0] PC4;
reg [31:0] AO;
reg [31:0] DR;

initial begin
    IR=0;
    PC4=0;
    AO=0;
    DR=0;
end

assign ir_W=IR;
assign pc4_W=PC4;
assign ao_W=AO;
assign dr_W=DR;

always @(posedge clk) begin
    if(reset) begin
        IR<=0;
        PC4<=0;
        AO<=0;
        DR<=0;
    end
    else begin
        IR<=ir_M;
        PC4<=pc4_M;
        AO<=ao_M;
        DR<=dm;
    end
end

endmodule //MW
