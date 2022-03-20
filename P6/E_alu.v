`timescale 1ns / 1ps
`include "const.v"

module E_alu (
           input [31:0] data1,
           input [31:0] data2,
           input [4:0] s,
           input [4:0] alu_c,
           output [31:0] result
       );
reg [32:0] temp;


always @* begin
    case(alu_c)
        `add_a:
            temp={data1[31],data1} + {data2[31],data2};
        `sub_a:
            temp={data1[31],data1} - {data2[31],data2};
    endcase
end

assign result = (alu_c == `addu_a ? data1 + data2 :
                 alu_c == `add_a ? (temp[32]==temp[31] ? data1 + data2 : 32'b1):
                 alu_c == `subu_a ? data1 - data2 :
                 alu_c == `sub_a ? (temp[32]==temp[31] ? data1 - data2 : 32'b1):
                 alu_c == `and_a ? data1 & data2 :
                 alu_c == `or_a ? data1  | data2 :
                 alu_c == `xor_a ? data1 ^ data2 :
                 alu_c == `nor_a ? ~(data1 | data2) :
                 alu_c == `sllv_a ? data2 << data1[4:0] :
                 alu_c == `srav_a ? data2 >>> data1[4:0] :
                 alu_c == `srlv_a ? data2 >> data1[4:0] :
                 alu_c == `sltu_a ? (data1 < data2 ? 32'd1 : 32'd0):
                 alu_c == `slt_a ? ($signed(data1) < $signed(data2) ? 32'd1 : 32'd0):
                 alu_c == `sll_a ? data2 << s :
                 alu_c == `sra_a ? data2 >>> s :
                 alu_c == `srl_a ? data2 >> s :
                 alu_c == `lui_a ? data2 << 16 :
                 32'b0);

endmodule //E_alu
