module BEN(
			input logic Clk, Reset, Load,
			input logic [2:0]NZP,
			input logic [2:0]IR,
			output logic BEN1			
);

logic out;

always_ff @ (posedge Clk)
begin
	if (Reset == 1'b1)
		BEN1 = 1'b0;
	
	else if (Load == 1'b1)
		BEN1 = out;
	
end

always_comb
begin
	if ((IR[0] == 1 & NZP[0] == 1)|(IR[1] == 1 & NZP[1] == 1)|(IR[2] == 1 & NZP[2] == 1))
		out = 1'b1;
	else
		out = 1'b0;
end

endmodule 