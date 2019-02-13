module MUX_four
					#(parameter width = 16)
					(input  logic [width-1:0] d0, d1, d2, d3,
					 input  logic [1:0] s,
					 output logic [width-1:0] y);
					
					always_comb begin
						if(s == 2'b00)
								y = d0;
								
						else if (s == 2'b01)
								y = d1;
								
						else if (s == 2'b10)
								y = d2;
								
						else 
					
								y = d3;
					end
endmodule 