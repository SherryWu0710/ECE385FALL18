
module adder_9_bits(
input [7:0] A, //input for multiplicand
input [7:0] S, //input from switches
input fn, //function select
output logic [8:0] Sum
//output logic CO
);

logic c0, c1, c2, c3, c4, c5, c6, c7;
logic [7:0] SS; //NOT(B)
logic A8, SS8; //sign extension

assign SS = (S^{8{fn}}); //if fn = 1, not B
assign A8 = A[7];
assign SS8 = SS[7];

full_adder FA0(.x(A[0]), .y(SS[0]), .cin(fn), .s(Sum[0]), .cout(c0));  //use series of full_adders to compute a result
full_adder FA1(.x(A[1]), .y(SS[1]), .cin(c0), .s(Sum[1]), .cout(c1));
full_adder FA2(.x(A[2]), .y(SS[2]), .cin(c1), .s(Sum[2]), .cout(c2));
full_adder FA3(.x(A[3]), .y(SS[3]), .cin(c2), .s(Sum[3]), .cout(c3));
full_adder FA4(.x(A[4]), .y(SS[4]), .cin(c3), .s(Sum[4]), .cout(c4));
full_adder FA5(.x(A[5]), .y(SS[5]), .cin(c4), .s(Sum[5]), .cout(c5));
full_adder FA6(.x(A[6]), .y(SS[6]), .cin(c5), .s(Sum[6]), .cout(c6));
full_adder FA7(.x(A[7]), .y(SS[7]), .cin(c6), .s(Sum[7]), .cout(c7));
full_adder FA8(.x(A8), .y(SS8), .cin(c7), .s(Sum[8]), .cout());        //calculate the MSB of the data

endmodule

module full_adder( //full_adder from lab 4
	input x,
	input y,
	input cin,
	output logic s,
	output logic cout
);
	assign s = x ^ y ^ cin; //calculate the current bit
	assign cout = (x & y) | (y & cin) | (cin & x); //calculate the carry out
	
endmodule