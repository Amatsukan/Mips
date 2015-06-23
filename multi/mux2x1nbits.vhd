library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity mux2x1nbits is
	generic(width: integer := 8);
	port(
		inpt0: in std_logic_vector(width-1 downto 0);
		inpt1: in std_logic_vector(width-1 downto 0);
		sel: in std_logic;
		outp: out std_logic_vector(width-1 downto 0)
	);
end entity;

architecture Behavioral of mux2x1nbits is
begin
	outp <= inpt0 when sel='0' else inpt1;
end architecture;

