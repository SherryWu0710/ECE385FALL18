module NZP(
				input  logic [15:0]bus,
				input  logic Clk, Reset, Load,
				output logic [2:0] NZP_out
);

always_ff @ (posedge Clk)
begin
	if (Load == 1'b1)
	begin
		if (bus == 16'h0000)
			NZP_out = 3'b010;
			
		else if (bus[15] == 1'b1)
			NZP_out = 3'b100;
			
		else if (bus[15] == 1'b0)
			NZP_out = 3'b001;
	end
	
	else if (Reset == 1'b1)
		begin
		NZP_out = 3'b000;
		end
	
end

endmodule 