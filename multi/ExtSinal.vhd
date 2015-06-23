LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity extSinal is 
	generic(w1 : integer := 16; w2 : integer := 32);
	port(
		ent : in std_logic_vector(w1 downto 0);
		sai : out std_logic_vector(w2 downto 0));
end entity;

architecture 