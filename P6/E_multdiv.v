`timescale 1ns / 1ps
`include "const.v"

module E_multdiv (
           input [31:0] data1,
           input [31:0] data2,
           input start,
           input [3:0] md_c,
           input clk,
           input reset,
           output busy,
           output [31:0] HI,
           output [31:0] LO
       );
reg [63:0] tmp;
reg [31:0] HI_R;
reg [31:0] LO_R;
integer counter;

initial begin
    HI_R =0;
    LO_R =0;
    counter=0;
end

always @(posedge clk) begin
    if(reset) begin
        HI_R<=0;
        LO_R<=0;
        counter<=0;
    end
    else begin
        case (md_c)
            `multu_a: begin
                if(start) begin
                    counter<=6;
                    tmp<=data1 * data2;
                end
            end
            `mult_a: begin
                if(start) begin
                    counter<=6;
                    tmp<=$signed(data1) * $signed(data2);
                end
            end
            `divu_a:
                if(start) begin
                    if(start) begin
                        counter<=11;
                        tmp[31:0]<=data1 / data2;
                        tmp[63:32]<=data1 % data2;
                    end
                end
            `div_a: begin
                if(start) begin
                    counter<=11;
                    tmp[31:0]<=$signed(data1) / $signed(data2);
                    tmp[63:32]<=$signed(data1) / $signed(data2);
                end
            end
            `mthi_a:
                HI_R<=data1;
            `mtlo_a:
                LO_R<=data1;
        endcase
    end

    if(counter!=0) begin
        counter <= counter - 1;
    end

    if(counter == 1) begin
        HI_R<=tmp[63:32];
        LO_R<=tmp[31:0];
    end
end

assign busy = counter>0 && !start;
assign HI = HI_R;
assign LO = LO_R;

endmodule //E_muldiv
