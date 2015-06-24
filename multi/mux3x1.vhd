LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Mux3x1nbits IS
	generic ( WID : integer := 32 );
PORT (clk : IN STD_LOGIC;
	  a,b,c : IN STD_LOGIC_VECTOR(WID-1 DOWNTO 0);
	  sel : in std_LOGIC_vector(1 downto 0);
	  s : out std_LOGIC_VECTOR(WID-1 DOWNTO 0));
END entity;

architecture mux of Mux3x1nbits is
begin
	WITH sel SELECT
         s <= a WHEN "00",
              b WHEN "01",
				  c WHEN others;
end architecture;