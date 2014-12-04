/*
 * Caminho de Dados do Processador Multiciclo
 *
 */
 
module MIPS (
// Inputs e clocks
input wire iCLK, iCLK50, iRST,
input wire [4:0] iRegDispSelect,
input wire [31:0] iInitialPC,
input wire [31:0] iwAudioCodecData,
input [7:0] iPendingInterrupt,

// Para testes
output wire [31:0] oPC, oRegDisp, owMemAddress, owMemWriteData, owMemReadData, oFPRegDisp,
output wire [1:0] oALUOp, oALUSrcA,
output wire [2:0] oALUSrcB, oPCSource,
output wire oIRWrite, oMemWrite, oMemRead, oIorD, oPCWrite, oPCWriteBEQ, oPCWriteBNE,
oRegWrite, oRegDst,
output wire [5:0] owControlState,
output wire [5:0] oOpcode, oFunct,
output wire [7:0] oFPUFlagBank,
output wire [31:0] oDebug, oInstr,


////////////////////////	SRAM Interface	////////////////////////
inout	[31:0]	SRAM_DQ,				//	SRAM Data Bus 32 Bits
output	[18:0]	oSRAM_A,				//	SRAM Address bus 21 Bits
output			oSRAM_ADSC_N,       	//	SRAM Controller Address Status 	
output			oSRAM_ADSP_N,           //	SRAM Processor Address Status
output			oSRAM_ADV_N,            //	SRAM Burst Address Advance
output	[3:0]	oSRAM_BE_N,             //	SRAM Byte Write Enable
output			oSRAM_CE1_N,        	//	SRAM Chip Enable
output			oSRAM_CE2,          	//	SRAM Chip Enable
output			oSRAM_CE3_N,        	//	SRAM Chip Enable
output			oSRAM_CLK,              //	SRAM Clock
output			oSRAM_GW_N,         	//  SRAM Global Write Enable
output			oSRAM_OE_N,         	//	SRAM Output Enable
output			oSRAM_WE_N,         	//	SRAM Write Enable

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)

output [31:0] oRegDispCOP0,
output oCOP0Interrupted,
output [4:0] oCOP0ExcCode,				
output wire oCOP0InterruptEnable,
output reg omouse_keyboard,oPS2_ENABLE
);


//Adicionado no semestre 2014/1 para os load/stores
wire [2:0] wLoadCase;
wire [1:0] wWriteCase;
wire [3:0] wByteEnabler;
wire [31:0] wTreatedToRegister;
wire [31:0] wTreatedToMemory;
wire [1:0]	wLigaULA_PASSADA;
reg [1:0]	ULA_PASSADA; /*em um ciclo a gente puxa o dado da memoria e no segundo a gente escreve. Eu preciso saber
o resultado passado no proximo ciclo, quando eu vou selecionar o que guardar.*/
assign wLigaULA_PASSADA = ULA_PASSADA;

/*
 * Local registers
 *
 * Registers are named in camel case and use shortcuts to describe each word
 * in the full name as defined by the COD datapath.
 */
reg [31:0] A, B, MDR, IR, PC, ALUOut, RegTimerHI, RegTimerLO ;
wire [31:0] RandInt;
reg [63:0] StartTime;  

/*
 * Local FPU registers
 */
 
reg [31:0] FP_A, FP_B, FPALUOut;
 
// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
/*
 * Local COP0 registers
 */
 
reg [31:0] COP0_A, PC_original;
reg ALUoverflow, FPALUoverflow, FPALUunderflow, FPALUnan;

/* 
 * Local wires
 *
 * Wires are named after the named signals as defined by the COD.
 * Wires that are unnamed in the COD are named as 'w' followed by a short
 * description.
 */
wire [5:0] wOpcode, wFunct;
wire [4:0] wRS, wRT, wRD, wShamt, wWriteRegister, wRtorRd;
wire IRWrite, MemtoReg, MemWrite, MemRead, IorD, PCWrite, PCWriteBEQ, PCWriteBNE,
	RegWrite, RegDst, wALUZero, wALUOverflow, SleepWrite, SleepDone, Random, RtorRd, ClearJAction,
	JReset;
wire [1:0] ALUOp, ALUSrcA;
wire [2:0] ALUSrcB, PCSource, Store;
wire [4:0] wALUControlSignal;
wire [31:0] wALUMuxA, wALUMuxB, wALUResult, wImmediate, wuImmediate, wLabelAddress,
	wReadData1, wReadData2, wJumpAddress, wRegWriteData, wMemorALU, wMemWriteData, wMemReadData,
	wMemAddress, wPCMux, wRegV0, wRandInt, wTimerOutHI, wTimerOutLO, wMARSorALUOut;
wire [63:0] wTimerOut, wEndTime;

/*
 * Local FP wires
 */
wire [7:0] wFPUFlagBank;
wire [4:0] wFs, wFt, wFd, wFmt, wFPWriteRegister;
wire [3:0] wFPALUControlSignal;
wire [2:0] wBranchFlagSelector, wFPFlagSelector;
wire [31:0] wFPALUResult, wFPWriteData, wFPReadData1, wFPReadData2, wFPRegDisp;
wire wFPOverflow, wFPZero, wFPUnderflow, wSelectedFlagValue, wFPNan, wBranchTouF, wCompResult;
/* FPU Control Signals*/
wire [1:0] FPDataReg, FPRegDst;
wire FPPCWriteBc1t, FPPCWriteBc1f, FPRegWrite, FPU2Mem, FPFlagWrite;

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
/*
 * Local COP0 wires
 */
wire [31:0] wCOP0DataReg, wCOP0ReadData;
wire [7:0] wCOP0InterruptMask;
wire PCOriginalWrite, COP0RegWrite, COP0Eret, COP0ExcOccurred, COP0BranchDelay, COP0Interrupted, wCOP0UserMode, wCOP0ExcLevel;
wire [4:0] COP0ExcCode;

/*
 * Wires assignments
 *
 * 2 to 1 multiplexers are also handled here.
 */
assign wOpcode	= IR[31:26];
assign wRS		= IR[25:21];
assign wRT		= IR[20:16];
assign wRD		= IR[15:11];
assign wShamt	= IR[10:6];
assign wFunct		= IR[5:0];
assign wImmediate	= {{16{IR[15]}}, IR[15: 0]};
assign wuImmediate	= {16'b0, IR[15: 0]};
assign wLabelAddress	= {{14{IR[15]}}, IR[15: 0], 2'b0};
assign wJumpAddress	= {PC[31:28], IR[25:0], 2'b0};

wire [31:0] wRegA0;
assign wEndTime = StartTime + ((32'd50000)*wRegA0);
assign wTimerOut = {wTimerOutHI, wTimerOutLO};
assign SleepDone = (wEndTime < wTimerOut);

assign wMemWriteData	= FPU2Mem ? FP_B : B;
assign wRtorRd			= RegDst ? wRD : wRT;
assign wMemorALU		= MemtoReg ? MDR : ALUOut;
assign wMemAddress	= IorD ? ALUOut : PC;

assign wRandInt[0] = wTimerOut[12];
assign wRandInt[1] = wTimerOut[25];
assign wRandInt[2] = wTimerOut[18];
assign wRandInt[3] = wTimerOut[29];
assign wRandInt[4] = wTimerOut[23];
assign wRandInt[5] = wTimerOut[26];
assign wRandInt[6] = wTimerOut[24];
assign wRandInt[7] = wTimerOut[28];
assign wRandInt[8] = wTimerOut[31];
assign wRandInt[9] = wTimerOut[10];
assign wRandInt[10] = wTimerOut[30];
assign wRandInt[11] = wTimerOut[17];
assign wRandInt[12] = wTimerOut[21];
assign wRandInt[13] = wTimerOut[11];
assign wRandInt[14] = wTimerOut[20];
assign wRandInt[15] = wTimerOut[9];
assign wRandInt[16] = wTimerOut[16];
assign wRandInt[17] = wTimerOut[8];
assign wRandInt[18] = wTimerOut[13];
assign wRandInt[19] = wTimerOut[27];
assign wRandInt[20] = wTimerOut[15];
assign wRandInt[21] = wTimerOut[4];
assign wRandInt[22] = wTimerOut[7];
assign wRandInt[23] = wTimerOut[19];
assign wRandInt[24] = wTimerOut[22];
assign wRandInt[25] = wTimerOut[6];
assign wRandInt[26] = wTimerOut[14];
assign wRandInt[27] = wTimerOut[5];
assign wRandInt[28] = wTimerOut[1];
assign wRandInt[29] = wTimerOut[3];
assign wRandInt[30] = wTimerOut[0];
assign wRandInt[31] = wTimerOut[2];

assign RandInt = wRandInt ^ PC;				

/* Floating Point wires assignments*/
assign wFs = IR[15:11];
assign wFt = IR[20:16];
assign wFd = IR[10:6];
assign wFmt = IR[25:21];
assign wBranchFlagSelector = IR[20:18];
assign wSelectedFlagValue = wFPUFlagBank[wBranchFlagSelector];
assign wFPFlagSelector = IR[10:8];
assign wBranchTouF = IR[16];

/* Output wires */
assign oPC	= PC;
assign oALUOp	= ALUOp;
assign oPCSource	= PCSource;
assign oALUSrcB	= ALUSrcB;
assign oIRWrite	= IRWrite;
assign oMemWrite	= MemWrite;
assign oMemRead	= MemRead;
assign oIorD	= IorD;
assign oPCWrite	= PCWrite;
assign oALUSrcA	= ALUSrcA;
assign oPCWriteBEQ	= PCWriteBEQ;
assign oPCWriteBNE	= PCWriteBNE;
assign oRegWrite	= RegWrite;
assign oRegDst	= RegDst;
assign owMemAddress	= wMemAddress;
assign owMemWriteData	= wMemWriteData;
assign owMemReadData = wMemReadData;
assign oOpcode = wOpcode;
assign oFunct = wFunct;
assign oInstr = IR;
assign oFPUFlagBank = wFPUFlagBank;

assign oDebug = wWriteCase;

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
assign wCOP0DataReg = COP0ExcOccurred ? PC_original : B;
assign oCOP0Interrupted = COP0Interrupted;
assign oCOP0ExcCode = COP0ExcCode;

/*
 * Processor initial state
 */
initial
begin
	PC	<= iInitialPC;
	IR	<= 32'b0;
	ALUOut	<= 32'b0;
	MDR <= 32'b0;
	A <= 32'b0;
	B <= 32'b0;
	FP_A <= 32'b0;
	FP_B <= 32'b0;
	FPALUOut <= 32'b0;
	
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	COP0_A <= 32'b0;
	PC_original <= iInitialPC;
	ALUoverflow <= 1'b0;
	FPALUoverflow <= 1'b0;
	FPALUunderflow <= 1'b0;
	FPALUnan <= 1'b0;
end

/*
 * Clocked events
 *
 * Registers in the Datapath outside any modules are written here.
 */
always @(posedge iCLK)
begin
	if (iRST)
	begin
		PC	<= iInitialPC;
		IR	<= 32'b0;
		ALUOut	<= 32'b0;
		MDR <= 32'b0;
		A <= 32'b0;
		B <= 32'b0;
		FP_A <= 32'b0;
		FP_B <= 32'b0;
		FPALUOut <= 32'b0;
		
		// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
		COP0_A <= 32'b0;
		PC_original <= iInitialPC;
		ALUoverflow <= 1'b0;
		FPALUoverflow <= 1'b0;
		FPALUunderflow <= 1'b0;
		FPALUnan <= 1'b0;
	end
	else
	begin
		/* Unconditional */
		
		ALUOut	<= wALUResult;
		A	<= wReadData1;
		B	<= wReadData2;
		MDR	<= wMemReadData;
		
		FPALUOut <= wFPALUResult;
		FP_A <= wFPReadData1;
		FP_B <= wFPReadData2;
		
		// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
		COP0_A <= wCOP0ReadData;
		ALUoverflow <= wALUOverflow;
		FPALUoverflow <= wFPOverflow;
		FPALUunderflow <= wFPUnderflow;
		FPALUnan <= wFPNan;
		
		/* Conditional */
		
		if (PCWrite || (PCWriteBEQ && wALUZero) || (PCWriteBNE && ~wALUZero) || (FPPCWriteBc1t && wSelectedFlagValue) || (FPPCWriteBc1f && ~wSelectedFlagValue))
		begin
			PC	<= wPCMux;
			
			// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
			if (PCOriginalWrite)
				PC_original <= wPCMux;
		end
		if (IRWrite)
		begin
			IR	<= wMemReadData;
		end
		
		if (Store == 3'd2)
			RegTimerLO <= wTimerOutLO;
		if (Store == 3'd3)
			RegTimerHI <= wTimerOutHI;

		if(SleepWrite)
		begin
			StartTime[31:0]  <= wTimerOutLO;
			StartTime[63:32] <= wTimerOutHI;
		end
		
		//2014, detecta que e um load ou write que nao precisa do resultado passado da ula passada
		if(wLoadCase==0)
			ULA_PASSADA <= wMemAddress[1:0];
		
	end
end

//Aqui eu vou guardar o finzinho 


/*
 * Modules instantiation
 */

/* Control module - State Machine*/
Control Cont0 (
	.iCLK(iCLK),
	.iRST(iRST),
	.iOp(wOpcode),
	.iFmt(wFmt),
	.iFt(wBranchTouF),
	.iFunct(wFunct),
	.iV0(wRegV0[5:0]),
	.iSleepDone(SleepDone),
	.oIRWrite(IRWrite),
	.oMemtoReg(MemtoReg),
	.oMemWrite(MemWrite),
	.oMemRead(MemRead),
	.oIorD(IorD),
	.oPCWrite(PCWrite),
	.oPCWriteBEQ(PCWriteBEQ),
	.oPCWriteBNE(PCWriteBNE),
	.oPCSource(PCSource),
	.oALUOp(ALUOp),
	.oALUSrcB(ALUSrcB),
	.oALUSrcA(ALUSrcA),
	.oRegWrite(RegWrite),
	.oRegDst(RegDst),
	.oState(owControlState),
	.oStore(Store),
	.oSleepWrite(SleepWrite),
	.oFPDataReg(FPDataReg),
	.oFPRegDst(FPRegDst),
	.oFPPCWriteBc1t(FPPCWriteBc1t),
	.oFPPCWriteBc1f(FPPCWriteBc1f),
	.oFPRegWrite(FPRegWrite),
	.oFPFlagWrite(FPFlagWrite),
	.oFPU2Mem(FPU2Mem),
	
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	.iCOP0ALUoverflow(ALUoverflow),
	.iCOP0FPALUoverflow(FPALUoverflow),
	.iCOP0FPALUunderflow(FPALUunderflow),
	.iCOP0FPALUnan(FPALUnan),
	.iCOP0UserMode(wCOP0UserMode),
	.iCOP0ExcLevel(wCOP0ExcLevel),
	.iCOP0PendingInterrupt(wCOP0InterruptMask),
	.oCOP0PCOriginalWrite(PCOriginalWrite),
	.oCOP0RegWrite(COP0RegWrite),
	.oCOP0Eret(COP0Eret),
	.oCOP0ExcOccurred(COP0ExcOccurred),
	.oCOP0BranchDelay(COP0BranchDelay),
	.oCOP0ExcCode(COP0ExcCode),
	.oCOP0Interrupted(COP0Interrupted),
	
	//adicionado em 1/2014
	.oLoadCase(wLoadCase),
	.oWriteCase(wWriteCase)
);

/* Register bank module */
Registers Reg0 (
	.iCLK(iCLK),
	.iCLR(iRST),
	.iReadRegister1(wRS),
	.iReadRegister2(wRT),
	.iWriteRegister(wWriteRegister),
	.iWriteData(wTreatedToRegister),
	.iRegWrite(RegWrite),
	.oReadData1(wReadData1),
	.oReadData2(wReadData2),
	.iRegDispSelect(iRegDispSelect),
	.oRegDisp(oRegDisp),
	.oRegA0(wRegA0),
	.oRegV0(wRegV0)
	);
	
// Mux WriteReg	
always @(*)
	case (Store)
		3'd0: wWriteRegister <= wRtorRd;  //Normal mode
		3'd1: wWriteRegister <= 5'd31;    //$RA  Jal
		3'd2: wWriteRegister <= 5'd04;    //$a0 Store timer LO
		3'd3: wWriteRegister <= 5'd05;    //$a0 Store timer HI
		3'd4: wWriteRegister <= 5'd04;    //$a0 Store Random
		3'd5: wWriteRegister <= wRT;      //mfc1
		3'd6: wWriteRegister <= wRT;      //mfc0 - feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
		3'd7: wWriteRegister <= 5'd00;    //Empty slot
	endcase
		
/* WriteRegister 8 to 1 multiplexer module 
Mult8to1 Mult8to1WriteReg (
	.i0(wRtorRd),		//Normal mode
	.i1(5'd31),			//$RA  Jal
	.i2(5'd04),			//$a0 Store timer LO
	.i3(5'd05),			//$a1 Store timer HI
	.i4(5'd04),			//$a0 Store Random
	.i5(wRT),			//mfc1
	.i6(wRT),			//mfc0 - feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	.i7(5'd00),			//Empty slot
	.iSelect(Store),
	.oSelected(wWriteRegister)
	);*/

// Mux WriteData
always @(*)
	case (Store)
		3'd0: wRegWriteData <= wMemorALU;	//Normal mode
		3'd1: wRegWriteData <= PC;			// $RA Jal
		3'd2: wRegWriteData <= RegTimerLO;	//Store timer LO
		3'd3: wRegWriteData <= RegTimerHI;	//Store timer HI
		3'd4: wRegWriteData <= RandInt;		//Store Random
		3'd5: wRegWriteData <= FP_A;		//mfc1
		3'd6: wRegWriteData <= COP0_A;		//mfc0 - feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
		3'd7: wRegWriteData <= 32'd0;    //Empty slot
	endcase
	
/* WriteData 8 to 1 multiplexer module 
Mult8to1 Mult8to1WriteData (
	.i0(wMemorALU),		//Normal mode
	.i1(PC),			// $RA Jal
	.i2(RegTimerLO),	//Store timer LO
	.i3(RegTimerHI),	//Store timer HI
	.i4(RandInt),		//Store Random
	.i5(FP_A),			//mfc1
	.i6(COP0_A),		//mfc0 - feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	.i7(32'd0),			//Empty slot
	.iSelect(Store),
	.oSelected(wRegWriteData)
	);*/

/* Arithmetic Logic Unit module */
ALU ALU0 (
	.iCLK(iCLK),
	.iRST(iRST),
	.iA(wALUMuxA),
	.iB(wALUMuxB),
	.iShamt(wShamt),
	.iControlSignal(wALUControlSignal),
	.oZero(wALUZero),
	.oALUresult(wALUResult),
	.oOverflow(wALUOverflow)
	);

/* Arithmetic Logic Unit control module */
ALUcontrol ALUcont0 (
	.iFunct(wFunct),
	.iOpcode(wOpcode),
	.iALUOp(ALUOp),
	.oControlSignal(wALUControlSignal)
	);


// Mux ALU input 'A'
always @(*)
	case (ALUSrcA)
		2'd0: wALUMuxA <= PC;
		2'd1: wALUMuxA <= A;
		default:  wALUMuxA <= 32'd0;
	endcase


/* ALU input 'A' 4 to 1 multiplexer module 
Mult4to1 Mult4to1ALUA0 (
	.i0(PC),
	.i1(A),
	.i2(32'd0), //slot livre
	.i3(32'd0), //slot livre
	.iSelect(ALUSrcA),
	.oSelected(wALUMuxA)
	);*/

// Mux ALU input 'B'
always @(*)
	case (ALUSrcB)
		3'd0: wALUMuxB <= B;
		3'd1: wALUMuxB <= 32'd4;
		3'd2: wALUMuxB <= wImmediate;
		3'd3: wALUMuxB <= wLabelAddress;
		3'd4: wALUMuxB <= wuImmediate;
		default: wALUMuxB <= 32'd0;
	endcase
	

/* ALU input 'B'8 to 1 multiplexer module 
Mult8to1 Mult8to1ALUB0 (
	.i0(B),	
	.i1(32'd4),
	.i2(wImmediate),
	.i3(wLabelAddress),
	.i4(wuImmediate),
	.i5(32'd0), //slot livre
	.i6(32'd0), //slot livre
	.i7(32'd0), //slot livre
	.iSelect(ALUSrcB),
	.oSelected(wALUMuxB)
	);*/


// Mux OrigPC
always @(*)
	case (PCSource)
		3'd0: wPCMux <= wALUResult;		//For PC <= PC + 4
		3'd1: wPCMux <= ALUOut;			//For BEQ, BNE, BC1T and BC1F
		3'd2: wPCMux <= wJumpAddress;	//For Jump and Jal
		3'd3: wPCMux <= A;				//For Jr
		3'd4: wPCMux <= BEGINNING_KTEXT;	//For syscall
		3'd5: wPCMux <= wCOP0ReadData-4; //+32'h4),	//eret - feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)  PCgambs-4 ???
		default: wPCMux <= 32'd0;
	endcase


/* Program Counter 8 to 1 multiplexer module 
Mult8to1 Mult8to1PC0 (
	.i0(wALUResult),		//For PC <= PC + 4
	.i1(ALUOut),			//For BEQ, BNE, BC1T and BC1F
	.i2(wJumpAddress),	//For Jump and Jal
	.i3(A),					//For Jr
	.i4(BEGINNING_KTEXT),	//For syscall
	.i5(wCOP0ReadData-4), //+32'h4),	//eret - feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)  PCgambs-4 ???
	.i6(32'd0),				//slot livre	
	.i7(32'd0),				//slot livre
	.iSelect(PCSource),
	.oSelected(wPCMux)
	);*/


WriteTreatment WriteTreatmentUnit (
	.iData(wMemWriteData),
	.iTermination(wMemAddress[1:0]),
	.iWriteCase(wWriteCase),
	.oData(wTreatedToMemory),
	.oByteEnabler(wByteEnabler)
);

/* RAM Memory block module */
Memory MemRAM (
	.iCLK(iCLK),
	.iCLKMem(iCLK50),
	.iByteEnable(wByteEnabler),			//1/2014
	.iAddress(wMemAddress),
	.iWriteData(wTreatedToMemory),		//1/2014
	.iMemRead(MemRead),
	.iMemWrite(MemWrite),
	.oMemData(wMemReadData),
	.iwAudioCodecData(iwAudioCodecData),
	.omouse_keyboard(omouse_keyboard),
	.oPS2_ENABLE(oPS2_ENABLE),
	//Adicionado em 1/2014
	.SRAM_DQ(SRAM_DQ), 				// SRAM Data Bus 32 Bits
	.oSRAM_A(oSRAM_A), 				// SRAM Address bus 21 Bits
	.oSRAM_ADSC_N(oSRAM_ADSC_N), 	// SRAM Controller Address Status 
	.oSRAM_ADSP_N(oSRAM_ADSP_N),	// SRAM Processor Address Status
	.oSRAM_ADV_N(oSRAM_ADV_N),		// SRAM Burst Address Advance
	.oSRAM_BE_N(oSRAM_BE_N),		// SRAM Byte Write Enable
	.oSRAM_CE1_N(oSRAM_CE1_N),		// SRAM Chip Enable
	.oSRAM_CE2(oSRAM_CE2),			// SRAM Chip Enable
	.oSRAM_CE3_N(oSRAM_CE3_N),		// SRAM Chip Enable
	.oSRAM_CLK(oSRAM_CLK),			// SRAM Clock
	.oSRAM_GW_N(oSRAM_GW_N),		// SRAM Global Write Enable
	.oSRAM_OE_N(oSRAM_OE_N),		// SRAM Output Enable
	.oSRAM_WE_N(oSRAM_WE_N)			// SRAM Write Enable	
	);

LoadTreatment LoadTreatmentUnit (
	.iData(wRegWriteData),
	.iLoadCase(wLoadCase),
	.iTerminacao(wLigaULA_PASSADA),
	.oData(wTreatedToRegister)
);
	
	

/* Floating Point register bank module*/
FPURegisters FPURegBank (
	.iCLK(iCLK),
	.iCLR(iRST),
	.iReadRegister1(wFs),
	.iReadRegister2(wFt),
	.iWriteRegister(wFPWriteRegister),
	.iWriteData(wFPWriteData),
	.iRegWrite(FPRegWrite),
	.oReadData1(wFPReadData1),
	.oReadData2(wFPReadData2),
	.iRegDispSelect(iRegDispSelect),
	.oRegDisp(oFPRegDisp)
);


// Mux FPRegDest
always @(*)
	case (FPRegDst)
		2'd0: wFPWriteRegister <= wFd;	//For normal, FR instructions
		2'd1: wFPWriteRegister <= wFs;	//For mtc1
		2'd2: wFPWriteRegister <= wFt;	//For lwc1
		default:  wFPWriteRegister <= 5'd0;
	endcase


/* Register to be written - FPU Registers Bank
Mult4to1 FPRegDstMultiplexer (
	.i0(wFd),	//For normal, FR instructions
	.i1(wFs),	//For mtc1
	.i2(wFt),	//For lwc1
	.i3(5'b0),
	.iSelect(FPRegDst),
	.oSelected(wFPWriteRegister)
);*/


// Mux FPDataReg
always @(*)
	case (FPDataReg)
		2'd0: wFPWriteData <= FPALUOut;
		2'd1: wFPWriteData <= MDR;
		2'd2: wFPWriteData <= B;
		2'd3: wFPWriteData <= FP_A;
	endcase

/* Data input - FPU Registers Bank
Mult4to1 FPWriteDataMultiplexer (
	.i0(FPALUOut),
	.i1(MDR),
	.i2(B),
	.i3(FP_A),
	.iSelect(FPDataReg),
	.oSelected(wFPWriteData)
);*/

/* Floating Point ALU*/
ula_fp FPALUUnit (
	.iclock(iCLK50),
	.idataa(FP_A),
	.idatab(FP_B),
	.icontrol(wFPALUControlSignal),
	.oresult(wFPALUResult),
	.onan(wFPNan),
	.ozero(wFPZero),
	.ooverflow(wFPOverflow),
	.ounderflow(wFPUnderflow),
	.oCompResult(wCompResult)
);

/*FPU Flag Bank*/
FlagBank FlagBankModule(
	.iCLK(iCLK),
	.iCLR(iRST),
	.iFlag(wFPFlagSelector),
	.iFlagWrite(FPFlagWrite),
	.iData(wCompResult),
	.oFlags(wFPUFlagBank)
);

/* Floating Point ALU Control*/
FPALUControl FPALUControlUnit (
	.iFunct(wFunct),
	.oControlSignal(wFPALUControlSignal)
);

/* Timer block module */
Timer Time0 (
	.iCLK(iCLK50),
	.iRST(iRST),
	.qHI(wTimerOutHI),
	.qLO(wTimerOutLO)
	);

// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
/* Banco de registradores do Coprocessador 0 */
COP0Registers cop0reg (
	.iCLK(iCLK),
	.iCLR(iRST),
	
	// register file interface
	.iReadRegister(wRD),
	.iWriteRegister(wRD),
	.iWriteData(wCOP0DataReg),
	.iRegWrite(COP0RegWrite),
	.oReadData(wCOP0ReadData),
	
	// eret interface
	.iEret(COP0Eret),
	
	// COP0 interface
	.iExcOccurred(COP0ExcOccurred),
	.iBranchDelay(COP0BranchDelay),
	.iPendingInterrupt(iPendingInterrupt),
	.iInterrupted(COP0Interrupted),
	.iExcCode(COP0ExcCode),
	.oInterruptMask(wCOP0InterruptMask),
	.oUserMode(wCOP0UserMode),
	.oExcLevel(wCOP0ExcLevel),
	.oInterruptEnable(oCOP0InterruptEnable),
	// DE2-70 interface
	.iRegDispSelect(iRegDispSelect),
	.oRegDisp(oRegDispCOP0)
);



endmodule
