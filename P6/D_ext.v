`timescale 1ns / 1ps
`include "const.v"

module D_ext (
           input [15:0] imme16,
           input sign,
           output [31:0] imme32
       );

assign imme32 = sign ? {{16{imme16[15]}},imme16} : {{16{1'b0}},imme16};

endmodule //D_ext
