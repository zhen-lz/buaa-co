`include "const.v"

module M_bes (
           input [1:0] a,
           input [3:0] bes_c,

           output reg [3:0] byteen
       );

always @* begin
    case (bes_c)
        `nos:
            byteen=4'b0000;
        `sb_c: begin
            case (a)
                2'b00:
                    byteen=4'b0001;
                2'b01:
                    byteen=4'b0010;
                2'b10:
                    byteen=4'b0100;
                2'b11:
                    byteen=4'b1000;
            endcase
        end
        `sh_c: begin
            case (a[1])
                1'b0:
                    byteen=4'b0011;
                1'b1:
                    byteen=4'b1100;
            endcase
        end
        `sw_c:
            byteen=4'b1111;
        default:
            byteen=4'b0000;
    endcase
end

endmodule
