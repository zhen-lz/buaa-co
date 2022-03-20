`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:52:49 11/30/2021 
// Design Name: 
// Module Name:    M_dm 
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

module M_dm (
           input [31:0] addr,
           input [31:0] WD,
           input [31:0] ir_M,
           input [31:0] pc,
           input r_en,
           input w_en,
           input clk,
           input reset,
           output [31:0] RD
       );

reg [31:0] MEM [3071:0];

integer i;

initial begin
    for(i=0; i < 3072; i = i + 1)
        MEM[i] = `zero;
end

assign RD = r_en ? MEM[ addr>>2 ] : `zero;

always @(posedge clk) begin
    if(reset)
        for(i=0; i < 3072; i = i + 1)
            MEM[i] = `zero;
    else if(w_en) begin
        MEM[ addr>>2 ] <= WD; 
        $display("%d@%h: *%h <= %h",$time,pc, addr, WD);
    end
end

endmodule //M_dm
