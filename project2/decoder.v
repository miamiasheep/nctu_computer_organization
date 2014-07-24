`timescale 1ns/10ps
`define ADD	2'b00
`define SUB	2'b01
`define SLA	2'b10
`define SRA	2'b11

module Decoder(CLK,RST,IN, r0_in, r1_in, r2_in, r3_in, r0, r1, r2, r3, A, B, ALUout);

	input CLK, RST;
	input[31:0]IN, r0_in, r1_in, r2_in, r3_in;
	output [31:0] A, B, ALUout;
	output [31:0] r0, r1, r2, r3;
	
	reg [31:0] r0, r1, r2, r3;
	reg [1:0] ALUCtl;
	reg [31:0] A, B;
	wire [31:0] ALUout;
	wire check;
	
	ALU alu(ALUCtl, A, B, ALUout);
	
	//////////////initialize
	
	always @(posedge RST) begin
		r0 <= r0_in;
		r1 <= r1_in;
		r2 <= r2_in;
		r3 <= r3_in;
		ALUCtl <= `ADD;
		A <= 32'd0;
		B <= 32'd0;
	end
	/////////////////////send ALUout back to the decoder in order to change 
	////////////////////the corresponding register
	always@(*)begin
		
		case(IN[1:0])
		0:
			begin
				r0<=ALUout;
				
			end
		1:
			begin
				r1<=ALUout;
				
			end
		2:
			begin
				r2<=ALUout;
			end
		3:
			begin
				r3<=ALUout;
			end
		endcase
		
	end
	/////IN[17:16] is Rs(because 0<=Rs<=e), so we can put the value Rs
	/////into A
	always@(posedge CLK)begin
		case(IN[17:16])
			0:
				A<=r0;
			1:
				A<=r1;
			2:
				A<=r2;
			3:
				A<=r3;
		endcase
	end
	
	////IN[15:8] is the Rd field, it can be the register's number or shift amount
	////I use a IN[31:24]>8 or <=8 to identify which it is register's number or shieft amount
	///because if IN[31:24]<=8 the instruction must be shieft right or shieft left
	always@(posedge CLK)begin
		if(IN[31:24]>8)begin
		case(IN[9:8])
			0:
				begin
				
						B<=r0;
					
				end
			1:
				begin
				
						B<=r1;
					
				end
			2:
				begin
			
						B<=r2;
					
				end
			3:
				begin
				
						B<=r3;
					
				end
		endcase
		end
		else begin
			B<=IN[15:8];
		end
	end
	
	///use a decoder to translate the original signal into the signal
	///ALU can read
	always@(posedge CLK)begin
		if(IN[31:24]==32)
			begin
				ALUCtl<=0;
			end
		else if(IN[31:24]==16)
			begin
				ALUCtl<=1;
			end
		else if(IN[31:24]==8)
			begin
				ALUCtl<=2;
			end
		else if(IN[31:24]==4)
			begin
				ALUCtl<=3;
			end
	end

endmodule
