module flip_flop ( //From lecture
	input Clk, Load, Reset, D,//input clock, LoadA, Reset, D
	output logic Q 
	);
	
always_ff @ (posedge Clk or posedge Reset)
begin
	if (Reset)
		Q <= 1'b0; //if reset, clear the flip_flop
	else
	if (Load) //if load, D becomes output
		Q <= D;
	else //in most cases this is redundant, maintaining Q inferred
		Q <= Q; //else, static state
end

endmodule 