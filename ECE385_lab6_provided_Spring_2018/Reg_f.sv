module Reg_f(
				input logic Clk, RESET, Load,
				input logic [15:0] BUS,
				input logic [2:0] DR, SR1, SR2,
				output logic [15:0] SR1_OUT, SR2_OUT
				//output logic [15:0] Reg02
);

logic [15:0] reg_file[7:0];

//assign Reg02 = reg_file[2];
assign SR1_OUT = reg_file[SR1];
assign SR2_OUT = reg_file[SR2];

always_ff @ (posedge Clk)
begin
		if(RESET)
			begin
			reg_file[0] <= 16'h0000;
			reg_file[1] <= 16'h0000;
			reg_file[2] <= 16'h0000;
			reg_file[3] <= 16'h0000;
			reg_file[4] <= 16'h0000;
			reg_file[5] <= 16'h0000;
			reg_file[6] <= 16'h0000;
			reg_file[7] <= 16'h0000;
			end
		else if (Load)
			begin
			reg_file[DR] <= BUS;
			end
end



endmodule 