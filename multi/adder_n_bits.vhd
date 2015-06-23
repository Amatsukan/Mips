library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity adder_n_bits is
	generic(width: integer := 8);
	port(
		a,b: in std_logic_vector(width-1 downto 0);
		sum: out std_logic_vector(width-1 downto 0)
	);
end entity;

architecture Behavioral of adder_n_bits is
begin
	sum <= std_logic_vector(signed(a)+signed(b));
end architecture;

