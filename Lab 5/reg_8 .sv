module reg_8 (input  logic Clk, Reset, Shift_In, Load, Shift_En,
              input  logic [7:0]  D, //8 bits data need to be stored in register
              output logic Shift_Out, 
				  //output logic M,
              output logic [7:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 8'h0; //if reset, clear data in register
		 else if (Load)  //if load, load data into register
			  Data_Out <= D;
		 else if (Shift_En) //if shift, shift data one bit to the right
		 begin
			  //concatenate shifted in data to the previous left-most 3 bits
			  //note this works because we are in always_ff procedure block
			  Data_Out <= { Shift_In, Data_Out[7:1] }; 
	    end
    end
	
    assign Shift_Out = Data_Out[0];
	// assign M = Data_Out[1];

endmodule  