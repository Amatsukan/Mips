LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity MipsMult is
 port(clock, reset : in std_logic
 );
end entity;

architecture MipsM of MipsMult is 

	component BO is
		port(
			clock, reset: in std_logic;
			opcode: buffer std_logic_vector(5 downto 0);
			PCEscCond, PCEsc, IouD, LerMem,
			EscMem, MemParaReg, IREsc,
			RegDst, EscReg, ULAFonteA: in std_logic;
			ULAFonteB, ULAOp, FontePC: in std_logic_vector(1 downto 0)
		);
	end component;
	
	component BC is
		port(
			clock, reset: in std_logic;
			opcode: in std_logic_vector(5 downto 0);
			PCEscCond, PCEsc, IouD, LerMem,
			EscMem, MemParaReg, IREsc,
			RegDst, EscReg, ULAFonteA: out std_logic;
			ULAFonteB, ULAOp, FontePC: out std_logic_vector(1 downto 0)
		);
	end component;
	
	signal opcode: std_logic_vector(5 downto 0);
	signal PCEscCond, PCEsc, IouD, LerMem,
			EscMem, MemParaReg, IREsc,
			RegDst, EscReg, ULAFonteA: std_logic;
	signal ULAFonteB, ULAOp, FontePC: std_logic_vector(1 downto 0);
	
begin

	Bop : BO port map(
		clock, reset, opcode, PCEscCond, PCEsc, IouD, LerMem, EscMem, MemParaReg, IREsc, RegDst, EscReg, ULAFonteA,
		ULAFonteB, ULAOp, FontePC
	);
	Bco : BC port map(
		clock, reset, opcode, PCEscCond, PCEsc, IouD, LerMem, EscMem, MemParaReg, IREsc, RegDst, EscReg, ULAFonteA,
		ULAFonteB, ULAOp, FontePC
	);
end architecture;