 module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
     logic c4, c8, c12;
	  
	  four_bit_ra S0(.x(A[3:0]), .y(B[3:0]), .cin(1'b0), .s(Sum[3:0]), .cout(c4)); //first one has no carry in just using ripple adder
	  four_bit_carry_select_adder S1(.A(A[7:4]), .B(B[7:4]), .cin(c4), .Sum(Sum[7:4]), .cout(c8)); //four bit in a group to adder to carry select adder
	  four_bit_carry_select_adder S2(.A(A[11:8]), .B(B[11:8]), .cin(c8), .Sum(Sum[11:8]), .cout(c12));
	  four_bit_carry_select_adder S3(.A(A[15:12]), .B(B[15:12]), .cin(c12), .Sum(Sum[15:12]), .cout(CO));
	  
	  
endmodule


//sub-level for four bit carry select adder
module four_bit_carry_select_adder(
	input  logic [3:0] A,
	input  logic [3:0] B,
	input  logic cin,
	output logic [3:0] Sum,
	output logic cout
	
);

	logic [3:0] sum0; //sum for carry in is 0
	logic [3:0] sum1; //sum for carry in is 1
	logic cout0; //carry out for carry in is 0
	logic cout1; //carry out for carry in is 1
	
	four_bit_ra F0(.x(A[3:0]), .y(B[3:0]), .cin(1'b0), .s(sum0[3:0]), .cout(cout0));// for cin = 0
	four_bit_ra F1(.x(A[3:0]), .y(B[3:0]), .cin(1'b1), .s(sum1[3:0]), .cout(cout1));// for cin = 1
	
	always_comb
	begin
	
	cout = (cin)? cout1 : cout0; //if carry in is 0 then choose cout0, otherwise choose cout1
	
	if(cin == 1'b1)
		Sum[3:0] = sum1[3:0]; // if carry in is 1 then pick sum1
	else
		Sum[3:0] = sum0[3:0]; // if carry in is 0 then pick sum0
	end


endmodule 

