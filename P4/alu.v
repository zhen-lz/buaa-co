`include "const.v"

module alu (
           input [31:0] data1,
           input [31:0] data2,
           input [3:0] control_alu,
           output [31:0] result,
           output judge
       );

assign result = control_alu == `addu_alu ? data1 + data2 :
       control_alu == `subu_alu ? data1 - data2 :
       control_alu == `and_alu ? data1 & data2 :
       control_alu == `or_alu ? data1  | data2 :
       control_alu == `shift16 ? data2 << 16 :
       32'b0;

assign judge = control_alu == `equal ? data1 == data2 : 0;

endmodule //alu
