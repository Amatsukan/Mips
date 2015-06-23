library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	generic(dataWidth: integer := 8);
	port(
		ALUData0, 
		ALUData1: 	in  std_logic_vector(dataWidth-1 downto 0);
		operation:	in  std_logic_vector(2 downto 0);
		ALUresult:  out std_logic_vector(dataWidth-1 downto 0);
		zero:       out std_logic
	);
end entity;


architecture behavioral of ALU is
	signal add, sub, slt, result: std_logic_vector(dataWidth-1 downto 0);
begin
	zero <= '1' when result=std_logic_vector(to_unsigned(0,dataWidth)) else '0';
	slt <= (others=>'1') when ALUData0 < ALUData1 else (others=>'0');
	add <= std_logic_vector(signed(ALUData0) + signed(ALUData1));
	sub <= std_logic_vector(signed(ALUData0) - signed(ALUData1));
	ALUresult <= result;
	with operation select
		result <=	ALUData0 and ALUData1	when "000",
						ALUData0	or  ALUData1	when "001",
						add							when "010",
						sub							when "110",
						slt							when others;
end;