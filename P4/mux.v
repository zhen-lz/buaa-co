`include "const.v"

module mux (
           //grf
           input [31:0] alu_result,
           input [31:0] pc,
           input [31:0] dm_data,
           input [4:0] rt,
           input [4:0] rd,
           input [3:0] control_grf_WD,
           input [3:0] control_grf_WA,
           output [31:0] WriteData,
           output [4:0] WriteAddr,
           //alu
           input [31:0] grf_data2,
           input [31:0] imme32,
           input [3:0] control_alu_data2,
           output [31:0] data2
       );
//grf
assign WriteData = control_grf_WD==`mux_grf_alu ? alu_result :
       control_grf_WD==`mux_grf_dm ? dm_data :
       control_grf_WD==`mux_grf_pc ? pc + 4 :
       `zero;

assign WriteAddr = control_grf_WA==`mux_grf_rt ? rt:
       control_grf_WA==`mux_grf_rd ? rd:
       control_grf_WA==`mux_grf_pc ? 5'd31:
       5'b0;

//alu
assign data2 = control_alu_data2==`mux_alu_grf ? grf_data2:
       control_alu_data2==`mux_alu_imme32 ? imme32:
       `zero;

endmodule
