`include "const.v"

module ifu (
           input [31:0] npc,
           input clk,
           input reset,
           output [31:0] pc,
           output [5:0] op,
           output [5:0] func,
           output [4:0] rs,
           output [4:0] rt,
           output [4:0] rd,
           output [4:0] shamt,
           output [15:0] imme16,
           output [25:0] addr
       );

reg [31:0] PC;
reg [31:0] IM [1023:0];

integer i;

initial begin
    PC <= 32'h0000_3000;
    $readmemh("/P4/code.txt",IM,0,1023);
end

always @(posedge clk) begin
    if(reset) begin
        PC <= 32'h0000_3000;
    end
    else begin
        PC <= npc;
    end
end

assign pc=PC;

assign  op =IM[PC[11:2]][31:26];
assign  func=IM[PC[11:2]][5:0];
assign  rs=IM[PC[11:2]][25:21];
assign  rt=IM[PC[11:2]][20:16];
assign  rd=IM[PC[11:2]][15:11];
assign  shamt=IM[PC[11:2]][10:6];
assign  imme16= IM[PC[11:2]][15:0];
assign  addr=IM[PC[11:2]][25:0];

endmodule //ifu
