module Lab5_8_Bit_Multiplier_top_level(
input logic [7:0] S,
input logic Clk,
input logic Reset,
input logic Run,
input logic ClearA_LoadB,

output logic [6:0] AhexU,
output logic [6:0] AhexL,
output logic [6:0] BhexU,
output logic [6:0] BhexL,
output logic [7:0] Aval,
output logic [7:0] Bval,
output logic X

);

/*Inputs
S – logic [7:0]
Clk, Reset, Run, ClearA_LoadB – logic 
Outputs
AhexU, AhexL, BhexU, BhexL – logic [6:0]
Aval, Bval – logic [7:0]
X –logic
*/

logic [8:0] sum_of_ad;
logic Clr_Ld;
logic Shift;
logic Add;
logic Sub;
logic LdA;
logic M0;
logic ClrA;
//logic Bout;

assign  LdA = Add^Sub;
assign M0 = Bval[0];

Control Control(
.Clk(Clk),
.Reset(1'b1^Reset), //active low
.ClearA_LoadB(1'b1^ClearA_LoadB), //active low
.Run(1'b1^Run), //active low
.M(M0),
.Clr_Ld(Clr_Ld), 
.Shift(Shift), 
.Add(Add), 
.Sub(Sub), 
.ClrA(ClrA)
);

adder_9_bits adder_9_bits(
	.A(Aval[7:0]),
	.S(S[7:0]),
	.fn(Sub), //sub from control
	.Sum(sum_of_ad[8:0]) //sum of adder
	//.CO()
);
 
 logic Q;
flip_flop flip_flop(
.Clk(Clk), 
.Load (LdA),
.Reset((1'b1^Reset)|Clr_Ld|ClrA), 
.D(sum_of_ad[8]), //the extented bit from sum
.Q(X)
);


Shift_Reg Shift_Reg(
.Clk(Clk),
.LdA(LdA),
.ClrA_LoadB(Clr_Ld),
.S(S[7:0]),//data from switch
.Data_A(sum_of_ad[7:0]), //data from the 9 bit adder(only using the last 8 bits)
.X(sum_of_ad[8]),
.Shift(Shift),
.Reset(1'b1^Reset),
.ClrA(ClrA),
.ShiftinA(X),
.A(Aval), //output data from register A
.B(Bval), //output data from register B
//.Xout(X),
//.M(M0),
.Shift_Out()

);


//from lab 4
 HexDriver        HexAL (
                        .In0(Aval[3:0]),
                        .Out0(AhexL) );
	 HexDriver        HexBL (
                        .In0(Bval[3:0]),
                        .Out0(BhexL) );
								
	 //When you extend to 8-bits, you will need more HEX drivers to view upper nibble of registers, for now set to 0
	 HexDriver        HexAU (
                        .In0(Aval[7:4]),//more HEX drivers for the fout bits of register A
                        .Out0(AhexU) );	
	 HexDriver        HexBU (
                       .In0(Bval[7:4]), // more HEX drivers for the four bits of register B
                        .Out0(BhexU) );
								
endmodule 