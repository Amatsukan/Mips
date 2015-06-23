
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signalExtend is
	generic(	finalWidth:  integer := 8;
				actualWidth: integer := 4);
	port(
		input:  in  std_logic_vector(actualWidth-1 downto 0);
		output: out std_logic_vector(finalWidth-1 downto 0)
	);
end entity;


architecture behavioral of signalExtend is
begin
	output(actualWidth-1 downto 0) <= input;
	output(finalWidth-1 downto actualWidth) <= (others=>input(actualWidth-1));
end architecture;