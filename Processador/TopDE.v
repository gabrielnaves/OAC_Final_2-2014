/*
 TopDE
 
 Top Level para processador MIPS MULTICICLO v11.

Top Level para processador MIPS MULTICICLO v0 baseado no processador desenvolvido por 
David A. Patterson e John L. Hennessy
Computer Organization and Design
3a Edicao

Top Level para processador MIPS MULTICICLO v01 baseado no processador desenvolvido por 
Alexandre Lins 	09/40097
Daniel Dutra 	09/08436
Yuri Maia 	09/16803
em 2010/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v1 baseado no processador desenvolvido por 
Emerson Grzeidak 							0993514
Gabriel Calache Cozendey 						09/47946
Glauco Medeiros Volpe 						10/25091
Luiz Henrique Dias Navarro 						10/00748
Waldez Azevedo Gomes Junior						10/08617
em 2011/1 na disciplina OAC

 Top Level para processador MIPS UNICICLO v2 baseado no processador desenvolvido por 
Antonio Martino Neto ? 09/89886
Bruno de Matos Bertasso ? 08/25590
Carolina S. R. de Oliveira ? 07/45006
Herman Ferreira M. de Asevedo ? 09/96319
Renata Cristina ? 09/0130600
em 2011/2 na disciplina OAC

 Top Level para processador MIPS MULTICICLO v9 baseado no processador desenvolvido por 
Andr� Fran�a - 10/0007457
Felipe Carvalho Gules - 08/29137
Filipe Tancredo Barros - 10/0029329
Guilherme Ferreira - 12/0051133
Vitor Coimbra de Oliveira - 10/0021832
em 2012/1 na disciplina OAC

 Top Level para processador MIPS MULTICICLO v10 baseado no processador desenvolvido por 
Alexandre Dantas 10/0090788
Ciro Viana 09/0137531
Matheus Pimenta 09/0125789
em 2013/1 na disciplina OAC

Top Level para processador MIPS MULTICICLO v14 baseado no processador desenvolvido por 
???
???
???
???
em 2014/1 na disciplina OAC

 Adaptado para a placa de desenvolvimento DE2-70.
 Prof. Marcus Vinicius Lamar   2013/2
 UnB - Universidade de Brasilia
 Dep. Ciência da Computação
 */
 
module TopDE (
	/* I/O type definition */
	input iCLK_50, iCLK_28, iCLK_50_4,
	input [3:0] iKEY,		// KEYs
	input [17:0] iSW,		// Switches
	output [8:0] oLEDG,	// LEDs Green
	output [17:0] oLEDR,  // LEDs Red
	output [6:0] oHEX0_D, oHEX1_D, oHEX2_D, oHEX3_D, oHEX4_D, oHEX5_D, oHEX6_D, oHEX7_D,  // Displays Hex
	output oHEX0_DP, oHEX1_DP, oHEX2_DP, oHEX3_DP, oHEX4_DP, oHEX5_DP, oHEX6_DP, oHEX7_DP, // Displays Dot Point
	// GPIO_0
	input [31:0] GPIO_0,
	//VGA interface
	output oVGA_CLOCK, oVGA_HS, oVGA_VS, oVGA_BLANK_N, oVGA_SYNC_N,
	output [9:0] oVGA_R, oVGA_G, oVGA_B,
	// TV Decoder
	output oTD1_RESET_N, // TV Decoder Reset
	// I2C
	inout  I2C_SDAT, 	// I2C Data
	output oI2C_SCLK, 	// I2C Clock
	// Audio CODEC
	inout  AUD_ADCLRCK, 	// Audio CODEC ADC LR Clock
	input  iAUD_ADCDAT, 	// Audio CODEC ADC Data
	inout  AUD_DACLRCK, 	// Audio CODEC DAC LR Clock
	output oAUD_DACDAT,  	// Audio CODEC DAC Data
	inout  AUD_BCLK,    	// Audio CODEC Bit-Stream Clock
	output oAUD_XCK,     	// Audio CODEC Chip Clock
	// PS2 Keyborad
	inout PS2_KBCLK,
	inout PS2_KBDAT,
	//	Modulo LCD 16X2
	inout	[7:0]	LCD_D,			//	LCD Data bus 8 bits
	output oLCD_ON,		//	LCD Power ON/OFF
	output oLCD_BLON,		//	LCD Back Light ON/OFF
	output oLCD_RW,		//	LCD Read/Write Select, 0 = Write, 1 = Read
	output oLCD_EN,		//	LCD Enable
	output oLCD_RS,		//	LCD Command/Data Select, 0 = Command, 1 = Data
	// SRAM Interface
	inout [31:0] SRAM_DQ, // SRAM Data Bus 32 Bits
	output [18:0] oSRAM_A, // SRAM Address bus 21 Bits
	output oSRAM_ADSC_N, // SRAM Controller Address Status 
	output oSRAM_ADSP_N, // SRAM Processor Address Status
	output oSRAM_ADV_N, // SRAM Burst Address Advance
	output [3:0] oSRAM_BE_N, // SRAM Byte Write Enable
	output oSRAM_CE1_N, // SRAM Chip Enable
	output oSRAM_CE2, // SRAM Chip Enable
	output oSRAM_CE3_N, // SRAM Chip Enable
	output oSRAM_CLK, // SRAM Clock
	output oSRAM_GW_N, // SRAM Global Write Enable
	output oSRAM_OE_N, // SRAM Output Enable
	output oSRAM_WE_N, // SRAM Write Enable
	// Interface Serial RS-232
	output oUART_TXD,					//	UART Transmitter
	input iUART_RXD,					//	UART Receiver
	output oUART_CTS,         			//	UART Clear To Send
	input iUART_RTS,        			//	UART Request To Send
	//para simulacao
	output [31:0] oOUTPUT
	);
 
 
 
// CLK signals ctrl
reg CLKManual, CLKAutoSlow, CLKSelectAuto, CLKSelectFast, CLKAutoFast;
wire CLK, clock50_ctrl;
reg [7:0] CLKCount2;
reg [25:0] CLKCount;
wire [7:0] wcountf;

// Local wires 
wire [31:0] PC, wRegDisp, wFPRegDisp, wRegDispCOP0, wMemAddress, wMemWriteData, wMemReadData, extOpcode, 
			extFunct,wInstr, wOutput, wDebug, wMemReadVGA;
wire [1:0] ALUOp, ALUSrcA;
wire [2:0] ALUSrcB, PCSource;
wire IRWrite, MemWrite, MemRead, IorD, PCWrite, PCWriteBEQ, PCWriteBNE, RegWrite, RegDst;
wire [5:0] wControlState;
wire [4:0] wRegDispSelect;
wire [5:0] wOpcode, wFunct;
wire [7:0] flagBank;


// Reset Sincrono com o Clock
wire Reset;
always @(posedge CLK)
	Reset <= ~iKEY[0];
	

//Wire assignment

// LEDs 
assign oLEDG[4:0] =	wCOP0ExcCode;
assign oLEDG[5] = wCOP0Interrupted;
assign oLEDG[8] =	CLK;
assign oLEDR[2:0] =	PCSource;
assign oLEDR[5:3] =	ALUSrcB[2:0];
assign oLEDR[6] =	ALUSrcA[0];
assign oLEDR[7] =	PCWrite;
assign oLEDR[8] =	RegWrite;
assign oLEDR[9] =	IorD;
assign oLEDR[10] =	MemWrite;
assign oLEDR[11] =	MemRead;
assign oLEDR[17:12] =	wControlState;

/* para apresentacao nos displays */
assign extOpcode = {26'b0,wOpcode};
assign extFunct = {26'b0,wFunct};

assign oOUTPUT = wOutput; //Para debug com simulacao

/* 7 segment display content selection */
assign wRegDispSelect =	iSW[17:13];

// Contador para o divisor de clock
assign wcountf = iSW[7:0];

assign wOutput	= iSW[12] ?
				(iSW[17] ?
					PC :
					(iSW[16] ?
						wInstr :
						(iSW[15] ?
							extOpcode :
							(iSW[14] ?
								extFunct :
								(iSW[13]?
								wDebug:
								{3'b0, flagBank[7], 3'b0, flagBank[6], 3'b0, flagBank[5], 3'b0, flagBank[4], 
								3'b0, flagBank[3], 3'b0, flagBank[2], 3'b0, flagBank[1], 3'b0, flagBank[0]})
							)
						)
					)
				) : (iSW[11] ? wFPRegDisp : (iSW[9] ? wRegDispCOP0 : wRegDisp));
				 

/* Clocks */
always @(posedge clock50_ctrl)
	CLK <= CLKSelectAuto? (CLKSelectFast? CLKAutoFast : CLKAutoSlow):CLKManual;

/* Clock events definitions */
initial
begin
	CLKManual	<= 1'b0;
	CLKAutoSlow	<= 1'b0;
	CLKSelectAuto	<= 1'b0;
	CLKSelectFast	<= 1'b0;
	CLKCount2<=8'b0;
	CLKCount<=26'b0;
end

always @(posedge clock50_ctrl)    //clock manual sincrono com iCLK_50
	CLKManual <= iKEY[3];

always @(posedge iKEY[2])
	CLKSelectAuto <= ~CLKSelectAuto;

always @(posedge iKEY[1])
	CLKSelectFast <= ~CLKSelectFast;


always @(posedge clock50_ctrl)
begin

	if (CLKCount == {wcountf, 18'b0}) //Clock Slow
	begin
		CLKAutoSlow <= ~CLKAutoSlow;
		CLKCount <= 26'b0;
	end
	else
		CLKCount <= CLKCount + 1'b1;
	
	if (CLKCount2 == wcountf) //8'hFF) //Clock Fast
	begin
		CLKAutoFast <= ~CLKAutoFast;
		CLKCount2 <= 8'b0;
	end
	else
		CLKCount2 <= CLKCount2 + 1'b1;
	
end


/* Timmer de 10 segundos e ajuste da frequencia do Processador */
//mono Mono1 (iCLK_50,~iSW[10],clock50_ctrl,Reset); //Vem do VgaPLL

wire CLK_X, CLK_LOCK;
//PLL pllx (.areset(~DLY_RST),.inclk0(iCLK_50_4),.c0(CLK_X),.locked(CLK_LOCK));
//mono Mono1 ((CLK_X && CLK_LOCK),~iSW[10],clock50_ctrl,Reset);
assign CLK_X=iCLK_50;
assign CLK_LOCK=1'b1;
mono Mono1 ((CLK_X && CLK_LOCK),~iSW[10],clock50_ctrl,Reset);


// Para o Boot
wire [31:0] PCinicial;
//initial
	//PCinicial=BEGINNING_TEXT;

assign PCinicial=iSW[8]? BEGINNING_BOOT : BEGINNING_TEXT;


// MIPS Processor instantiation
MIPS Processor (
	.iCLK(CLK),
	.iCLK50(clock50_ctrl),
	.iRST(Reset),
	.iInitialPC(PCinicial),
	.iwAudioCodecData(wAudioCodecData),
	.oPC(PC),
	.owControlState(wControlState),
	.oALUOp(ALUOp),
	.oPCSource(PCSource),
	.oALUSrcB(ALUSrcB),
	.oIRWrite(IRWrite),
	.oMemWrite(MemWrite),
	.oMemRead(MemRead),
	.oIorD(IorD),
	.oPCWrite(PCWrite),
	.oALUSrcA(ALUSrcA),
	.oPCWriteBEQ(PCWriteBEQ),
	.oPCWriteBNE(PCWriteBNE),
	.oRegWrite(RegWrite),
	.oRegDst(RegDst),
	.iRegDispSelect(wRegDispSelect),
	.oRegDisp(wRegDisp),
	.owMemAddress(wMemAddress),
	.owMemWriteData(wMemWriteData),
	.owMemReadData(wMemReadData),
	.oOpcode(wOpcode),
	.oFunct(wFunct),
	.oInstr(wInstr),
	.oDebug(wDebug),
	.oFPRegDisp(wFPRegDisp),
	.oFPUFlagBank(flagBank),
	
	// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
	.iPendingInterrupt(wPendingInterrupt),
	.oRegDispCOP0(wRegDispCOP0),
	.oCOP0Interrupted(wCOP0Interrupted),
	.oCOP0ExcCode(wCOP0ExcCode),
	.oCOP0InterruptEnable(wCOP0InterruptEnable),
	.omouse_keyboard(reg_mouse_keyboard),
	.oPS2_ENABLE(reg_PS2_ENABLE),
	
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

// 7 segment displays instantiations 

assign oHEX0_DP=1'b1;
assign oHEX1_DP=1'b1;
assign oHEX2_DP=1'b1;
assign oHEX3_DP=1'b1;
assign oHEX4_DP=1'b1;
assign oHEX5_DP=1'b1;
assign oHEX6_DP=1'b1;
assign oHEX7_DP=1'b1;

Decoder7 Dec0 (
	.In(wOutput[3:0]),
	.Out(oHEX0_D)
	);

Decoder7 Dec1 (
	.In(wOutput[7:4]),
	.Out(oHEX1_D)
	);

Decoder7 Dec2 (
	.In(wOutput[11:8]),
	.Out(oHEX2_D)
	);

Decoder7 Dec3 (
	.In(wOutput[15:12]),
	.Out(oHEX3_D)
	);

Decoder7 Dec4 (
	.In(wOutput[19:16]),
	.Out(oHEX4_D)
	);

Decoder7 Dec5 (
	.In(wOutput[23:20]),
	.Out(oHEX5_D)
	);

Decoder7 Dec6 (
	.In(wOutput[27:24]),
	.Out(oHEX6_D)
	);

Decoder7 Dec7 (
	.In(wOutput[31:28]),
	.Out(oHEX7_D)
	);
	
VgaAdapterInterface VGAAI0 (
	.iRST(~Reset),
	.iCLK_50(iCLK_50),
	.iCLK(CLK),
	.iMemWrite(MemWrite),
	.iwMemAddress(wMemAddress),
	.iwMemWriteData(wMemWriteData),
	.oMemReadData(wMemReadVGA),
	.oVGA_R(oVGA_R),
	.oVGA_G(oVGA_G),
	.oVGA_B(oVGA_B),
	.oVGA_HS(oVGA_HS),
	.oVGA_VS(oVGA_VS),
	.oVGA_BLANK(oVGA_BLANK_N),
	.oVGA_SYNC(oVGA_SYNC_N),
	.oVGA_CLK(oVGA_CLOCK),
	.oVGA_CLK2(),
	.oCLK_LOCK());


//  Audio In/Out Interface

// reset delay gives some time for peripherals to initialize
wire DLY_RST;
Reset_Delay r0(	.iCLK(iCLK_50),.oRESET(DLY_RST) );

assign	oTD1_RESET_N = 1'b1;  // Enable 27 MHz

wire AUD_CTRL_CLK;

VGA_Audio_PLL 	p1 (	
	.areset(~DLY_RST),
	.inclk0(iCLK_28),
	.c0(),
	.c1(AUD_CTRL_CLK),
	.c2()
);

I2C_AV_Config u3(	
//	Host Side
  .iCLK(iCLK_50),
  .iRST_N(~Reset),
//	I2C Side
  .I2C_SCLK(oI2C_SCLK),
  .I2C_SDAT(I2C_SDAT)	
); 

assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	oAUD_XCK	=	AUD_CTRL_CLK;

audio_clock u4(	
//	Audio Side
   .oAUD_BCK(AUD_BCLK),
   .oAUD_LRCK(AUD_DACLRCK),
//	Control Signals
   .iCLK_18_4(AUD_CTRL_CLK),
   .iRST_N(DLY_RST)	
);


 /* CODEC AUDIO */

audio_converter u5(
	// Audio side
	.AUD_BCK(AUD_BCLK),       // Audio bit clock
	.AUD_LRCK(AUD_DACLRCK), // left-right clock
	.AUD_ADCDAT(iAUD_ADCDAT),
	.AUD_DATA(oAUD_DACDAT),
	// Controller side
	.iRST_N(DLY_RST),  // reset
	.AUD_outL(audio_outL),
	.AUD_outR(audio_outR),

	.AUD_inL(audio_inL),
	.AUD_inR(audio_inR)
);

wire [15:0] audio_inL, audio_inR;
reg [15:0] audio_outL,audio_outR;
reg [31:0] wAudioCodecData;

reg [31:0] waudio_inL ,waudio_inR;
reg [31:0] waudio_outL, waudio_outR;
reg [31:0] Ctrl1,Ctrl2;
 
 /* Endereco dos registradores do CODEC na memoria
parameter 	INRDATA=32'hFFFF0004,  INLDATA=32'hFFFF0000,
			OUTRDATA=32'hFFFF000C, OUTLDATA=32'hFFFF0008,
			CTRL1=32'hFFFF0010,    CTRL2=32'hFFFF0014;  esta no parametros.v  */
initial
	begin
		waudio_inL<=32'b0;
		waudio_inR<=32'b0;
		waudio_outL<=32'b0;
		waudio_outR<=32'b0;
		Ctrl1<=32'b0;
		Ctrl2<=32'b0;
	end

always @(negedge AUD_DACLRCK)
	begin
		if(Ctrl2[0]==0)
			begin
				waudio_inR = {16'b0,audio_inR};
				audio_outR = waudio_outR[15:0];
				Ctrl1[0] = 1'b1;
			end
		else
			Ctrl1[0]=1'b0;
	end
	
always @(posedge AUD_DACLRCK)
	begin
		if(Ctrl2[1]==0)
			begin
				waudio_inL = {16'b0,audio_inL};
				audio_outL = waudio_outL[15:0];
				Ctrl1[1] =1'b1;
			end
		else
			Ctrl1[1]=1'b0;
	end


always @(posedge CLK)			
		if(MemWrite) //Escrita no dispositivo de Audio
			begin
				if(wMemAddress==AUDIO_OUTR_ADDRESS)
					waudio_outR <= wMemWriteData;
				else
				if(wMemAddress==AUDIO_OUTL_ADDRESS)
					waudio_outL <= wMemWriteData;
				else
				if(wMemAddress==AUDIO_CRTL2_ADDRESS)
					Ctrl2 <= wMemWriteData;
			end		


// Teclado PS2

wire [7:0] PS2scan_code;
reg [7:0] PS2history[1:8]; // buffer de 8 bytes
wire PS2read, PS2scan_ready;

oneshot pulser(
   .pulse_out(PS2read),
   .trigger_in(PS2scan_ready),
   .clk(iCLK_50)
);

keyboard kbd(
  .keyboard_clk(PS2_KBCLK),
  .keyboard_data(PS2_KBDAT),
  .clock50(iCLK_50),
  .reset(Reset),
  .read(PS2read),
  .scan_ready(PS2scan_ready),
  .scan_code(PS2scan_code)
);

always @(posedge PS2scan_ready, posedge Reset)
begin
	if(Reset)
		begin
		PS2history[8] <= 0;
		PS2history[7] <= 0;
		PS2history[6] <= 0;
		PS2history[5] <= 0;
		PS2history[4] <= 0;
		PS2history[3] <= 0;
		PS2history[2] <= 0;
		PS2history[1] <= 0;
		end
	else
		begin
		PS2history[8] <= PS2history[7];
		PS2history[7] <= PS2history[6];
		PS2history[6] <= PS2history[5];
		PS2history[5] <= PS2history[4];
		PS2history[4] <= PS2history[3];
		PS2history[3] <= PS2history[2];
		PS2history[2] <= PS2history[1];
		PS2history[1] <= PS2scan_code;
		end
end

/*	LCD ON */
assign	oLCD_ON		=	1'b1;
assign	oLCD_BLON	=	1'b1;

wire [7:0] oLeituraLCD;
	
LCDStateMachine LCDSM0 (
	.iCLK(iCLK_50),
	.iRST(Reset),
	.LCD_DATA(LCD_D),
	.LCD_RW(oLCD_RW),
	.LCD_EN(oLCD_EN),
	.LCD_RS(oLCD_RS),
	.iMemAddress(wMemAddress),
	.iMemWriteData(wMemWriteData),
	.iMemWrite(MemWrite),
	.oLeitura(oLeituraLCD)
);



//////////////////////////////////////////////
/* sintetizador

parameter SINT_IN =32'hffff0160,
		  SINT_OUT = 32'hffff0164;
		  
reg [7:0] sint_note;
reg [15:0] sint_in1;
reg [31:0] sint_in2;

Sintetizador S1 (
	 //Entradas do CODEC de Audio da propria DE2.
.AUD_DACLRCK(AUD_DACLRCK), .AUD_BCLK(AUD_BCLK),
.NOTE_PLAY(sint_note[0]),			// 1: Iniciara`a nota definida por NOTE_PITCH; 0: Terminara`a nota definida por NOTE_PITCH.
.NOTE_PITCH(sint_note[7:1]),	// O Indice da nota a ser iniciada/terminada, como definido no padrao MIDI.
	 //Configuracoes do oscilador.
.WAVE(sint_in1[1:0]),	// Define a forma de onda das notas:
.NOISE_EN(sint_in1[2]),	// Ativa (1) ou desativa (0) a geracao de ruido na saida do oscilador.
	 //Configuracoes do filtro.
.FILTER_EN(sint_in1[3]),	// Ativa (1) ou desativa (0) a filtragem na saida do oscilador.
.FILTER_QUALITY(sint_in1[15:8]),	// O fator de qualidade do filtro. (ponto fixo Q8)
	 // Configuracoes do envelope aplicado durante a vida de uma nota.
.ATTACK_DURATION(sint_in2[6:0]),	// Duracao da fase de Attack da nota.
.DECAY_DURATION(sint_in2[14:8]),	// Duracao da fase de Decay da nota.
.SUSTAIN_AMPLITUDE(sint_in2[22:16]),	// Amplitude da fase de Sustain da nota.
.RELEASE_DURATION(sint_in2[30:24]),	// Duracao da fase de Release da nota.
	 // Amostra de saida do sintetizador.
.SAMPLE_OUT(audio_outL)
);
*/
/////////////////////////////////////////





// feito no semestre 2013/1 para implementar a deteccao de excecoes (COP0)
wire wCOP0Interrupted;
wire [4:0] wCOP0ExcCode;
wire wCOP0InterruptEnable;
/* Interrupcao de teclado */
reg audio_aud_daclrck_ff, audio_interrupted_ff;
always @(negedge AUD_DACLRCK)
	audio_aud_daclrck_ff <= ~audio_aud_daclrck_ff;
always @(negedge wCOP0Interrupted)
	audio_interrupted_ff <= audio_aud_daclrck_ff;
/* Interrupcao de teclado */
reg kbd_scan_ready_ff, kbd_interrupted_ff;
always @(posedge PS2scan_ready)
	kbd_scan_ready_ff <= ~kbd_scan_ready_ff;
always @(negedge wCOP0Interrupted)
	kbd_interrupted_ff <= kbd_scan_ready_ff;
/* Interrupcoes */
wire [7:0] wPendingInterrupt;
assign wPendingInterrupt = {5'b0,
	(!reg_mouse_keyboard)&&(received_data_en_contador_enable),
	audio_aud_daclrck_ff ^ audio_interrupted_ff,
	(kbd_scan_ready_ff ^ kbd_interrupted_ff)&&reg_mouse_keyboard };


////Para a geracao de excecoes de mouse 2013/2


reg [7:0] received_data_history[3:0];
wire received_data_en;


reg received_data_en_contador_enable_xor1,received_data_en_contador_enable_xor2;
wire received_data_en_contador_enable;
int received_data_en_contador;

assign received_data_en_contador_enable=received_data_en_contador_enable_xor1^received_data_en_contador_enable_xor2;

initial
begin
received_data_en_contador<=0;
received_data_en_contador_enable_xor1<=1'b1;
received_data_en_contador_enable_xor2<=1'b1;
end

always @(negedge received_data_en)
begin
received_data_en_contador_enable_xor1<=~received_data_en_contador_enable_xor1;
end

always @(posedge CLK)
begin
if(received_data_en_contador_enable)
begin
received_data_en_contador=received_data_en_contador+1;
if(received_data_en_contador==10)
begin
received_data_en_contador=0;
received_data_en_contador_enable_xor2=received_data_en_contador_enable_xor1;
end
end
end

reg reg_mouse_keyboard,reg_PS2_ENABLE;

mouse_hugo mouse1(
	.CLOCK_50(iCLK_50),
	.reset(Reset),
	// Bidirectionals
	.PS2_CLK(PS2_KBCLK),					// PS2 Clock
 	.PS2_DAT(PS2_KBDAT),					// PS2 Data

	.iCOP0InterruptEnable(wCOP0InterruptEnable),
	// Outputs
	.received_data_history(received_data_history),
	.received_data_en(received_data_en),			// If 1 - new data has been received
	.command_auto(command_auto)
);

wire command_auto;



////Fim 2013/2


////RS232

reg [7:0] RxData, RxDataAux;
wire [7:0] wTxData;
wire wPulsoRxSin; //fio de pulso
reg [7:0] RsControl; //5 bits in??s, 1 bit ready, 1 bit busy e 1 bit start
reg TxStart;
wire oRxReady, oTxBusy;
//reg [31:0] cont;  // DEBUG: so para ter certeza que o pulso esta OK

always@(wPulsoRxSin)
	begin
		if(Reset)
			begin
				RsControl = 8'b0;
				RxData = 8'b0;
			end
		else
			begin
				RsControl = {5'b0, wPulsoRxSin, oTxBusy, TxStart};
				RxData <= RxDataAux;		
			end
	end
// ___________________________________________
// | 0 | 0 | 0 | 0 | 0 | ready | busy | start|
// ___________________________________________
//

rs232tx rs232transmitter( //Do fpga para computador
	.clk(iCLK_50),
	.TxD_start(TxStart), //Indica quando dado est?ronto pra escrita
	.TxD_data(wTxData), //Byte a ser enviado para placa
	.TxD(oUART_TXD), //Indica se ainda byte est?o estado de start ou stop
	.TxD_busy(oTxBusy) //Avisa quando dado terminou de lido, 0: acabou de transmitir, 1: enquanto est?endo
);

rs232rx rs232receiver( //Da computador para  fpga
	.clk(iCLK_50)
	,.RxD(iUART_RXD) //Bit atual rec?lido
	,.RxD_data_ready(oRxReady) //bit que avisa quando dado est?ronto pra leitura
	,.RxD_data(RxDataAux)  // byte lido 
	,.RxD_idle()  // Indica quando n?h?yte para ser lido
	,.RxD_endofpacket()  //indica quando h?yte para ser Rodoulido (idle ir?oltar a ser 1)
	,.Data_Ready_Pulse(wPulsoRxSin)
);

//assign oLEDR[17] = oRxReady;  //PARA DEBUG
//assign oLEDR[16] = wPulsoRxSin; //PARA DEBUG

//DEBUG
//  So para saber se o pulso esta OK, deve aparecer o display o valor 868 em hexa
//initial
	//cont=0;			
/*always @(posedge iCLK_50)
	begin
		if(wPulsoRxSin)
			cont=cont+1;
	end	
*/


always @(posedge CLK)			
		if(MemWrite) 
			begin
				case (wMemAddress)
					RS232_WRITE: wTxData <= wMemWriteData[7:0]; 
					RS232_CONTROL: TxStart <= wMemWriteData[0]; 
				endcase
			end	

////FIM RS232


/* acesso para leitura dos enderecos da memoria  MMIO
 a gravacaoo eh feita no proprio dispositivo acima */

always @(*)
		if(MemRead)  //Leitura dos dispositivos
			//VGA
			if( wMemAddress>=BEGINNING_VGA && wMemAddress<=END_VGA)
				wAudioCodecData <= wMemReadVGA;
			
			//LCD
			else if(wMemAddress>=BEGINNING_LCD && wMemAddress<=END_LCD)
				wAudioCodecData<={24'b0,oLeituraLCD};
			
			//Audio/PS2/Mouse
			else
			
			begin
				case (wMemAddress)
					//Audio
					AUDIO_INR_ADDRESS:		wAudioCodecData <= waudio_inR;
					AUDIO_OUTR_ADDRESS:		wAudioCodecData <= waudio_outR;
					AUDIO_INL_ADDRESS:		wAudioCodecData <= waudio_inL;
					AUDIO_OUTL_ADDRESS:		wAudioCodecData <= waudio_outL;
					AUDIO_CTRL1_ADDRESS:	wAudioCodecData <= Ctrl1;
					AUDIO_CRTL2_ADDRESS:	wAudioCodecData <= Ctrl2;
					
					//PS2
					BUFFER0_TECLADO_ADDRESS:  wAudioCodecData <= {PS2history[4],PS2history[3],PS2history[2],PS2history[1]};
					BUFFER1_TECLADO_ADDRESS:  wAudioCodecData <= {PS2history[8],PS2history[7],PS2history[6],PS2history[5]};
					
					//PS2 mouse 
					BUFFERMOUSE_ADDRESS: wAudioCodecData <= {received_data_history[3],received_data_history[2],received_data_history[1],received_data_history[0]};

					//RS232
					RS232_READ:		wAudioCodecData <= {24'b0 , RxData};
					RS232_CONTROL:	wAudioCodecData <= {24'b0 , RsControl};
					
					default:  wAudioCodecData <= 32'b0;  
				endcase
			end
		
		else
			wAudioCodecData <= 32'b0;


endmodule
