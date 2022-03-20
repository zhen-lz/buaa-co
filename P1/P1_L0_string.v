`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    17:39:44 10/22/2021
// Design Name:
// Module Name:    P1_L0_string
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
`define S0 2'b00 //initial
`define S1 2'b01 //number
`define S2 2'b10 //+ or *
`define S3 2'b11 //wrong

module string(
           input clk,
           input clr,
           input [7:0] in,
           output out
       );

reg [1:0] status;

initial begin
    status <= `S0;
end

always @(posedge clr) begin
    status <= `S0;
end

always @(posedge clk) begin
    if (clr == 1) begin
        status <= `S0;
    end
    else begin
        case (status)
            `S0 : begin
                if(in >= "0" && in <= "9") begin
                    status <= `S1;
                end
                else if (in == "+" || in == "*") begin
                    status <= `S3;
                end
                else begin
                    status <= `S3;
                end
            end

            `S1 : begin
                if (in == "*" || in == "+") begin
                    status <= `S2;
                end
                else if(in >= "0" && in <= "9") begin
                    status <= `S3;
                end
                else begin
                    status <= `S3;
                end
            end

            `S2 : begin
                if (in == "*" || in == "+") begin
                    status <= `S3;
                end
                else if(in >= "0" && in <= "9") begin
                    status <= `S1;
                end
                else begin
                    status <= `S3;
                end
            end

            default: begin
                status <= `S3;
            end
        endcase
    end
end


endmodule
