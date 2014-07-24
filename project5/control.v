`timescale 1ns/10ps
`define ADD	2'b00
`define SUB	2'b01
`define SLA	2'b10
`define SRA	2'b11

module control(IM0,IM1,IM2,IM3,IM4,IM5,IM6,IM7,IM8,IM9,IM10,IM11,IM12,IM13,IM14,IM15,IM16,IM17,IM18,IM19,CLK,RST,r0_in, r1_in, r2_in, r3_in, r0, r1, r2, r3, A, B, ALUout);

	input CLK, RST;
	input[31:0] r0_in, r1_in, r2_in, r3_in; 
	output [31:0] A, B, ALUout;
	input [31:0]IM0,IM1,IM2,IM3,IM4,IM5,IM6,IM7,IM8,IM9,IM10,IM11,IM12,IM13,IM14,IM15,IM16,IM17,IM18,IM19;
	reg [31:0] PC;
	output [31:0] r0, r1, r2, r3;
	reg [31:0] M0,M1,M2,M3,M4,M5,M6,M7;
	reg first;
	reg [31:0]IN,IN_2;
	reg loadUseHaz;
	reg [1:0]ForwardA,ForwardB;
	
	reg RegDst,RegDst_2,RegDst_3; 
	reg MemToReg,MemToReg_2,MemToReg_3;
	reg RegWrite,RegWrite_2,RegWrite_3;
	reg MemRead,MemRead_2,MemRead_3, MemWrite,MemWrite_2;
	reg stall;
	reg [1:0]ALUSrc;
	reg [1:0]ALUSrc_2,ALUSrc_3;
	reg [31:0]Rs,Rs_2,Rs_3,Rt,Rt_2,Rt_3,Rd,Rd_2,Rd_3;
	
	
	reg [31:0] r0, r1, r2, r3;
	reg [1:0] ALUCtl,ALUCtl_2;
	reg [31:0] A, B;
	reg [31:0]MemVal;
	reg firstOP;
	
//	reg [1:0]ForwardA,ForwardB;
	
	wire [31:0] ALUout;
	reg [31:0]ALUout_2;
	wire check;
	ALU alu(ALUCtl_2,A,B,ALUout);
	////signal transfer in pipe line register.
	always@(posedge CLK)begin
		RegDst_2<=RegDst;			
		RegDst_3<=RegDst_2;
		
		ALUSrc_2<=ALUSrc;
		ALUSrc_3<=ALUSrc_2;
		
		ALUout_2<=ALUout;
		
		MemToReg_2<=MemToReg;	
		MemToReg_3<=MemToReg_2;
		
		RegWrite_2<=RegWrite;
		RegWrite_3<=RegWrite_2;
		
		MemRead_2<=MemRead;
		MemRead_3<=MemRead_2;
		
		MemWrite_2<=MemWrite;
		
		ALUCtl_2<=ALUCtl;
		
		Rs_2<=Rs;
		Rs_3<=Rs_2;
		Rt_2<=Rt;
		Rt_3<=Rt_2;
		Rd_2<=Rd;
		Rd_3<=Rd_2;
	end
	////////signal transfer in pipe line register
	
	///////forward unit
	always@(*)begin
		////EX hazard
		if((RegWrite_2==1)&&(Rd_2==Rs)&&(RegDst_2==1))begin
			ForwardA<=2;
		end
		else if(((RegWrite_3==1)&&(Rd_3==Rs)&&(RegDst_3==1)))begin
			ForwardA<=1;
		end
		else if(((MemRead_3==1)&&(Rt_3==Rs)))begin
			ForwardA<=3;
		end
		else begin
			ForwardA<=0;
		end
		if((RegWrite_2==1)&&(Rd_2==Rt)&&(ALUSrc==0)&&(RegDst_2==1))begin
			ForwardB<=2;
		end
		else if(((RegWrite_3==1)&&(Rd_3==Rt)&&(ALUSrc==0)&&(RegDst_3==1)))begin
			ForwardB<=1;
		end
		else if(((MemRead_3==1)&&(Rt_3==Rt)&&(ALUSrc==0)))begin
			ForwardB<=3;
		end
		else begin
			ForwardB<=0;
		end
		
	end
	///////forward
	//////////////initialize
	
	always @(posedge RST) begin
		r0 <= r0_in;
		r1 <= r1_in;
		r2 <= r2_in;
		r3 <= r3_in;
		stall<=0;
		ALUCtl <= `ADD;
		A <= 32'd0;
		B <= 32'd0;
//		lock<=1;
		first<=1;
		IN<=IM0;
		//PC<=0;/////initialize program counter
		M0<=-3;
		M1<=-2;
		M2<=-1;
		M3<=0;
		M4<=1;
		M5<=2;
		M6<=3;
		M7<=4;
		firstOP<=0;
	end
	////////////////////////////////////////PC is to fetch the correct instruction in instruction memory
	///////perform the fetch stage
	always@(posedge CLK)begin///////////////IM0~IM7
		if(first)begin
			PC<=0;
			first<=0;
		end
		else if((PC<=19)&&(stall==0))
			PC<=PC+1;
		else begin
			PC<=PC;
			stall<=0;
			//stall<=0;
		end
	end
	
	always@(*)begin
		if(PC==0)begin
			IN<=IM0;
			firstOP<=1;
		end
		else if(stall==1)begin
			IN<=IN;
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
		else if(PC==8)begin
			IN<=IM8;
		end
		else if(PC==9)begin
			IN<=IM9;
		end
		else if(PC==10)begin
			IN<=IM10;
		end
		else if(PC==11)begin
			IN<=IM11;
		end
		else if(PC==12)begin
			IN<=IM12;
		end
		else if(PC==13)begin
			IN<=IM13;
		end
		else if(PC==14)begin
			IN<=IM14;
		end
		else if(PC==15)begin
			IN<=IM15;
		end
		else if(PC==16)begin
			IN<=IM16;
		end
		else if(PC==17)begin
			IN<=IM17;
		end
		else if(PC==18)begin
			IN<=IM18;
		end
		else if(PC==19)begin
			IN<=IM19;
		end
	end
	
	
	/////////////////////send ALUout back to the decoder in order to change 
	
	
	///use a decoder to translate the original signal into the signal
	///ALU can read
	/////generate control signal: RegDst MemtoReg RegWrite MemRead MemWrite ALUSrc
	//perform the decode stage
	always@(posedge CLK)begin
	if(firstOP)begin
		if(IN[31:24]==32)//////add
			begin
				//lock<=0;
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
				//lock<=0;
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
				//lock<=0;
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
				//lock<=0;
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
				//lock<=0;
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
				//lock<=0;
				ALUCtl<=0;////load also let alu to perform add
				ALUSrc<=2;
				RegDst<=0;// zero for rt field to be destination
				MemToReg<=1;
				RegWrite<=1;
				MemRead<=1;
				MemWrite<=0;
			end
		else if((IN[31:24]==0)
					)//the following is NOP
			begin
				//lock<=0;
				//stall<=1;
				ALUCtl<=0;
				ALUSrc<=0;
				RegDst<=0; 
				MemToReg<=0;
				RegWrite<=0;
				MemRead<=0;
				MemWrite<=0;
			end
			if(
					((Rt==IN[17:16])&&(IN[31:24]==32||IN[31:24]==16||IN[31:24]==8||IN[31:24]==4))
					||((Rt==IN[9:8])&&(IN[31:24]==32||IN[31:24]==16))
					//&&(IN[31:24]==32||IN[31:24]==16||IN[31:24]==8||IN[31:24]==4)
					&&MemRead==1	
					)
					begin
						stall<=1;
						ALUCtl<=0;
						ALUSrc<=0;
						RegDst<=0; 
						MemToReg<=0;
						RegWrite<=0;
						MemRead<=0;
						MemWrite<=0;
					end
			Rs<=IN[17:16];
			Rt<=IN[9:8];
			Rd<=IN[1:0];
			IN_2<=IN;
		end/////for if
		else begin
			ALUCtl<=0;
			ALUSrc<=0;
			RegDst<=0; 
			MemToReg<=0;
			RegWrite<=0;
			MemRead<=0;
			MemWrite<=0;
		end
	end
	///////////////////////////////////////////////////
	///ALUSrc   Ex stage
	always@(posedge CLK)begin
		if(ALUSrc==0)begin//add or type----->R-type
			if(ForwardA==0)begin
				case(Rs)/////when ALUSrc==0 , represents that A is read from the value of register1(in the rs field)
					0:				///B read the value of the register2(in the rt field)
						begin
							A<=r0;
						end
					1:
						begin
							A<=r1;
						end
					2:
						begin
							A<=r2;
						end
					3:
						begin
							A<=r3;
						end
				endcase
			end
			else if (ForwardA==2)begin
				A<=ALUout;
			end
			else if(ForwardA==1)begin
				A<=ALUout_2;
			end
			else if(ForwardA==3)begin
				A<=MemVal;
			end
			if(ForwardB==0)begin
				case(Rt)
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
			else if(ForwardB==2)begin
				B<=ALUout;
			end
			else if(ForwardB==1)begin
				B<=ALUout_2;
			end
			else if(ForwardB==3)begin
				B<=MemVal;
			end
			end
		else if(ALUSrc==1)begin//shift immediate mode	
			if(ForwardA==0)begin
				case(Rs)//when ALUSrc==1, A is read from regster1(rs field),
					0:          //B is read from the number in the rt field(for shift amount)
						A<=r0;   // because B is not the value in the register , shift should
					1:          //recieve different ALUSrc
						A<=r1;
					2:
						A<=r2;
					3:
						A<=r3;
				endcase
			end
			else if(ForwardA==2)begin
				A<=ALUout;
			end
			else if(ForwardA==1)begin
				A<=ALUout_2;
			end
			else if(ForwardA==3)begin
				A<=MemVal;
			end
			B<=IN_2[15:8];
		end
		else if(ALUSrc==2)begin//load or store
			A<=IN_2[23:16];        // when ALUSrc==2, A is read from rs field
			B<=0;                // B must be 0(in this lab we don't have base register)
		end                     // because A,B's read is different from add,sub,shift left,shift right  
		                        //so should use different ALUSrc
		//lock<=1;
		
		
	end
	/////////ALUSrc

	always@(posedge CLK)begin
		if(MemWrite_2==1)begin//memory write I put the corresponding register into memory
		
			case(ALUout)
			
				0:
					begin
						case(Rt_2)
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
						case(Rt_2)
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
						case(Rt_2)
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
						case(Rt_2)
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
						case(Rt_2)
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
						case(Rt_2)
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
						case(Rt_2)
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
						case(Rt_2)
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
	/////////MemStage	
	always@(posedge CLK)begin
		if(MemRead_2==1)begin
			case(ALUout)
				0:
					MemVal<=M0;
				1:
					MemVal<=M1;
				2:
					MemVal<=M2;
				3:
					MemVal<=M3;
				4:
					MemVal<=M4;
				5:
					MemVal<=M5;
				6:
					MemVal<=M6;
				7:
					MemVal<=M7;
			endcase
		end
	end
	//////////MemStage
	/////////////////////////////////////////////////////
	always@(negedge CLK)begin//register write back
		if(RegWrite_3==1)begin
			if(RegDst_3==1&&MemToReg_3==0)begin//I should use RegDst signal to determine whether I should write
				case(Rd_3)  //the register in rs field or rd field
					0:        
						r0<=ALUout_2;
					1:
						r1<=ALUout_2;
					2:
						r2<=ALUout_2;
					3:
						r3<=ALUout_2;////For MemToReg==0
				endcase
			end
			else begin//RegDst==0
				if(MemRead_3==1&&MemToReg_3==1)begin// Memory read to the register
					case(Rt_3)               
						0:
							begin
								r0<=MemVal;
							end
						1:
							begin
								r1<=MemVal;
							end
						2:
							begin
								r2<=MemVal;
							end
						3:
							begin
								r3<=MemVal;
							end
				endcase
				end
			end
		end
	end

endmodule
