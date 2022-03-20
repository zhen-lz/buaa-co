`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:47:23 11/30/2021
// Design Name:
// Module Name:    D_grf
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

module D_grf (
           input [4:0] Addr1,
           input [4:0] Addr2,
           input [4:0] Addr3,
           input [31:0] WD,
           input [31:0] ir_D,
           input [31:0] pc,
           input clk,
           input reset,
           input WE,
           output [31:0] RD1,
           output [31:0] RD2
       );

reg [31:0] GRF [31:0];

integer i;

initial begin
    for(i=0; i < 32; i = i + 1)
        GRF[i] <= 0;
end

assign RD1 = Addr1==Addr3 ? ((WE & Addr3!=0) ? WD : GRF[Addr1]) : GRF[Addr1];
assign RD2 = Addr2==Addr3 ? ((WE & Addr3!=0) ? WD : GRF[Addr2]) : GRF[Addr2];

always@(posedge clk) begin
    if(reset) begin
        for(i=0; i < 32; i = i + 1)
            GRF[i] <= 0;
    end
    else if(WE) begin
        if(Addr3) begin
            GRF[Addr3] <= WD;
            $display("%d@%h: $%d <= %h",$time, pc, Addr3, WD);
        end
    end
end
//todo:write

endmodule //D_grf
