library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerBank is 
	generic(	regWidth: integer := 8; 
				regLength: integer := 32); 
	port(	clock, reset, 
			regWrite: in std_logic; 
			readReg1, readReg2, writeReg: in  std_logic_vector(4 downto 0); 
			writeData: in std_logic_vector(regWidth-1 downto 0);
			readData1, readData2: out std_logic_vector(regWidth-1 downto 0) 
	);
end entity;


architecture behavioral of registerBank is 
	type TpRegisterBank is array (0 to regLength-1) of std_logic_vector(regWidth-1 downto 0);
	signal registers, nextRegisters: TpRegisterBank;
begin
	process(clock, reset)
	begin
		if (reset='1') then
         rst: for i in TpRegisterBank'range loop
            registers(i) <= (others=>'0');
         end loop;
		elsif (rising_edge(clock)) then
		   registers <= nextRegisters;
		end if;
	end process;
	wrt: for i in TpRegisterBank'range generate
      nextRegisters(i) <= writeData when regWrite='1' and to_integer(unsigned(writeReg))=i else
                          registers(i); 
	end generate;
   readData1 <= registers(to_integer(unsigned(readReg1)));
   readData2 <= registers(to_integer(unsigned(readReg2)));
end architecture;