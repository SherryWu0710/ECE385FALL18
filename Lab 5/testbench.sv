module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic Clk;
logic Reset;
logic ClearA_LoadB;
logic Run;
logic [7:0] S;
logic [7:0] Aval;
logic [7:0] Bval; 
logic [6:0] AhexU;
logic [6:0] BhexU;
logic [6:0] AhexL;
logic [6:0] BhexL;
logic [4:0] states;
logic M;
logic X;


// To store expected results
logic [15:0] ans_1a, ans_2b;
				
// A counter to count the instances where simulation results
// do no match with expected results
integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
Lab5_8_Bit_Multiplier_top_level Lab5_8_Bit_Multiplier_top_level(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
Reset = 0;		// Reset the system
ClearA_LoadB = 1; //other buttoms are not pressed
Run = 1;
S = 8'b11111111; //put data in switches

#4 Reset = 1;  //Reset is closed
	
#4 ClearA_LoadB = 0; //ClearA_LoadB is activated, clear the data in registerA and load data in Register B
	
#4 ClearA_LoadB =1; //close ClearA_LoadB
	
#4 S = 8'b11111111; //put the other data in switches

#4 Run = 0; //Run is activated

#10 Run = 1; //Run is closed

#100 ans_1a = (8'b00000000); // Expected result of 1st cycle
    // Aval is expected to be 2h'FE
    // Bval is expected to be the 2h'63
	 ans_2b = (8'b00000001);
    if (Aval != ans_1a)  //If the result is not correct, errorcount plus one
	 ErrorCnt++;
    if (Bval != ans_2b)  //If the result is not correct, errorcount plus one
	 ErrorCnt++;
	 
    



if (ErrorCnt == 0)
	$display("Success!");  // Command line output in ModelSim
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
end
endmodule
