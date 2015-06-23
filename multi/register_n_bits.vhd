library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity register_n_bits is    
	generic(width: integer := 8);
	port( 
		clk, reset, writeReg: in std_logic;
		d: in std_logic_vector(width-1 downto 0);
		q: out std_logic_vector(width-1 downto 0)
	);
end register_n_bits;

architecture Behavioral of register_n_bits is
   signal state, nextState: std_logic_vector(width-1 downto 0);
begin
	p1: process (clk, reset) 
	begin
		if (reset='1') then
			state <= (others => '0');
		elsif (rising_edge(clk)) then
			state <= nextState;
		end if;
	end process;
	nextState <= d when writeReg='1' else state;
	q <= state;
end Behavioral;

