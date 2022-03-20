`timescale 1ns / 1ps
`include "const.v"

module D(
           input [31:0] pc_F,
           input [31:0] ir_F,
           input clk,
           input reset,
           input en,
           output [31:0] pc_D,
           output [31:0] ir_D
       );

reg [31:0] PC;
reg [31:0] IR;

initial begin
    PC=0;
    IR=0;
end

always@(posedge clk) begin
    if(reset) begin
        PC<=0;
        IR<=0;
    end
    else if(en) begin
        PC<=pc_F;
        IR<=ir_F;
    end
end

assign pc_D=PC;
assign ir_D=IR;


endmodule
