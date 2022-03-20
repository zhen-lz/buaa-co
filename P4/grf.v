`include "const.v"

module grf (
           input [4:0] DataAddr1,
           input [4:0] DataAddr2,
           input [4:0] DataWriteAddr,
           input [31:0] DataWrite,
           input [31:0] pc,
           input clk,
           input reset,
           input WD,
           output [31:0] DataRead1,
           output [31:0] DataRead2
       );

reg [31:0] GRF [31:0];

integer i;

assign DataRead1 = GRF[DataAddr1];
assign DataRead2 = GRF[DataAddr2];

initial begin
    for(i=0; i < 32; i = i + 1)
        GRF[i] <= 0;
end

always@(posedge clk) begin
    if(reset) begin
        for(i=0; i < 32; i = i + 1)
            GRF[i] <= 0;
    end
    else if(WD) begin
        if(DataWriteAddr) begin
            GRF[DataWriteAddr] <= DataWrite;
            $display("@%h: $%d <= %h", pc, {{27{1'b0}},DataWriteAddr}, DataWrite);
        end
    end
end

endmodule //grf
