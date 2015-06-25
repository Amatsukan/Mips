library ieee;
use ieee.std_logic_1164.all;

entity BC is
	port(
		clock, reset: in std_logic;
		opcode: in std_logic_vector(5 downto 0);
		PCEscCond, PCEsc, IouD, LerMem,
		EscMem, MemParaReg, IREsc,
		RegDst, EscReg, ULAFonteA: out std_logic;
		ULAFonteB, ULAOp, FontePC: out std_logic_vector(1 downto 0)
	);
end entity;

architecture Control of BC is 
type states is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9);
signal regSa, regPs : states;
begin
	process(clock, reset)is
	begin
		if(reset = '1') then
			regSa <= s0;
		elsif rising_edge(clock) then
			regSa<=regPs;
		end if;
	end process;
	
end architecture;