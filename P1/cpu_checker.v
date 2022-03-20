`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    01:22:34 10/17/2021
// Design Name:
// Module Name:    cpu_checker
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
`define S0 4'b0000  //初始状态
`define S1 4'b0001  //检查^xx
`define S2 4'b0010  //检查@xx
`define S3 4'b0011  //检查：
`define S4 4'b0100  //$xx 寄存器
`define S5 4'b0101  //检查<=xx
`define S6 4'b0110  //# 寄存器结束
`define S7 4'b0111  //*xx 数据储存器
`define S8 4'b1000  //检查<=xx
`define S9 4'b1001  //# 数据储存器结束
`define S10 4'b1010  //wrong

module cpu_checker(
           input clk,
           input reset,
           input [7:0] char,
           output [1:0] format_type
       );

reg [3:0] counter;
reg [3:0] status;
reg [7:0] temp;

initial begin
    status = `S0;
    counter = 4'b0000;
    temp = 8'd0;
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        status <= `S0;
        counter <= 2'b00;
    end
    else begin
        case (status)
            `S0 : begin
                if (char == "^") begin
                    status <=`S1;
                end
                else begin
                    status <= `S0;
                end
            end

            `S1 : begin
                if (char >="0" && char <= "9") begin
                    counter <= counter + 1;
                end
                else if(char == "@") begin
                    if(counter >= 4'b0001 && counter <= 4'b0100) begin
                        status <= `S2;
                        counter <= 4'b0001;
                    end
                    else begin
                        status <= `S10;
                        counter <= 4'b0000;
                    end
                end
                else begin
                    status <= `S10;
                    counter <= 4'b0000;
                end
            end

            `S2 : begin
                if ((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
                    counter <= counter + 1;
                end
                else if (char == ":") begin
                    if(counter == 4'b1000) begin
                        status <= `S3;
                        counter <= 4'b0000;
                    end
                    else begin
                        status <= `S10;
                        counter <= 4'b0000;
                    end
                end
                else begin
                    status <= `S10;
                    counter <= 4'b0000;
                end
            end

            `S3: begin
                if(char == "$") begin
                    status <= `S4;
                    counter <= 4'b0000;
                end
                else if(char == "*") begin
                    status <= `S7;
                    counter <= 4'b0000;
                end
                else if(char == " ") begin

                end
                else begin
                    status <= `S10;
                    counter <= 4'b0000;
                end
            end

            `S4 : begin
                if(char >= "0" && char <= "9") begin
                    counter <= counter + 1;
                    if(temp == " ") begin
                        status <= `S10;
                        counter <= 4'b0000;
                        temp <= 8'd0;
                    end
                end
                else if(char == "<") begin
                    temp <= char;
                end
                else if(char == "=") begin
                    if((temp == "<" )&& (counter >= 4'b0001 && counter <= 4'b0100)) begin
                        status <= `S5;
                        counter <= 4'b0000;
                        temp <= 8'd0;
                    end
                    else begin
                        status <= `S10;
                        counter <= 4'b0000;
                        temp <= 8'd0;
                    end
                end
                else if(char == " ") begin
                    temp <= char;
                end
                else begin
                    status <= `S10;
                    counter <= 4'b0000;
                    temp <= 8'd0;
                end
            end

            `S5: begin
                if ((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
                    counter <= counter + 1;
                end
                else if(char == " ") begin
                    if(counter != 4'b0000) begin
                        status <= `S10;
                        counter <= 4'b0000;
                    end
                end
                else if (char == "#") begin
                    if(counter == 4'b1000) begin
                        status <= `S6;
                        counter <= 4'b0000;
                    end
                    else begin
                        status <= `S10;
                        counter <= 4'b0000;
                    end
                end
                else begin
                    status <= `S10;
                    counter <= 4'b0000;
                end
            end

            `S6 : begin
                if(char == "^") begin
                    status <= `S1;
                    counter <= 4'b0000;
                end
                else begin
                    status <= `S0;
                    counter <= 4'b0000;
                end
            end

            `S7 : begin
                if((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
                    counter <= counter + 1;
                    if(temp == " ") begin
                        status <= `S10;
                        counter <= 4'b0000;
                        temp <= 8'd0;
                    end
                end
                else if(char == "<") begin
                    temp <= char;
                end
                else if(char == "=") begin
                    if((temp == "<" )&& (counter == 4'b1000)) begin
                        status <= `S8;
                        counter <= 4'b0000;
                        temp <= 8'd0;
                    end
                    else begin
                        status <= `S10;
                        counter <= 4'b0000;
                        temp <= 8'd0;
                    end
                end
                else if(char == " ") begin
                    temp <= char;
                end
                else begin
                    status <= `S10;
                    counter <= 4'b0000;
                    temp <= 8'd0;
                end
            end

            `S8 : begin
                if ((char >= "0" && char <= "9") || (char >= "a" && char <= "f")) begin
                    counter <= counter + 1;
                end
                else if(char == " ") begin
                    if(counter != 4'b0000) begin
                        status <= `S10;
                        counter <= 4'b0000;
                    end
                end
                else if (char == "#") begin
                    if(counter == 4'b1000) begin
                        status <= `S9;
                        counter <= 4'b0000;
                    end
                    else begin
                        status <= `S10;
                        counter <= 4'b0000;
                    end
                end
                else begin
                    status <= `S10;
                    counter <= 4'b0000;
                end
            end

            `S9 : begin
                if(char == "^") begin
                    status <= `S1;
                    counter <= 4'b0000;
                end
                else begin
                    status <= `S0;
                    counter <= 4'b0000;
                end
            end

            `S10 : begin
                if(char == "#") begin
                    status <= `S0;
                    counter <= 4'b0000;
                    temp <= 8'd0;
                end
            end

            default: begin
                status <= `S0;
                counter <= 4'b0000;
                temp <= 8'd0;
            end
        endcase
    end
end

assign format_type = status == `S6 ? 2'b01 : status == `S9 ? 2'b10 : status == `S10 ? 2'b00 : 2'b00;

endmodule
