`include "const.v"

module M_exl (
           input [1:0] a,
           input [31:0] din,
           input [3:0] exl_c,

           output reg [31:0] dout
       );

always @* begin
    case (exl_c)
        `lw_c:
            dout=din;
        `lbu_c: begin
            case (a)
                2'b00:
                    dout={{24{1'b0}},din[7:0]};
                2'b01:
                    dout={{24{1'b0}},din[15:8]};
                2'b10:
                    dout={{24{1'b0}},din[23:16]};
                2'b11:
                    dout={{24{1'b0}},din[31:24]};
            endcase
        end
        `lb_c: begin
            case (a)
                2'b00:
                    dout={{24{din[7]}},din[7:0]};
                2'b01:
                    dout={{24{din[15]}},din[15:8]};
                2'b10:
                    dout={{24{din[23]}},din[23:16]};
                2'b11:
                    dout={{24{din[31]}},din[31:24]};
            endcase
        end
        `lhu_c: begin
            case (a[1])
                1'b0:
                    dout={{16{1'b0}},din[15:0]};
                1'b1:
                    dout={{16{1'b0}},din[31:16]};
            endcase
        end
        `lh_c: begin
            case (a[1])
                1'b0:
                    dout={{16{din[15]}},din[15:0]};
                1'b1:
                    dout={{16{din[31]}},din[31:16]};
            endcase
        end
        default:
            dout=din;
    endcase
end

endmodule //M_exl
