/*Controla a parte de memoria de dados e codigo do sistema.*/


module Memory (
	iCLK,
	iCLKMem, 
	iAddress,				// Endereco em bytes
	iByteEnable,
	iWriteData, 
	iMemRead, 
	iMemWrite, 
	oMemData,
	iwAudioCodecData,
	omouse_keyboard,
	oPS2_ENABLE,
				
	// feito no 1/2014	
	SRAM_DQ, 		// SRAM Data Bus 32 Bits
	oSRAM_A, 		// SRAM Address bus 21 Bits
	oSRAM_ADSC_N, 	// SRAM Controller Address Status 
	oSRAM_ADSP_N,	// SRAM Processor Address Status
	oSRAM_ADV_N,	// SRAM Burst Address Advance
	oSRAM_BE_N,		// SRAM Byte Write Enable
	oSRAM_CE1_N,	// SRAM Chip Enable
	oSRAM_CE2,		// SRAM Chip Enable
	oSRAM_CE3_N,	// SRAM Chip Enable
	oSRAM_CLK,		// SRAM Clock
	oSRAM_GW_N,		// SRAM Global Write Enable
	oSRAM_OE_N,		// SRAM Output Enable
	oSRAM_WE_N		// SRAM Write Enable
);

/* I/O type definition */
input wire iCLK, iCLKMem, iMemRead, iMemWrite;
input [3:0] iByteEnable;
input wire [31:0] iAddress, iWriteData;
output wire [31:0] oMemData;
input wire [31:0] iwAudioCodecData;

//////////////////////// SRAM Interface //////////////////////// 1/2014
inout [31:0] SRAM_DQ; // SRAM Data Bus 32 Bits
output [18:0] oSRAM_A; // SRAM Address bus 21 Bits
output oSRAM_ADSC_N; // SRAM Controller Address Status 
output oSRAM_ADSP_N; // SRAM Processor Address Status
output oSRAM_ADV_N; // SRAM Burst Address Advance
output [3:0] oSRAM_BE_N; // SRAM Byte Write Enable
output oSRAM_CE1_N; // SRAM Chip Enable
output oSRAM_CE2; // SRAM Chip Enable
output oSRAM_CE3_N; // SRAM Chip Enable
output oSRAM_CLK; // SRAM Clock
output oSRAM_GW_N; // SRAM Global Write Enable
output oSRAM_OE_N; // SRAM Output Enable
output oSRAM_WE_N; // SRAM Write Enable

wire [31:0] Address;
assign Address = {2'b0,iAddress[31:2]};  //Endereco em Words, Cuidar alinhamento!!
  
reg MemWrited;
wire wMemWrite;

wire wMemWrite_UserCode, wMemWrite_UserData, wMemWrite_SystemCode, wMemWrite_SystemData, wMemWrite_SRAM;
wire [31:0] wMemData_UserCode, wMemData_UserData, wMemData_SystemCode, wMemData_SystemData, wMemData_SRAM, wMemData_Boot;
wire is_usercode, is_userdata, is_systemcode, is_systemdata, is_iodevices, is_SRAM;

///CRIADO EM 2013/2
output reg oPS2_ENABLE; //1=enable PS2 0=disable PS2
output reg omouse_keyboard; //0=mouse 1=keyboard
wire mouse_info,PS2_ENABLE_info; //detecta se foi feito LW para obter omouse_keyboard

initial
	MemWrited = 1'b0;

always @(iCLK)
begin
	MemWrited <= iCLK;
end

///FEITO EM 2013/2 PARA DETECCAOO DA ORIGEM DOS DADOS PS2 (MOUSE OU TECLADO)
always @(posedge iCLK)
begin
if(iMemWrite)
begin
	if(iAddress==32'hFFFF0110)		//AQUI ERA O 7777777777 QUE NÃO SEI O QUE QUERIA DIZER :p
		begin
			oPS2_ENABLE<=iWriteData[0];
		end
		
	if(iAddress==32'hFFFF0114)
		begin
			omouse_keyboard<=iWriteData[0];
		end
end
end

assign PS2_ENABLE_info	= iAddress==TECLADOxMOUSE_ADDRESS; //iAddress=em bytes
assign mouse_info 		= iAddress==BUFFERMOUSE_ADDRESS; //iAddress=em bytes

assign is_iodevices 	= iAddress>=BEGINNING_IODEVICES;
assign is_usercode 		= iAddress>=BEGINNING_TEXT	&& iAddress<=END_TEXT;
assign is_userdata 		= iAddress>=BEGINNING_DATA	&& iAddress<=END_DATA;
assign is_systemcode	= iAddress>=BEGINNING_KTEXT	&& iAddress<=END_KTEXT;
assign is_systemdata 	= iAddress>=BEGINNING_KDATA	&& iAddress<=END_KDATA;
assign is_SRAM 			= iAddress>=BEGINNING_SRAM 	&& iAddress<=END_SRAM;
assign is_BootLoader 	= iAddress>=BEGINNING_BOOT && iAddress<=END_BOOT;

assign wMemWrite_UserCode 	= ~MemWrited && iMemWrite && is_usercode;
assign wMemWrite_UserData 	= ~MemWrited && iMemWrite && is_userdata;
assign wMemWrite_SystemCode	= ~MemWrited && iMemWrite && is_systemcode;
assign wMemWrite_SystemData	= ~MemWrited && iMemWrite && is_systemdata;
assign wMemWrite_SRAM 		= ~MemWrited && iMemWrite && is_SRAM;


assign oMemData = PS2_ENABLE_info? {31'b0,oPS2_ENABLE}:
				mouse_info? {31'b0,omouse_keyboard}:
						is_iodevices? iwAudioCodecData: 
								is_usercode? wMemData_UserCode:
										is_userdata? wMemData_UserData:
												is_systemcode? wMemData_SystemCode:
														is_systemdata? wMemData_SystemData:
																is_SRAM? wMemData_SRAM :
																		is_BootLoader? wMemData_Boot :
																		32'b0;
BootLoaderMemory bootLoaderArray (
	.address(iAddress),
	.wBootIntruction(wMemData_Boot)
);

UserCodeBlock UCodeMem (
	.address(Address[11:0]),			//em words
	.byteena(iByteEnable),
	.clock(iCLKMem),
	.data(iWriteData),
	.wren(wMemWrite_UserCode),
	.q(wMemData_UserCode)
);
																	
UserDataBlock UDataMem (
	.address(Address[11:0]),		//em Words!!
	.byteena(iByteEnable),
	.clock(iCLKMem),
	.data(iWriteData),
	.wren(wMemWrite_UserData),
	.q(wMemData_UserData)
);

SysCodeBlock SCodeMem (
	.address(Address[10:0]),			//em words
	.byteena(iByteEnable),
	.clock(iCLKMem),
	.data(iWriteData),
	.wren(wMemWrite_SystemCode),
	.q(wMemData_SystemCode)
);

SysDataBlock SDataMem (
	.address(Address[9:0]),		//em Words!!
	.byteena(iByteEnable),
	.clock(iCLKMem),
	.data(iWriteData),
	.wren(wMemWrite_SystemData),
	.q(wMemData_SystemData)
	);

DataSRAM SRAM_MB (
	.address(Address[18:0]),		//em words!!!!!11!
	.byteena(iByteEnable),
	.clock(iCLKMem),
	.data(iWriteData),
	.wren(wMemWrite_SRAM),
	.q(wMemData_SRAM),
	
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

endmodule
