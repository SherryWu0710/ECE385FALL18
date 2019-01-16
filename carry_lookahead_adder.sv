module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
     
	  logic c4, c8, c12;
	  logic pg0, pg1, pg2, pg3;
	  logic gg0, gg1, gg2, gg3;
	  
	  // c4  = gg0 | (0 & pg0);
	  // c8  = gg1 | (gg0 & pg1) | (0 & pg0 & pg1);
	  // c12 = gg2 | (gg1 & pg2) | (gg0 & pg2 & pg1) | (0 & pg2 & pg1 & pg0);
	  // CO  = gg3 | (gg2 & pg3) | (gg1 & pg3 & pg2) | (gg0 & pg3 & pg2 & pg0) | (0 & pg3 & pg2 & pg1 & pg0);
	 
	 //first input for cin should be 0
	 //separate into four group, four bits one group
	 //the carryout of the previous group should be the carry in for next group
	 //the final carry out should be CO 
	  
	  four_bit_lookahead_adder F0(.x(A[3 : 0]), .y(B[3 : 0]), .cin(1'b0), .s(Sum[3 : 0]), .p(pg0), .g(gg0), .cout( c4));
	  four_bit_lookahead_adder F1(.x(A[7 : 4]), .y(B[7 : 4]), .cin( c4), .s(Sum[7 : 4]), .p(pg1), .g(gg1), .cout( c8));
	  four_bit_lookahead_adder F2(.x(A[11: 8]), .y(B[11: 8]), .cin( c8), .s(Sum[11: 8]), .p(pg2), .g(gg2), .cout(c12));
	  four_bit_lookahead_adder F3(.x(A[15:12]), .y(B[15:12]), .cin(c12), .s(Sum[15:12]), .p(pg3), .g(gg3), .cout( CO));
	  
	  
	  
endmodule 

//detail for sub-level four bit lookahead adder
module four_bit_lookahead_adder(
	input  logic [3:0] x, //four bit for input
	input  logic [3:0] y,
	input  logic 	  cin,
	output logic [3:0] s, //four bit for sum
	output logic 		 p,
	output logic 		 g,
	output logic    cout //one carry out
);

	logic c0, c1, c2, c3;
	logic g0, g1, g2, g3;
	logic p0, p1, p2, p3;
	
	assign p  = (p0 & p1 & p2 & p3);  
	assign g  = (g3 | (g2 & p3) | (g1 & p2 & p3) | (g0 & p3 & p2 & p1)); //according to lab manual instruction
	// c0 = cin;
	// c1 = (cin & p0) |g0; 
	// c2 = (cin & p0 & p1) | (g0 & p1) | g1;
	// c3= (cin & p0 & p1 & p2) | (g0 & p1 & p2) | (g1 & p2) | g2;
	
	// cout = (cin & p0 & p1 & p2 & p3) | (g0 & p1 & p2 & p3) | (g1 & p2 & p3) |(g2 & p3)| g3;
	
	//separate each bit into next sub-level
	//the carry out of previous should be the carry in of the next
	
	one_bit_lookahead_adder A0(.x(x[0]), .y(y[0]), .z(cin), .p(p0), .g(g0), .s(s[0]), .cout(c0));
	one_bit_lookahead_adder A1(.x(x[1]), .y(y[1]), .z(c0),  .p(p1), .g(g1), .s(s[1]), .cout(c1));
	one_bit_lookahead_adder A2(.x(x[2]), .y(y[2]), .z(c1),  .p(p2), .g(g2), .s(s[2]), .cout(c2));
	one_bit_lookahead_adder A3(.x(x[3]), .y(y[3]), .z(c2),  .p(p3), .g(g3), .s(s[3]), .cout(cout));
	
	
	
endmodule
	
//detail for sub-level one bit adder

module one_bit_lookahead_adder(
	input x,
	input y,
	input z, //cin
	output logic p,
	output logic g,
	output logic s,
	output logic cout
);

	assign g = x&y;
	assign p = x^y;
	assign cout = g|(p&z);
	assign s = z^x^y; //according to instruction of lab manual

	
endmodule

