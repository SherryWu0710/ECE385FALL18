module Shift_Reg(
	input  logic Clk, //clock
	input  logic LdA, //LoadA
	input  logic ClrA_LoadB, //output Clr_Ld from control unit
	input  logic [7:0] S,  //data in register B
	input  logic [7:0] Data_A, //data in register A
	input  logic X,  //the MSB of sum of A
	input  logic Shift, //output from control unit
	input  logic Reset, //input from switch
	input  logic ClrA, //output from control unit
	input  logic ShiftinA, //output from flip_flop
	
	output logic [7:0] A, //output of register A
	output logic [7:0] B, //output of register B
	//output logic Xout,
	//output logic M,
	output logic Shift_Out //the LSB of register
	
);

logic A_ser_out;

reg_8 FA (.Clk(Clk), .Reset(ClrA_LoadB|Reset|ClrA), .Shift_In(ShiftinA), .Load(LdA), .Shift_En(Shift), .D(Data_A[7:0]), .Shift_Out(A_ser_out), .Data_Out(A[7:0]));
//register of A, add the data from switch when M is 1, shift once evey state
reg_8 FB (.Clk(Clk), .Reset(Reset), .Shift_In(A_ser_out), .Load(ClrA_LoadB), .Shift_En(Shift), .D(S[7:0]), .Shift_Out(), .Data_Out(B[7:0]));
//register of B, shift once every state


endmodule 