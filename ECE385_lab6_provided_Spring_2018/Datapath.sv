module Datapath(
		input logic Clk, Reset,
		input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
		input logic GatePC, GateMDR, GateALU, GateMARMUX,
		input logic ADDR1MUX, DRMUX, SR1MUX, SR2MUX, 
		input logic MIO_EN,  
		input logic [1:0] PCMUX, ADDR2MUX, ALUK, 
		input logic [15:0] MDR_In,
		output logic BEN, 
		output logic [15:0] MAR, MDR, IR, PC,
		output logic [11:0] LED//, Reg02
);

always_ff @ (posedge Clk) //CONTROL for LED
begin
	if(Reset)
			LED <={12{1'b0}};
	else if (LD_LED)
			LED <= IR[11:0];
end 

logic [15:0] BUS; // global bus

logic[15:0] ADDER_OUT, ADDR1MUX_OUT, ADDR2MUX_OUT, PCMUX_OUT, ALU_OUT;
logic[15:0] SR1_OUT, SR2_OUT, SR2MUX_OUT, MDRMUX_OUT;
//logic[3:0] BUSMUX_SELECT;
logic[2:0] DRMUX_OUT, SR1MUX_OUT, NZP_OUT;

assign ADDER_OUT = ADDR1MUX_OUT + ADDR2MUX_OUT;

always_comb
begin
	if(GatePC == 1'b1)
		BUS = PC;
		
	else if(GateMDR == 1'b1)
		BUS = MDR;
		
	else if(GateALU == 1'b1)
		BUS = ALU_OUT;
	
	else if (GateMARMUX)
		BUS = ADDER_OUT;
		
	else
		BUS = 16'hXXXX;
end


MUX_four PC_MUX( //PC MUX
	.d0(PC + 16'h0001),
	.d1(ADDER_OUT),
	.d2(BUS),
	.d3(16'hXXXX),
	.s(PCMUX),
	.y(PCMUX_OUT)
);


Reg_16 PC_Reg(  //PC Reg
	.Clk(Clk),
	.Reset(Reset),
	.Load(LD_PC),
	.Din(PCMUX_OUT),
	.Dout(PC)
);

MUX_two ADDR1_MUX(  //ADDR1 MUX
	.d0(SR1_OUT),
	.d1(PC),
	.s(ADDR1MUX),
	.y(ADDR1MUX_OUT)
);

MUX_four ADDR2_MUX(  //ADDR2 MUX
	.d0(16'h0000),
	.d1({{10{IR[5]}},IR[5:0]}),
	.d2({{7{IR[8]}},IR[8:0]}),
	.d3({{5{IR[10]}},IR[10:0]}),
	.s(ADDR2MUX),
	.y(ADDR2MUX_OUT)
);

Reg_16 MAR_Reg( //MAR Register
	.Clk(Clk),
	.Reset(Reset),
	.Load(LD_MAR),
	.Din(BUS),
	.Dout(MAR)
);

MUX_two MDR_MUX(  //MDR MUX
	.d0(BUS),
	.d1(MDR_In),
	.s(MIO_EN),
	.y(MDRMUX_OUT)
);

Reg_16 MDR_Reg(  //MDR Register
	.Clk(Clk),
	.Reset(Reset),
	.Load(LD_MDR),
	.Din(MDRMUX_OUT),
	.Dout(MDR)
);

Reg_16 IR_Reg(  //IR Register
	.Clk(Clk),
	.Reset(Reset),
	.Load(LD_IR),
	.Din(BUS),
	.Dout(IR)
);

ALU ALU(        //ALU module
	.A(SR1_OUT),
	.B(SR2MUX_OUT),
	.s(ALUK),
	.result(ALU_OUT)
);

NZP NZP( 		//NZP module
	.bus(BUS),
	.Clk(Clk),
	.Reset(Reset),
	.Load(LD_CC),
	.NZP_out(NZP_OUT)	
);

BEN BEN1(      //BEN
	.Clk(Clk), 
	.Reset(Reset), 
	.Load(LD_BEN),
	.NZP(NZP_OUT),
	.IR(IR[11:9]),
	.BEN1(BEN)
);

MUX_two #(3) DR_MUX( //Destination selector
	.d0(IR[11:9]),
	.d1(3'b111),
	.s(DRMUX),
	.y(DRMUX_OUT)
);

MUX_two #(3) SR1_MUX( //SR1 selector
	.d0(IR[8:6]),
	.d1(IR[11:9]),
	.s(SR1MUX),
	.y(SR1MUX_OUT)
);

MUX_two SR2_MUX(		//SR2 selector
	.d0(SR2_OUT),
	.d1({{11{IR[4]}},IR[4:0]}),
	.s(SR2MUX),
	.y(SR2MUX_OUT)
);

Reg_f Reg_f(  		//Register File
	.Clk(Clk),
	.RESET(Reset),
	.Load(LD_REG),
	.BUS(BUS),
	.DR(DRMUX_OUT),
	.SR1(SR1MUX_OUT),
	.SR2(IR[2:0]),
	.SR1_OUT(SR1_OUT),
	.SR2_OUT(SR2_OUT)
	//.Reg02(Reg02)
);


 endmodule 