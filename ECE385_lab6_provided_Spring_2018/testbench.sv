module testbench();
	timeunit 10ns;
	timeprecision 1ns;
	
//input logic
	logic Clk;
	logic Reset;
	logic Run;
	logic Continue;
	logic [15:0] S;
	logic [11:0] LED;
   logic [6:0] HEX0;
	logic [6:0] HEX1;
	logic [6:0] HEX2;
	logic [6:0] HEX3;
	logic [6:0] HEX4;
	logic [6:0] HEX5;
	logic [6:0] HEX6;
	logic [6:0] HEX7;
   logic CE;
	logic UB;
	logic LB;
	logic OE;
	logic WE;
   logic [19:0] ADDR;
   wire [15:0] Data;


//set top-level	
lab6_toplevel lab6_toplevel(.*);
logic [15:0] IR;
//logic [15:0] mdr_in;
//logic [15:0] data_from_sram;
//logic [15:0] mar;
logic [15:0] PC;
logic [15:0] Reg0;
logic [15:0] Reg1;
logic [15:0] Reg2;
logic [15:0] Reg7;
logic [15:0] ALU_out;
logic [15:0] ALU_A;
logic [15:0] ALU_B;
logic [1:0] ALU_S;

always @*
begin: INITERAL_SIG_MONITOR
IR = lab6_toplevel.my_slc.Datapath.IR_Reg.Dout;
PC = lab6_toplevel.my_slc.Datapath.PC_Reg.Dout;
Reg0 = lab6_toplevel.my_slc.Datapath.Reg_f.reg_file[0];
Reg1 = lab6_toplevel.my_slc.Datapath.Reg_f.reg_file[1];
Reg2 = lab6_toplevel.my_slc.Datapath.Reg_f.reg_file[2];
Reg7 = lab6_toplevel.my_slc.Datapath.Reg_f.reg_file[7];
ALU_out = lab6_toplevel.my_slc.Datapath.ALU_OUT;
ALU_A = lab6_toplevel.my_slc.Datapath.ALU.A;
ALU_B = lab6_toplevel.my_slc.Datapath.ALU.B;
ALU_S = lab6_toplevel.my_slc.Datapath.ALU.s;

//mdr_in = lab6_toplevel.my_slc.memory_subsystem.Data_to_CPU;
//data_from_sram = lab6_toplevel.my_slc.tr0.Data_read;
//mar = lab6_toplevel.my_slc.Datapath.MAR;
//IR = lab6_toplevel.my_slc.Datapath.regIR.Dout;
//PC = lab6_toplevel.my_slc.Datapath.regPC.Dout;
//ALU_out = lab6_toplevel.my_slc.Datapath.ALU_OUT;
//ALU_A = lab6_toplevel.my_slc.Datapath.ALU1.A;
//ALU_B = lab6_toplevel.my_slc.Datapath.ALU1.B;
//ALU_S = lab6_toplevel.my_slc.Datapath.ALU1.s;
end

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS

Reset = 0;
Run = 1;
Continue = 1;
S = 16'h0003;

#4 Reset = 1;

#4 Run = 0;

#4 Run = 1;



#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;

#10 Continue = 0;

#30 Continue = 1;


end

endmodule 