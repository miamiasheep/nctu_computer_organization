`timescale 1ns/10ps
`define CYCLE 30      		// Modify your clock period here (unit:ns)

`define INS_COUNT 100
`define INSTRUCTION_FILE	"testcase/case1/test.in"
`define ANSWER					"testcase/case1/test.out"
 
module TESTBED;
	parameter CLK = `CYCLE/2;             //clock time
	reg clk, RST;
	reg [31:0] IN, r0_in, r1_in, r2_in, r3_in;
	wire [31:0] r0, r1, r2, r3, A, B, ALUout;
	reg [31:0]IM0,IM1,IM2,IM3,IM4,IM5,IM6,IM7,IM8,IM9,IM10,IM11,IM12,IM13,IM14,IM15,IM16,IM17,IM18,IM19;
	       
	reg [31:0] instruction	[`INS_COUNT:0];
	reg [31:0] ans_r0, ans_r1, ans_r2, ans_r3, ans_A, ans_B, ans_ALUout;
  	

	control a(IM0,IM1,IM2,IM3,IM4,IM5,IM6,IM7,IM8,IM9,IM10,IM11,IM12,IM13,IM14,IM15,IM16,IM17,IM18,IM19,clk,RST,r0_in, r1_in, r2_in, r3_in, r0, r1, r2, r3, A, B, ALUout);
	  
	integer testin, testout, cnt, ins, err_cnt;
	reg [99:0] string;
  
	//initial $readmemh(`INSTRUCTION_FILE, instruction);
	 
	initial begin
		testin  = $fopen(`INSTRUCTION_FILE, "r");
		//testout = $fopen(`ANSWER, "r");
		  
			$fscanf(testin, "%d %d %d %d\n", r0_in, r1_in, r2_in, r3_in);
			$fscanf(testin, "%b;", IM0);
			$fscanf(testin, "%b;", IM1);
			$fscanf(testin, "%b;", IM2);
			$fscanf(testin, "%b;", IM3);
			$fscanf(testin, "%b;", IM4);
			$fscanf(testin, "%b;", IM5);
			$fscanf(testin, "%b;", IM6);
			$fscanf(testin, "%b;", IM7);
			$fscanf(testin, "%b;", IM8);
			$fscanf(testin, "%b;", IM9);
			$fscanf(testin, "%b;", IM10);
			$fscanf(testin, "%b;", IM11);
			$fscanf(testin, "%b;", IM12);
			$fscanf(testin, "%b;", IM13);
			$fscanf(testin, "%b;", IM14);
			$fscanf(testin, "%b;", IM15);
			$fscanf(testin, "%b;", IM16);
			$fscanf(testin, "%b;", IM17);
			$fscanf(testin, "%b;", IM18);
			$fscanf(testin, "%b;", IM19);
			
		//$fgets(string, testin);
		
	
	$fclose(testin);

		#0 err_cnt = 0; cnt = 0;
		clk = 0;
		RST = 1;
		#`CYCLE RST = 0;
		
		//#CLK IN = instruction[0];
	  /*****************
		for(cnt=1; cnt<ins; cnt=cnt+1) begin

			#CLK 
			//$fscanf(testout, "%d %d %d %d %d %d %d\n", ans_r0, ans_r1, ans_r2, ans_r3, ans_A, ans_B, ans_ALUout);
			
			#CLK IN = instruction[PC];
/*******************
			if( (r0!=ans_r0) || (r1!=ans_r1) || (r2!=ans_r2) || (r3!=ans_r3) || (A!=ans_A) || (B!=ans_B) || (ALUout!=ans_ALUout) ) begin
				err_cnt = err_cnt + 1;
				$display("Error at instruction %d: %x\n", cnt, instruction[cnt-1]);
				$display("your  : R0: %x, R1: %x, R2: %x, R3: %x, A: %x, B: %x, ALUout: %x\n", r0, r1, r2, r3, A, B, ALUout);
				$display("expect: R0: %x, R1: %x, R2: %x, R3: %x, A: %x, B: %x, ALUout: %x\n\n", ans_r0, ans_r1, ans_r2, ans_r3, ans_A, ans_B, ans_ALUout);
			end
	
		end
	********************************************/	
		//#CLK $fscanf(testout, "%d %d %d %d %d %d %d\n", ans_r0, ans_r1, ans_r2, ans_r3, ans_A, ans_B, ans_ALUout);
		#CLK 
		if( (r0!=ans_r0) || (r1!=ans_r1) || (r2!=ans_r2) || (r3!=ans_r3) || (A!=ans_A) || (B!=ans_B) || (ALUout!=ans_ALUout) ) begin
			err_cnt = err_cnt + 1;
			$display("Error at instruction %d: %x\n", ins, instruction[ins-1]);
			$display("your  : R0: %x, R1: %x, R2: %x, R3: %x, A: %x, B: %x, ALUout: %x\n", r0, r1, r2, r3, A, B, ALUout);
			$display("expect: R0: %x, R1: %x, R2: %x, R3: %x, A: %x, B: %x, ALUout: %x\n\n", ans_r0, ans_r1, ans_r2, ans_r3, ans_A, ans_B, ans_ALUout);
		end
		
		if(err_cnt == 0)begin		
			$display("\n-------------------   ALU check successfully   -------------------\n");
		end
		else begin
			$display("\n-------------------   There are %d errors   -------------------\n", err_cnt);
			$display("------------------   Total %d instructions   ------------------\n", ins);
		end
		
		//$fclose(testout);
		#`CYCLE	
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE 
		#`CYCLE	
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE	
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE 
		#`CYCLE	
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		#`CYCLE
		$finish;
	end

	always #CLK clk = ~clk;
	  
endmodule