`include "const.v"

module dm (
           input [31:0] ReadAddr,
           input [31:0] WriteAddr,
           input [31:0] WriteData,
           input [31:0] pc,
           input ReadEn,
           input WriteEn,
           input clk,
           input reset,
           output [31:0] ReadData
       );

reg [31:0] MEM [1023:0];

integer i;

initial begin
    for(i=0; i < 1024; i = i + 1)
        MEM[i] = `zero;
end

assign ReadData = ReadEn ? MEM[ReadAddr[11:2]] : `zero;

always @(posedge clk) begin
    if(reset)
        for(i=0; i < 1024; i = i + 1)
            MEM[i] = `zero;
    else if(WriteEn) begin
        MEM[WriteAddr[11:2]] <= WriteData;
        $display("@%h: *%h <= %h", pc, WriteAddr, WriteData);
    end
end

endmodule //dm
