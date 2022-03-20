`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:52:26 11/30/2021 
// Design Name: 
// Module Name:    FD 
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

module D (
           input [31:0] im,
           input [31:0] pc4,
           input clk,
           input reset,
           input d_en,
           output [31:0] ir_D,
           output [31:0] pc4_D
       );

reg [31:0] IR;
reg [31:0] PC4;

initial begin
    IR=0;
    PC4=0;
end

assign ir_D=IR;
assign pc4_D=PC4;

always @(posedge clk) begin
    if (reset) begin
        IR<=0;
        PC4<=0;
    end
    else begin
        if(d_en) begin
            IR<=im;
				PC4<=pc4;
        end
    end
end

endmodule //FD
