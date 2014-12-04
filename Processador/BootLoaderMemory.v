module BootLoaderMemory(
	address,
	wBootIntruction
);

reg [31:0] BootLoaderReg [90:0]; 	//Banco de Registradores com o BootLoader
input wire [31:0] address;				//Endereco do Banco com a instrudacao pedida
output wire [31:0] wBootIntruction;	//Wire de output com a instrucao do endereco iAddress


//Define a instrucao de output
assign wBootIntruction = BootLoaderReg[address>>2];

//Inicio do BootLoader no Banco de Registradores
initial
	begin
		BootLoaderReg[00] = 32'h3c018000;
		BootLoaderReg[01] = 32'h34340000;
		BootLoaderReg[02] = 32'h3c019000;
		BootLoaderReg[03] = 32'h34350000;
		BootLoaderReg[04] = 32'h3c010040;
		BootLoaderReg[05] = 32'h34360000;
		BootLoaderReg[06] = 32'h3c011001;
		BootLoaderReg[07] = 32'h34370000;
		BootLoaderReg[08] = 32'h3c01ffff;
		BootLoaderReg[09] = 32'h343a0120;
		BootLoaderReg[10] = 32'h3c01ffff;
		BootLoaderReg[11] = 32'h343b0128;
		BootLoaderReg[12] = 32'h00142021;
		BootLoaderReg[13] = 32'h0c000016;
		BootLoaderReg[14] = 32'h00152021;
		BootLoaderReg[15] = 32'h0c000016;
		BootLoaderReg[16] = 32'h00162021;
		BootLoaderReg[17] = 32'h0c000016;
		BootLoaderReg[18] = 32'h00172021;
		BootLoaderReg[19] = 32'h0c000016;
		BootLoaderReg[20] = 32'h00166021;
		BootLoaderReg[21] = 32'h01800008;
		BootLoaderReg[22] = 32'h00004021;
		BootLoaderReg[23] = 32'h00004821;
		BootLoaderReg[24] = 32'h00005021;
		BootLoaderReg[25] = 32'h00005821;
		BootLoaderReg[26] = 32'h00006021;
		BootLoaderReg[27] = 32'h00006821;
		BootLoaderReg[28] = 32'h00007021;
		BootLoaderReg[29] = 32'h00007821;
		BootLoaderReg[30] = 32'h0000c021;
		BootLoaderReg[31] = 32'h0000c821;
		BootLoaderReg[32] = 32'h3c01ffff;
		BootLoaderReg[33] = 32'h34280120;
		BootLoaderReg[34] = 32'h00005821;
		BootLoaderReg[35] = 32'h240e0003;
		BootLoaderReg[36] = 32'h20180008;
		BootLoaderReg[37] = 32'h240c0004;
		BootLoaderReg[38] = 32'h8d090008;
		BootLoaderReg[39] = 32'h00094882;
		BootLoaderReg[40] = 32'h1120fffd;
		BootLoaderReg[41] = 32'h8d0a0000;
		BootLoaderReg[42] = 32'h01d80018;
		BootLoaderReg[43] = 32'h00006812;
		BootLoaderReg[44] = 32'h01aa5004;
		BootLoaderReg[45] = 32'h016a5825;
		BootLoaderReg[46] = 32'h218cffff;
		BootLoaderReg[47] = 32'h21ceffff;
		BootLoaderReg[48] = 32'h8d090008;
		BootLoaderReg[49] = 32'h00094882;
		BootLoaderReg[50] = 32'h1520fffd;
		BootLoaderReg[51] = 32'h1580fff2;
		BootLoaderReg[52] = 32'h000b1021;
		BootLoaderReg[53] = 32'h240c0004;
		BootLoaderReg[54] = 32'h240e0003;
		BootLoaderReg[55] = 32'h20180008;
		BootLoaderReg[56] = 32'h11600015;
		BootLoaderReg[57] = 32'h8d090008;
		BootLoaderReg[58] = 32'h00094882;
		BootLoaderReg[59] = 32'h1120fffd;
		BootLoaderReg[60] = 32'h8d0a0000;
		BootLoaderReg[61] = 32'h01d80018;
		BootLoaderReg[62] = 32'h00006812;
		BootLoaderReg[63] = 32'h01aa5004;
		BootLoaderReg[64] = 32'h01ea7825;
		BootLoaderReg[65] = 32'h218cffff;
		BootLoaderReg[66] = 32'h21ceffff;
		BootLoaderReg[67] = 32'h216bffff;
		BootLoaderReg[68] = 32'h8d090008;
		BootLoaderReg[69] = 32'h00094882;
		BootLoaderReg[70] = 32'h1520fffd;
		BootLoaderReg[71] = 32'h1580fff0;
		BootLoaderReg[72] = 32'h240c0004;
		BootLoaderReg[73] = 32'hac8f0000;
		BootLoaderReg[74] = 32'h20840004;
		BootLoaderReg[75] = 32'h00007821;
		BootLoaderReg[76] = 32'h240e0003;
		BootLoaderReg[77] = 32'h08000038;
		BootLoaderReg[78] = 32'h11e00001;
		BootLoaderReg[79] = 32'hac8f0000;
		BootLoaderReg[80] = 32'h03e00008;

	end

endmodule
