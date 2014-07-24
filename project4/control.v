`timescale 1ns/10ps
`define ADD	2'b00
`define SUB	2'b01
`define SLA	2'b10
`define SRA	2'b11

module control(IM0,IM1,IM2,IM3,IM4,IM5,IM6,IM7,CLK,RST,r0_in, r1_in, r2_in, r3_in, r0, r1, r2, r3, A, B, ALUout);


	input CLK, RST;
	input[31:0] r0_in, r1_in, r2_in, r3_in; 
	output [31:0] A, B, ALUout;
	input [31:0]IM0,IM1,IM2,IM3,IM4,IM5,IM6,IM7;
	reg [31:0] PC;
	output [31:0] r0, r1, r2, r3;
	reg [31:0] M0,M1,M2,M3,M4,M5,M6,M7;
	reg first;
	reg [31:0]IN;
	
	
	reg RegDst, MemToReg, RegWrite, MemRead, MemWrite;
	reg [1:0]ALUSrc;
	reg [31:0] r0, r1, r2, r3;
	reg [1:0] ALUCtl;
	reg [31:0] A, B;
	reg lock;
	wire [31:0] ALUout;
	wire check;
	
	ALU alu(ALUCtl,A,B,ALUout);
	
	//////////////initialize
	
	always @(posedge RST) begin
		r0 <= r0_in;
		r1 <= r1_in;
		r2 <= r2_in;
		r3 <= r3_in;
		ALUCtl <= `ADD;
		A <= 32'd0;
		B <= 32'd0;
		lock<=1;
		first<=1;
		IN<=IM0;
		//PC<=0;/////initialize program counter
		M0<=0;
		M1<=1;
		M2<=2;
		M3<=3;
		M4<=4;
		M5<=5;
		M6<=6;
		M7<=7;
	end
	////////////////////////////////////////PC is to fetch the correct instruction in instruction memory
	always@(posedge CLK)begin///////////////IM0~IM7
		if(first)begin
			PC<=0;
			first<=0;
		end
		else if(PC<8)
			PC<=PC+1;
		else 
			PC<=PC;
	end
	
	always@(*)begin
		if(PC==0)begin
			IN<=IM0;
		end
		else if(PC==1)begin
			IN<=IM1;
		end
		else if(PC==2)begin
			IN<=IM2;
		end
		else if(PC==3)begin
			IN<=IM3;
		end
		else if(PC==4)begin
			IN<=IM4;
		end
		else if(PC==5)begin
			IN<=IM5;
		end
		else if(PC==6)begin
			IN<=IM6;
		end
		else if(PC==7)begin
			IN<=IM7;
		end
		
	end
	
	
	/////////////////////send ALUout back to the decoder in order to change 
	
	
	///use a decoder to translate the original signal into the signal
	///ALU can read
	/////generate control signal: RegDst MemtoReg RegWrite MemRead MemWrite ALUSrc
	always@(negedge CLK)begin
	
		if(IN[31:24]==32)//////add
			begin
				lock<=0;
				ALUCtl<=0;
				ALUSrc<=0;
				RegDst<=1;
				MemToReg<=0;
				RegWrite<=1;
				MemRead<=0;
				MemWrite<=0;
				
			end
		else if(IN[31:24]==16)//////sub
			begin
				lock<=0;
				ALUCtl<=1;
				ALUSrc<=0;
				RegDst<=1;
				MemToReg<=0;
				RegWrite<=1;
				MemRead<=0;
				MemWrite<=0;
			end
		else if(IN[31:24]==8)////shiftLeft
			begin
				lock<=0;
				ALUCtl<=2;
				ALUSrc<=1;
				RegDst<=1;// 1 for rd
				MemToReg<=0;
				RegWrite<=1;
				MemRead<=0;
				MemWrite<=0;
			end
		else if(IN[31:24]==4)//////shift right
			begin
				lock<=0;
				ALUCtl<=3;
				ALUSrc<=1;
				RegDst<=1;// 1 for rd
				MemToReg<=0;
				RegWrite<=1;
				MemRead<=0;
				MemWrite<=0;
			end
		else if(IN[31:24]==64)//store
			begin
				lock<=0;
				ALUCtl<=0;/////store also let alu to perform add
				ALUSrc<=2;
				//RegDst<=0; do not care the RegDst (because store did not perform RegWrite)
				//MemToReg<=0;
				RegWrite<=0;
				MemRead<=0;
				MemWrite<=1;
			end
		else if(IN[31:24]==128)//load
			begin
				lock<=0;
				ALUCtl<=0;////load also let alu to perform add
				ALUSrc<=2;
				RegDst<=0;// zero for rt field to be destination
				MemToReg<=1;
				RegWrite<=1;
				MemRead<=1;
				MemWrite<=0;
			end
	end
	///////////////////////////////////////////////////
	///ALUSrc
	always@(*)begin
	if(lock==0)begin
		if(ALUSrc==0)begin//add or type----->R-type
			case(IN[17:16])/////when ALUSrc==0 , represents that A is read from the value of register1(in the rs field)
				0:				///B read the value of the register2(in the rt field)
					A<=r0;
				1:
					A<=r1;
				2:
					A<=r2;
				3:
					A<=r3;
			endcase
			case(IN[9:8])
				0:
					B<=r0;
				1:
					B<=r1;
				2:
					B<=r2;
				3:
					B<=r3;
			endcase
		end
		else if(ALUSrc==1)begin//shift
			case(IN[17:16])//when ALUSrc==1, A is read from regster1(rs field),
				0:          //B is read from the number in the rt field(for shieft amount)
					A<=r0;   // because B is not the value in the register , shift should
				1:          //recieve different ALUSrc
					A<=r1;
				2:
					A<=r2;
				3:
					A<=r3;
			endcase
			B<=IN[15:8];
		end
		else if(ALUSrc==2)begin//load or store
			A<=IN[23:16];        // when ALUSrc==2, A is read from rs field
			B<=0;                // B must be 0(in this lab we don't have base register)
		end                     // because A,B's read is different from add,sub,shift left,shift right  
		                        //so should use different ALUSrc
		lock<=1;
		end//if lock
		
	end
	/////////ALUSrc

	always@(posedge CLK)begin
		if(MemWrite==1)begin//memory write I put the corresponding register into memory
			case(ALUout)
				0:
					begin
						case(IN[9:8])
						0:
							M0<=r0;
						1:
							M0<=r1;
						2:
							M0<=r2;
						3:
							M0<=r3;
						endcase
					end
				1:
					begin
						case(IN[9:8])
						0:
							M1<=r0;
						1:
							M1<=r1;
						2:
							M1<=r2;
						3:
							M1<=r3;
						endcase
					end
				2:
					begin
						case(IN[9:8])
						0:
							M2<=r0;
						1:
							M2<=r1;
						2:
							M2<=r2;
						3:
							M2<=r3;
						endcase
					end
				3:
					begin
						case(IN[9:8])
						0:
							M3<=r0;
						1:
							M3<=r1;
						2:
							M3<=r2;
						3:
							M3<=r3;
						endcase
					end
				4:
					begin
						case(IN[9:8])
						0:
							M4<=r0;
						1:
							M4<=r1;
						2:
							M4<=r2;
						3:
							M4<=r3;
						endcase
					end
				5:
					begin
						case(IN[9:8])
						0:
							M5<=r0;
						1:
							M5<=r1;
						2:
							M5<=r2;
						3:
							M5<=r3;
						endcase
					end
				6:
					begin
						case(IN[9:8])
						0:
							M6<=r0;
						1:
							M6<=r1;
						2:
							M6<=r2;
						3:
							M6<=r3;
						endcase
					end
				7:
					begin
						case(IN[9:8])
						0:
							M7<=r0;
						1:
							M7<=r1;
						2:
							M7<=r2;
						3:
							M7<=r3;
						endcase
					end
			
			endcase
			end
		end

	/////////////////////////////////////////////////////
	always@(posedge CLK)begin//register write
		if(RegWrite==1)begin
			if(RegDst==1&&MemToReg==0)begin//I should use RegDst signal to determine whether I should write
				case(IN[1:0])  //the register in rs field or rd field
					0:        
						r0<=ALUout;
					1:
						r1<=ALUout;
					2:
						r2<=ALUout;
					3:
						r3<=ALUout;
				endcase
			end
			else begin//RegDst==0
				if(MemRead==1&&MemToReg==1)begin// Memory read to the register
					case(IN[9:8])               
						0:
							begin
								case(ALUout)
								0:
									r0<=M0;
								1:
									r0<=M1;
								2:
									r0<=M2;
								3:
									r0<=M3;
								4:
									r0<=M4;
								5:
									r0<=M5;
								6:
									r0<=M6;
								7:
									r0<=M7;
								endcase
							end
						1:
							begin
								case(ALUout)
								0:
									r1<=M0;
								1:
									r1<=M1;
								2:
									r1<=M2;
								3:
									r1<=M3;
								4:
									r1<=M4;
								5:
									r1<=M5;
								6:
									r1<=M6;
								7:
									r1<=M7;
								endcase
							end
						2:
							begin
								case(ALUout)
								0:
									r2<=M0;
								1:
									r2<=M1;
								2:
									r2<=M2;
								3:
									r2<=M3;
								4:
									r2<=M4;
								5:
									r2<=M5;
								6:
									r2<=M6;
								7:
									r2<=M7;
								endcase
							end
						3:
							begin
								case(ALUout)
								0:
									r3<=M0;
								1:
									r3<=M1;
								2:
									r3<=M2;
								3:
									r3<=M3;
								4:
									r3<=M4;
								5:
									r3<=M5;
								6:
									r3<=M6;
								7:
									r3<=M7;
								endcase
							end
				endcase
				end
			end
		end
	end

endmodule
