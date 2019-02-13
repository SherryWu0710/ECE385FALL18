//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------


module ISDU (   input logic         Clk, 
												Reset,
												Run,
												Continue,
									
				input logic[3:0]    Opcode, 
				input logic         IR_5,
				input logic         IR_11,
				input logic         BEN,
				  
				output logic        LD_MAR,
										  LD_MDR,
										  LD_IR,
										  LD_BEN,
										  LD_CC,
										  LD_REG,
										  LD_PC,
										  LD_LED, // for PAUSE instruction
									
				output logic        GatePC,
										  GateMDR,
										  GateALU,
										  GateMARMUX,
									
				output logic [1:0]  PCMUX,
				output logic        DRMUX,
										  SR1MUX,
										  SR2MUX,
										  ADDR1MUX,
				output logic [1:0]  ADDR2MUX,
									     ALUK,
				  
				output logic        Mem_CE,
										  Mem_UB,
										  Mem_LB,
										  Mem_OE_out,
										  Mem_WE_out
				);

	enum logic [4:0] {  Halted, 
						     PauseIR1, 
						     PauseIR2, 
						     S_18, 
						     S_33_0,
							  S_33_1, 
							  S_33_3,
						     S_35, 
						     S_32, 
						     S_01,
							  S_05,
							  S_09,
							  S_06,
							  S_25_0,
							  S_25_1,
							  S_25_2,
							  S_27,
							  S_07,
							  S_23,
							  S_16_0,
							  S_16_1,
							  S_16_2,
							  S_04,
							  S_21,
							  S_12,
							  S_00,
							  S_22}   State, Next_state;   // Internal state logic
		
	
	//logic Mem_OE_out;
	//logic Mem_WE_out;
	//assign Mem_OE = Mem_OE_out
	
	//sync sync_output[1:0] (Clk, {Mem_OE_out, Mem_WE_out}, {Mem_OE, Mem_WE});
	
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;
		 
		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;
		 
		ALUK = 2'b00;
		 
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b1;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b1;
		ADDR2MUX = 2'b00;
		 
		Mem_OE_out = 1'b1;
		Mem_WE_out = 1'b1;
	
		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = S_18;                      
			S_18 : 
				Next_state = S_33_0;
			// Any states involving SRAM require more than one clock cycles.
			// The exact number will be discussed in lecture.
			S_33_0 :
				Next_state = S_33_1;
			S_33_1 : 
				Next_state = S_33_3;
			S_33_3 : 
				Next_state = S_35;
			S_35 : 
				Next_state = S_32;
			// PauseIR1 and PauseIR2 are only for Week 1 such that TAs can see 
			// the values in IR.
			PauseIR1 : 
				if (~Continue) 
					Next_state = PauseIR1;
				else 
					Next_state = PauseIR2;
			PauseIR2 : 
				if (Continue) 
					Next_state = PauseIR2;
				else 
					Next_state = S_18;
			S_32 : 
				case (Opcode)
					4'b0001 :   //Add and Addi
						Next_state = S_01;

					// You need to finish the rest of opcodes.....
					
					4'b0101 : 	//AND and ANDi
						Next_state = S_05;
						
					4'b1001 :   //NOT
						Next_state = S_09;
						
					4'b0110 :  //LDR
						Next_state = S_06;
					
					4'b0111 :  //STR
						Next_state = S_07;
						
					4'b0100 :  //JSR
						Next_state = S_04;
					
					4'b1100 :  //JMP
						Next_state = S_12;
					
					4'b0000 :  //BR
						Next_state = S_00;
					
					4'b1101 :  //PauseIR1
						Next_state = PauseIR1;
						
					default : 
						Next_state = S_18;
				endcase
			S_01 : 
				Next_state = S_18;
			
			S_05 :
				Next_state = S_18;
				
			S_09 :
				Next_state = S_18;
				
			S_06 :
				Next_state = S_25_0;
			
			S_25_0 :
				Next_state = S_25_1;
			
			S_25_1 :
				Next_state = S_25_2;
				
			S_25_2 :
				Next_state = S_27;
				
			S_27 :
				Next_state = S_18;
				
			S_07 :
				Next_state = S_23;
				
			S_23 :
				Next_state = S_16_0;
			
			S_16_0 :
				Next_state = S_16_1;
				
			S_16_1 :
				Next_state = S_16_2;
				
			S_16_2 :
				Next_state = S_18;
			
			S_04 :
				Next_state = S_21;
			
			S_21 : 
				Next_state = S_18;
			
			S_12 :
				Next_state = S_18;
				
			S_00 :
				case(BEN)
					1'b1 :
						Next_state = S_22;
					1'b0 :
						Next_state = S_18;
				endcase
			
			S_22 :
				Next_state = S_18;
			

			// You need to finish the rest of states.....

			default :
				Next_state = S_18 ;

		endcase
		
		// Assign control signals based on current state
		case (State)
			Halted: ;
			S_18 : //default state  set PC
				begin 
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
				end
			
			S_33_0 :
				Mem_OE_out = 1'b0;
			
			S_33_1 :
				Mem_OE_out = 1'b0;
			
			/*S_33_2 :  //
				Mem_OE_out = 1'b0;*/
			
			S_33_3 : 
				begin 
					Mem_OE_out = 1'b0;
					LD_MDR = 1'b1;
				end
			
			S_35 :  //load IR
				begin 
					GateMDR = 1'b1;
					LD_IR = 1'b1;
				end
			PauseIR1: 
				LD_LED = 1'b1;
			PauseIR2: 
				LD_LED = 1'b1;
			
			S_32 :  //ben
				LD_BEN = 1'b1;
			
			S_01 :  //ADD state
				begin 
					SR2MUX = IR_5;
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					SR1MUX = 1'b0;
					DRMUX = 1'b0;
					LD_CC = 1'b1;
				end
			
			S_05 :  //AND state
				begin
					SR2MUX = IR_5;
					ALUK = 2'b01;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					SR1MUX = 1'b0;
					DRMUX = 1'b0;
					LD_CC = 1'b1;
				end
			
			S_09 :  //NOT state
				begin
					ALUK = 2'b10;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					SR1MUX = 1'b0;
					DRMUX = 1'b0;
					LD_CC = 1'b1;
				end
			
			S_06 :  //LDR state  load MAR
				begin
					LD_MAR = 1'b1;
					SR1MUX = 1'b0;
					ADDR1MUX = 1'b0;
					ADDR2MUX = 2'b01;
					GateMARMUX = 1'b1;
				end
			
			S_25_0 :
				begin
					Mem_OE_out = 1'b0;
				end
			
			S_25_1 :  // MDR<- M[MAR]
				begin
					Mem_OE_out = 1'b0;
				end
				
			S_25_2 :  //MDR <- M[MAR]
				begin
					Mem_OE_out = 1'b0;
					LD_MDR = 1'b1;
				end
				
			S_27 :  //DR<-MDR   setCC
				begin
					GateMDR = 1'b1;
					LD_REG = 1'b1;
					DRMUX = 1'b0;
					LD_CC = 1'b1; 
				end
			
			S_07 :  // STR  MAR<- B + off6
				begin
					LD_MAR = 1'b1;
					SR1MUX = 1'b0;
					ADDR1MUX = 1'b0;
					ADDR2MUX = 2'b01;
					GateMARMUX = 1'b1;
				end
				
			S_23 :  //MDR<-SR
				begin
					LD_MDR = 1'b1;
					GateALU = 1'b1;
					SR1MUX = 1'b1;
					ALUK = 2'b11;
				end
				
			S_16_0 :
				begin
					Mem_WE_out = 1'b0;
				end
			
			S_16_1 :  //M[MAR]<-MDR
				begin
					Mem_WE_out = 1'b0;
				end
			
			S_16_2 : 
				begin
					Mem_WE_out = 1'b0;
				end
			
			S_04 :  // JSR   R7<-PC
				begin
					GatePC = 1'b1;
					LD_REG = 1'b1;
					DRMUX = 1'b1;			
				end
			
			S_21 :   //PC<- PC+OFF11
				begin
					ADDR2MUX = 2'b11;
					ADDR1MUX = 1'b1;
					PCMUX = 2'b01;
					LD_PC = 1'b1;
				end

			S_12 :  //JMP  PC<-Base
				begin
					SR1MUX = 1'b0;
					ADDR1MUX = 1'b0;
					ADDR2MUX = 2'b00;
					PCMUX = 2'b01;
					LD_PC = 1'b1;
				end
			
			S_22 :  //BR  PC<-PC + off9
				begin
					ADDR2MUX = 2'b10;
					ADDR1MUX = 1'b1;
					PCMUX = 2'b01;
					LD_PC = 1'b1;
				end
			

			// You need to finish the rest of states.....

			default :;
				/*begin
				Mem_OE_out = 1'b1;
				Mem_WE_out = 1'b1;
				end*/
		endcase
	end 

	 // These should always be active
	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;
	
endmodule
