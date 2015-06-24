LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Mux21 IS
	generic ( WID : integer := 32 );
PORT (clk, carga : IN STD_LOGIC;
	  a,b : IN STD_LOGIC_VECTOR(WID DOWNTO 0);
	  sel : in std_LOGIC;
	  s : out std_LOGIC_VECTOR(WID DOWNTO 0));
END entity;

architecture mux of Mux21 is
begin
	WITH sel SELECT
         s <= a WHEN '0',
              b WHEN OTHERS;
end architecture;