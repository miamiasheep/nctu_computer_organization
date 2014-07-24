`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:41:29 10/28/2011 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
ALUCtl_2, A, B, ALUout
    );
	input[1:0] ALUCtl_2;
	input signed [31:0] A;
	input [31:0] B;	
	
	output[31:0] ALUout;
	
	
	reg [31:0] ALUout;
	
	
	//////use ALUCtl and A,B to calculate ALUout 
	
	always@ (*) begin
			case(ALUCtl_2)
			0:
				begin
					ALUout <= (A+B);
				end
			1:
				begin
					ALUout <= (A-B);
				end
			2:
				begin
					ALUout<=A<<B[5:0];
					
				end
			3:
				begin
					ALUout<=A>>>B[5:0];
				end
			endcase
		end
endmodule
