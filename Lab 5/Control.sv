//from lab 4
//Two-always example for state machine

module Control (
	input  logic Clk, 
	input  logic Reset, 
	input  logic ClearA_LoadB,
	input  logic Run,
	input  logic M,
	
   output logic Clr_Ld,
	output logic Shift, 
	output logic Add, 
	output logic Sub,
	output logic ClrA 
);

    // Declare signals curr_state, next_state of type enum
    // with enum values of A, B, ..., F as the state values
	 // Note that the length implies a max of 23 states, so you will need to bump this up for 8-bits
    enum logic [4:0] {A, CLA, Add1, Add2, Add3, Add4, Add5, Add6, Add7, Shift1, Shift2, Shift3, Shift4, Shift5, Shift6, Shift7,
							 Shift8, Sub1, End}   curr_state, next_state; 

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk or posedge Reset)  
    begin
        if (Reset)
            curr_state <= A; //A as the reset state
        else 
            curr_state <= next_state; //else goes to next state
    end

    // Assign outputs based on state
	always_comb
    begin
			
        unique case (curr_state) 

            A :   if (Run) //start state
							next_state = CLA;      //if Run is activated, go to clear A state
						 else 
							  next_state = A;      //else, stay in this state
				
				CLA : next_state = Add1; //Clear state: clear data in Register A before every running
				
            Add1 :  next_state = Shift1; //add state 1
				
            Shift1 : next_state = Add2; // shift state 1
				
				Add2 :	 next_state = Shift2; // add state 2
				
				Shift2 :	next_state = Add3; //shift state 2
				
				Add3 : 	 next_state = Shift3; //add state 3
				
				Shift3 :  next_state = Add4;  //shift state
							
            Add4 :    next_state = Shift4; //add state
				
				Shift4 :	next_state = Add5; //shift state
							
				Add5 : next_state = Shift5; //add state
				
				Shift5 : next_state = Add6; //shift state
						
				Add6 : next_state = Shift6; //add state
				
				Shift6 : next_state = Add7; //shift state
						
				Add7 : next_state = Shift7; //add state
				
				Shift7 : next_state = Sub1; //shift state
						
				Sub1 : next_state = Shift8; //sub state
				
				Shift8 : next_state = End; //shift state 8
				
				End : if(Run)                    //If buttom Run keeps pressed in this state, stay in this state
							next_state = End;
						else
							next_state = A;         //if Run is not activated, go to start state
				
				
							  
        endcase
   
		  // Assign outputs based on ‘state’
        case (curr_state) 
	   	   A: //start state
	         begin
                 Add = 1'b0;              //idle state, do nothing, clearA and Load B when ClearA_LoadB is activated.
					  Sub = 1'b0;
					  Shift = 1'b0;
					  Clr_Ld = ClearA_LoadB;
					  ClrA = 1'b0;
		      end
				
				CLA:								//only ClrA is activated to clear data in register A and flip_flop
				begin
					Add = 1'b0;
					Sub = 1'b0;
					Shift = 1'b0;
					Clr_Ld = 1'b0;
					ClrA = 1'b1;
				end
				
	   	   Sub1: //sub
		      begin								//When the LSB of register B is 1, do subtraction in register A
					 Add = 1'b0;
					 Shift = 1'b0;
					 Clr_Ld = 1'b0;
					 ClrA = 1'b0;
					 begin
					 if(M)
						Sub = 1'b1;
					 else
						Sub = 1'b0;
					 end
		      end
				
				
				Shift1, Shift2, Shift3, Shift4, Shift5, Shift6, Shift7, Shift8://shift state
				begin										//Only shift is 1 in shift states
					Add = 1'b0;
					Sub = 1'b0;
					Shift = 1'b1;
					Clr_Ld = 1'b0;
					ClrA = 1'b0;
				end
				
				End:										//idle state, do nothing
				begin
					Add = 1'b0;
					Sub = 1'b0;
					Shift = 1'b0;
					Clr_Ld = ClearA_LoadB;
					ClrA = 1'b0;
				end
			
	   	   default:  //add states
		      begin 								//When the LSB of register B is 1, do addition in register A
					 Sub = 1'b0;
					 Shift = 1'b0;
					 Clr_Ld = 1'b0;
					 ClrA = 1'b0;
					 if(M)
					 begin
						Add = 1'b1;
					 end
					 else
					 begin
						Add = 1'b0;
					 end
		      end			
        endcase
    end

endmodule 