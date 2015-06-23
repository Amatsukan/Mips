library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUcontrol is
	port(
		funct: in std_logic_vector(5 downto 0);
		ALUop: in std_logic_vector(1 downto 0);
		operation: out std_logic_vector(2 downto 0)
	);
end entity;


architecture behavioral of ALUcontrol is
begin
	operation <=	"010" when ALUOp="00" 											else
						"110" when ALUOp(0)='1' 										else
						"010" when ALUOp(1)='1' and funct(3 downto 0)="0000"	else
						"110" when ALUOp(1)='1' and funct(3 downto 0)="0010"	else
						"000" when ALUOp(1)='1' and funct(3 downto 0)="0101"	else
						"111";
end architecture;
