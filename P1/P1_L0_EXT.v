`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    14:19:19 10/22/2021
// Design Name:
// Module Name:    ext
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
`define zero 32'b0;

module ext(
           input [15:0] imm,
           input [1:0] EOp,
           output [31:0] ext
       );

reg [31:0] tmp;

always @(imm) begin
    tmp <= imm;
end

assign ext = EOp == 2'b00 ? $signed($signed(tmp << 5'd16) >>> 5'd16) :
       EOp == 2'b01 ? tmp:
       EOp == 2'b10 ? tmp << 5'd16 :
       EOp == 2'b11 ? $signed($signed(tmp << 5'd16) >>> 5'd16) << 2'd2 :
       `zero;

endmodule
