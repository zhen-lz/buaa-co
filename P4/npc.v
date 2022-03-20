`include "const.v"

module npc (
           input [31:0] pc,
           input [3:0] control_npc,
           input  alu_judge,
           input [25:0] addr,
           input [31:0] grf_data1,
           input [15:0] imme16,
           output[31:0] npc
       );

assign npc = control_npc==`pc4_npc ? pc+4:
       control_npc == `beq_npc && alu_judge ? pc + 4 + {{14{imme16[15]}},imme16,{2{1'b0}}}:
       control_npc == `j_npc ? {pc[31:28],addr,{2{1'b0}}}:
       control_npc == `jal_npc ? {pc[31:28],addr,{2{1'b0}}}:
       control_npc == `jr_npc ? grf_data1:
       pc+4;

endmodule
