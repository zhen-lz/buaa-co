`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    16:47:09 10/22/2021
// Design Name:
// Module Name:    P1_L0_gray
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module gray(
           input Clk,
           input Reset,
           input En,
           output [2:0] Output,
           output Overflow
       );

reg [3:0] counter;

initial begin
    counter = 0;
end

always @(posedge Clk) begin
    if(Reset == 1) begin
        counter <= 0;
    end
    else begin
        if(En == 1) begin
            if(counter == 4'b1111) begin
                counter = 4'b1000;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end
end

assign Output = counter[2:0] == 3'b000 ? 3'b000 :
       counter[2:0] == 3'b001 ? 3'b001 :
       counter[2:0] == 3'b010 ? 3'b011 :
       counter[2:0] == 3'b011 ? 3'b010 :
       counter[2:0] == 3'b100 ? 3'b110 :
       counter[2:0] == 3'b101 ? 3'b111 :
       counter[2:0] == 3'b110 ? 3'b101 :
       counter[2:0] == 3'b111 ? 3'b100 :
       3'b000;

assign Overflow = counter[3] == 1 ? 1 : 0;

endmodule
