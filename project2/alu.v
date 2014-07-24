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
ALUCtl, A, B, ALUout
    );
	 
	input[1:0] ALUCtl;
	input signed [31:0] A;
	input [31:0] B;	
	
	output[31:0] ALUout;
	
	
	reg [31:0] ALUout;
	
	
	//////use ALUCtl and A,B to calculate ALUout 
	
	always@ (*) begin
			case(ALUCtl)
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
					case(B[5:0])
                        0:
                            ALUout <= (A<<0);
                        1:
                            ALUout <= (A<<1);
                        2:
                            ALUout <= (A<<2);
                        3:
                            ALUout <= (A<<3);
                        4:
                            ALUout <= (A<<4);
                        5:
                            ALUout <= (A<<5);
                        6:
                            ALUout <= (A<<6);
                        7:
                            ALUout <= (A<<7);
                        8:
                            ALUout <= (A<<8);
                        9:
                            ALUout <= (A<<9);
                        10:
                            ALUout <= (A<<10);
                        11:
                            ALUout <= (A<<11);
                        12:
                            ALUout <= (A<<12);
                        13:
                            ALUout <= (A<<13);
                        14:
                            ALUout <= (A<<14);
                        15:
                            ALUout <= (A<<15);
                        16:
                            ALUout <= (A<<16);
                        17:
                            ALUout <= (A<<17);
                        18:
                            ALUout <= (A<<18);
                        19:
                            ALUout <= (A<<19);
                        20:
                            ALUout <= (A<<20);
                        21:
                            ALUout <= (A<<21);
                        22:
                            ALUout <= (A<<22);
                        23:
                            ALUout <= (A<<23);
                        24:
                            ALUout <= (A<<24);
                        25:
                            ALUout <= (A<<25);
                        26:
                            ALUout <= (A<<26);
                        27:
                            ALUout <= (A<<27);
                        28:
                            ALUout <= (A<<28);
                        29:
                            ALUout <= (A<<29);
                        30:
                            ALUout <= (A<<30);
                        31:
                            ALUout <= (A<<31);

					endcase
				end
			3:
				begin
					
					case(B[5:0])
                        0:
									
                            ALUout <= (A>>>0);
									 
								
                        1:
									
                            ALUout <= (A>>>1);
									
									
                        2:
								  
                            ALUout <= (A>>>2);
								 
                        3:
                            ALUout <= (A>>>3);
                        4:
                            ALUout <= (A>>>4);
                        5:
                            ALUout <= (A>>>5);
                        6:
                            ALUout <= (A>>>6);
                        7:
                            ALUout <= (A>>>7);
                        8:
                            ALUout <= (A>>>8);
                        9:
                            ALUout <= (A>>>9);
                        10:
                            ALUout <= (A>>>10);
                        11:
                            ALUout <= (A>>>11);
                        12:
                            ALUout <= (A>>>12);
                        13:
                            ALUout <= (A>>>13);
                        14:
                            ALUout <= (A>>>14);
                        15:
                            ALUout <= (A>>>15);
                        16:
                            ALUout <= (A>>>16);
                        17:
                            ALUout <= (A>>>17);
                        18:
                            ALUout <= (A>>>18);
                        19:
                            ALUout <= (A>>>19);
                        20:
                            ALUout <= (A>>>20);
                        21:
                            ALUout <= (A>>>21);
                        22:
                            ALUout <= (A>>>22);
                        23:
                            ALUout <= (A>>>23);
                        24:
                            ALUout <= (A>>>24);
                        25:
                            ALUout <= (A>>>25);
                        26:
                            ALUout <= (A>>>26);
                        27:
                            ALUout <= (A>>>27);
                        28:
                            ALUout <= (A>>>28);
                        29:
                            ALUout <= (A>>>29);
                        30:
                            ALUout <= (A>>>30);
                        31:
                            ALUout <= (A>>>31);

					endcase
				end
		endcase
		
		
	end
	
endmodule
