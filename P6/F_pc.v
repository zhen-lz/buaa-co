`timescale 1ns / 1ps
`include "const.v"

module F_pc(
           input [31:0] new_pc,
           input clk,
           input reset,
           input en,
           output [31:0] pc_F
       );

reg [31:0] PC;

initial begin
    PC=32'h0000_3000;
end

always @(posedge clk) begin
    if(reset) begin
        PC<=32'h0000_3000;
    end
    else if(en) begin
        PC<=new_pc;
    end
end

assign pc_F=PC;

endmodule
