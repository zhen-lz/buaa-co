`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:50:35 11/30/2021 
// Design Name: 
// Module Name:    E_alu 
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

module E_alu (
           input [31:0] data1,
           input [31:0] data2,
           input [3:0] alu_c,
           output [31:0] result
       );

assign result = alu_c == `addu_a ? data1 + data2 :
       alu_c == `subu_a ? data1 - data2 :
       alu_c == `and_a ? data1 & data2 :
       alu_c == `or_a ? data1  | data2 :
       alu_c == `lui_a ? data2 << 16 :
       32'b0;

endmodule //E_alu
