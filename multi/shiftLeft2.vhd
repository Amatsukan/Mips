library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity shiftLeft2 is
	generic(n: integer := 8);
	port(	input:  in  std_logic_vector(n-1 downto 0);
			output: out std_logic_vector(n-1 downto 0)
	);
end entity;


architecture behavioral of shiftLeft2 is
begin
	output <= input(n-1 downto 2) & "00";
end architecture;