`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:51:48 11/30/2021 
// Design Name: 
// Module Name:    F_ifu 
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

module F_ifu (
           input [31:0] new_pc,
           input clk,
           input reset,
           input pc_en,
           output [31:0] im,
           output [31:0] pc4
       );

reg [31:0] PC;
reg [31:0] IM [4095:0];

initial begin
    PC=32'h0000_3000;
    $readmemh("code.txt",IM,0,4095);
end

always@(posedge clk) begin
    if (reset) begin
        PC<=32'h0000_3000;
    end
    else if (pc_en) begin //ÊÇ·ñ¶³½á
        PC<=new_pc;
    end
end

assign im=IM[ (PC-32'h0000_3000)>>2 ];
assign pc4=PC+4;

endmodule //F_ifu
