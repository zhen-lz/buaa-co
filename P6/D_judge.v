`timescale 1ns / 1ps
`include"const.v"

module D_judge (
           input [31:0] data1,
           input [31:0] data2,
           input [3:0] judge_c,
           output judge
       );

assign judge = judge_c==`beq_j ? data1 == data2 :
       judge_c==`bne_j ? data1 != data2 :
       judge_c==`blez_j ? $signed(data1)<=0 :
       judge_c==`bgez_j ? $signed(data1)>=0 :
       judge_c==`bltz_j ? $signed(data1)<0 :
       judge_c==`bgtz_j ? $signed(data1)>0 :
       0;

endmodule //D_judge
