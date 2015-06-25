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
	
	process(reset, opcode, regSa, regPs) is
	begin
	
		if(reset = '1') then
			regPs<=s0;
		end if;
		
		if(regSa = s0) then
			regPs<=s1;
			
		elsif(regSa = s1)then
		
			if(opcode = "100011" or opcode = "101011") then
				regPs<=s2;
			elsif(opcode= "000000")then
				regPs<=s6;
			elsif(opcode= "000100")then
				regPs<=s8;
			else
				regPs<=s9;
			end if;
			
		elsif(regSa = s2) then
			
			if(opcode = "100011") then
				regPs<=s3;
			else
				regPs<=s5;
			end if;
			
		elsif(regSa=s3) then
			regPs<=s4;
		
		elsif(regSa=s6) then
			regPs<=s7;
			
		else
			regPs<=s0;
		end if;
		
	end process;
	
	proEnableRegs : process(regSa) is
	begin
	
		if (regSa = s0) then
			
			LerMem<='1';
			IREsc<='1';
			PCEsc<='1';	
			EscMem<='0'; 
			EscReg<='0';
			PCEscCond<='0';
			
		elsif (regSa = s1) then
			
			LerMem<='0';
			IREsc<='0';
			PCEsc<='0';	
			EscMem<='0'; 
			EscReg<='0';
			PCEscCond<='0';
			
		elsif (regSa = s2) then
			
			LerMem<='0';
			IREsc<='0';
			PCEsc<='0';	
			EscMem<='0'; 
			EscReg<='0';
			PCEscCond<='0';
			
		elsif (regSa = s3) then
		
			LerMem<='1';
			IREsc<='0';
			PCEsc<='0';	
			EscMem<='0'; 
			EscReg<='0';
			PCEscCond<='0';
		
		elsif (regSa = s4) then
		
			LerMem<='0';
			IREsc<='0';
			PCEsc<='0';	
			EscMem<='0'; 
			EscReg<='1';
			PCEscCond<='0';
		
		elsif (regSa = s5) then
		
			LerMem<='0';
			IREsc<='0';
			PCEsc<='0';	
			EscMem<='1'; 
			EscReg<='0';
			PCEscCond<='0';
		
		elsif (regSa = s6) then
		
			LerMem<='0';
			IREsc<='0';
			PCEsc<='0';	
			EscMem<='0'; 
			EscReg<='0';
			PCEscCond<='0';
		
		elsif (regSa = s7) then
		
			LerMem<='0';
			IREsc<='0';
			PCEsc<='0';	
			EscMem<='0'; 
			EscReg<='1';
			PCEscCond<='0';
		
		elsif (regSa = s8) then
		
			LerMem<='0';
			IREsc<='0';
			PCEsc<='1';	
			EscMem<='0'; 
			EscReg<='0';
			PCEscCond<='1';
		
		else -- regSa=s9
			
			LerMem<='0';
			IREsc<='0';
			PCEsc<='1';	
			EscMem<='0'; 
			EscReg<='0';
			PCEscCond<='0';
			
		end if;
		
	end process;
	
	proSignals : process(regSa) is
	begin
	
		if (regSa = s0) then
			
			ulafonteA<='0';
			iouD<='0';
			ulaFonteB<="01";
			ulaOp<="00";
			fontePC<="00";
			
		elsif (regSa = s1) then
			
			ulaFonteA<='0';
			ulaFonteB<="11";
			ulaOp<="00";
			
		elsif (regSa = s2) then
			
			ulaFonteA<='1';
			ulaFonteB<="10";
			ulaop<="00";
			
		elsif (regSa = s3) then
		
			iouD<='1';
		
		elsif (regSa = s4) then
		
			memParaReg<='1';
			regDst<='0';
		
		elsif (regSa = s5) then
		
			iouD<='1';
		
		elsif (regSa = s6) then
		
			ulaFonteA<='1';
			ulaFonteB<="00";
			ulaop<="10";
			
		elsif (regSa = s7) then
		
			regDst<='1';
			memParaReg<='0';
		
		elsif (regSa = s8) then
		
			ulaFonteA<='1';
			ulaFonteB<="00";
			ulaop<="01";
			fontePC<="01";
		
		else -- regSa=s9
			
			fontePC<="10";
		end if;
		
	end process;
	
end architecture;