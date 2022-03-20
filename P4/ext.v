`include "const.v"

module ext (
           input [15:0] imme16,
           input [3:0] control_ext,
           output [31:0] imme32
       );

assign imme32 = control_ext==`zero_ext ?{{16{1'b0}},imme16}:{{16{imme16[15]}},imme16};

endmodule
