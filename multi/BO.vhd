library ieee;
use ieee.std_logic_1164.all;

entity BO is
	port(
		clock, reset: in std_logic;
		opcode: out std_logic_vector(5 downto 0);
		PCEscCond, PCEsc, IouD, LerMem,
		EscMem, MemParaReg, IREsc,
		RegDst, EscReg, ULAFonteA: in std_logic;
		ULAFonteB, ULAOp, FontePC: in std_logic_vector(1 downto 0)
	);
end;

architecture estrutural of BO is
	component register_n_bits is    
		generic(width: integer := 8);
		port( 
			clk, reset, writeReg: in std_logic;
			d: in std_logic_vector(width-1 downto 0);
			q: out std_logic_vector(width-1 downto 0)
		);
	end component;
	
	component mux2x1nbits is
		generic(width: integer := 8);
		port(
			inpt0: in std_logic_vector(width-1 downto 0);
			inpt1: in std_logic_vector(width-1 downto 0);
			sel: in std_logic;
			outp: out std_logic_vector(width-1 downto 0)
		);
	end component;
	
	component mux4x1nbits is
		generic(width: integer := 8);
		port(
			inpt0: in std_logic_vector(width-1 downto 0);
			inpt1: in std_logic_vector(width-1 downto 0);
			inpt2: in std_logic_vector(width-1 downto 0);
			inpt3: in std_logic_vector(width-1 downto 0);
			sel: in std_logic_vector(1 downto 0);
			outp: out std_logic_vector(width-1 downto 0)
		);
	end component;

	component memory_BRAM IS
		PORT(
			address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END component;
	
	component registerBank is 
		generic(	regWidth: integer := 8; 
					regLength: integer := 32); 
		port(	clock, reset, 
				regWrite: in std_logic; 
				readReg1, readReg2, writeReg: in  std_logic_vector(4 downto 0); 
				writeData: in std_logic_vector(regWidth-1 downto 0);
				readData1, readData2: out std_logic_vector(regWidth-1 downto 0) 
		);
	end component;
	
	component ALUcontrol is
		port(
			funct: in std_logic_vector(5 downto 0);
			ALUop: in std_logic_vector(1 downto 0);
			operation: out std_logic_vector(2 downto 0)
		);
	end component;
	
	component signalExtend is
	generic(	finalWidth:  integer := 8;
				actualWidth: integer := 4);
	port(
		input:  in  std_logic_vector(actualWidth-1 downto 0);
		output: out std_logic_vector(finalWidth-1 downto 0)
	);
	end component;
	
	component shiftLeft2 is
		generic(n: integer := 8);
			port(	input:  in  std_logic_vector(n-1 downto 0);
				output: out std_logic_vector(n-1 downto 0)
			);
	end component;
	
	component ALU is
		generic(dataWidth: integer := 8);
		port(
			ALUData0, 
			ALUData1: 	in  std_logic_vector(dataWidth-1 downto 0);
			operation:	in  std_logic_vector(2 downto 0);
			ALUresult:  out std_logic_vector(dataWidth-1 downto 0);
			zero:       out std_logic
		);
	end component;
	
	component Mux3x1nbits IS
		generic ( WID : integer := 32 );
		PORT (clk: IN STD_LOGIC;
				a,b,c : IN STD_LOGIC_VECTOR(WID-1 DOWNTO 0);
				sel : in std_LOGIC_vector(1 downto 0);
				s : out std_LOGIC_VECTOR(WID-1 DOWNTO 0));
	END component;
	
	signal or2pc, zeroUla, true: std_logic;
	signal mux2pc, pcout, ulaout, mux2mem, memout, regBout, regAout,
			 instrucao, regDadoOut, muxDadoEscOut,readData1,readData2, saiExt,
			 des2muxUla,ulaIn1, ulaIn2, saidaUla: std_logic_vector(31 downto 0);
	signal des2muxPC: std_LOGIC_VECTOR(27 downto 0);
	signal muxRegEscOut: std_logic_vector(4 downto 0);
	signal opula: std_logic_vector(2 downto 0);
begin
	
	or2pc <= pcesc or (zeroUla and pcescCond);
	true<='1';
	PC: register_n_bits generic map(width=>32) 
			port map( 
			clk=>clock, reset=>reset, writeReg=>or2pc,
			d=>mux2pc, q=>pcout);
			
	MuxMem: mux2x1nbits generic map(width=>32)
			port map(
			inpt0=>pcout, inpt1=>ulaout, sel=>IouD,
			outp=>mux2mem);
	
	Memoria: memory_BRAM PORT map (
			address=>mux2mem(7 downto 0), 
			clock=>clock,
			data=>regBout,
			wren=>escMem, 
			q=>memOut);
			
	RegInst: register_n_bits generic map(width=>32)
			port map( 
			clk=>clock, reset=>reset, writeReg=>IREsc,
			d=>memOut, q=>instrucao	);
			
	RegDados: register_n_bits generic map(width=>32)
			port map( 
			clk=>clock, reset=>reset, writeReg=>'1', 
			d=>memout, q=>regDadoOut);

	MuxRegEsc: mux2x1nbits generic map(width=>5)
			port map(
			inpt0=>instrucao(20 downto 16),
			inpt1=>instrucao(15 downto 11),
			sel=>RegDst,
			outp=>muxRegEscOut);
			
	MuxDadoEsc: mux2x1nbits generic map (width=>32)
			port map(
			inpt0=>ULAout,
			inpt1=>regDadoOut,
			sel=>MemParaReg,
			outp=>muxDadoEscOut);
			
	BancoDeRegs: registerBank generic map(regWidth=>32, 
													  regLength=>32)
				port map(	clock, reset, 
						regWrite=>escReg,
						readReg1=> instrucao(25 downto 21), 
						readReg2=> instrucao(20 downto 16), 
						writeReg=> muxregEscOut, 
						writeData=> muxDadoEscOut,
						readData1=>readData1, readData2=>readData2);
					
	RegA: register_n_bits generic map(width=>32)
			port map( 
			clk=>clock, reset=>reset, writeReg=>true,
			d=>readData1, q=>regAout	);
				
	RegB: register_n_bits generic map(width=>32)
			port map( 
			clk=>clock, reset=>reset, writeReg=>true,
			d=>readData2, q=>regBout	);
	
	extSinal: signalExtend generic map(	finalWidth=>32,
													actualWidth=>16)
			port map(
				input=>instrucao(15 downto 0),
				output=>saiExt);
	
	desExt: shiftLeft2 generic map(n=>32)
			port map(	input=>saiExt,
					output=> des2muxUla);
	
	desPC: shiftLeft2 generic map(n=>28)
			port map(	input=> "00"&instrucao(25 downto 0),
				output=> des2muxPC);
			
	mux21ULA: Mux2x1nbits generic map (width=>32)
			port map(
			inpt0=>pcout,
			inpt1=>regAout,
			sel=>ulaFonteA,
			outp=>ulaIn1);
	
	mux41Ula: mux4x1nbits generic map(width=> 32)
		port map(
			inpt0=>regBout,
			inpt1=> "00000000000000000000000000000100",
			inpt2=> saiExt,
			inpt3=> des2muxUla,
			sel=>ulaFonteB,
			outp=> ulaIn2
		);
		
	BcUla: ALUcontrol
		port map(
			funct=>instrucao(5 downto 0),
			ALUop=>ulaOp,
			operation=> opULA
		);
		
	ULA: ALU generic map(dataWidth=>32)
		port map(
			ALUData0=>ulaIn1, 
			ALUData1=>ulaIn2,
			operation=>opula,
			ALUresult=>saidaUla,
			zero=>zeroUla
		);
		
				
	UlaReg: register_n_bits generic map(width=>32)
			port map( 
			clk=>clock, reset=>reset, writeReg=>true,
			d=>saidaUla, q=>ulaout	);
	
	mux31pc: Mux3x1nbits generic map( WID=>32 )
		PORT map(clk=>clock,
				a=>saidaUla,
				b=>ulaout,
				c=>"0000"&des2muxPC,
				sel=>fontePC,
				s => mux2pc);
	
end;



















