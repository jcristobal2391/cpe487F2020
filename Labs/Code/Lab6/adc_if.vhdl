library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity adc_if is
		port
		(	sck		:	in std_logic;
			sdata1	:	in std_logic;
			sdata2	:	in std_logic;
			cs		:	in std_logic;
			data_1	:	out std_logic_vector(11 downto 0);
			data_2	:	out std_logic_vector(11 downto 0));
	end adc_if;
	
architecture Behavioral of adc_if is
		signal pdata1, pdata2	:	std_logic_vector (11 downto 0);
	begin
		adpr	:	process
		begin
			wait until falling_edge	(sck);
			if cs = '0' then
				pdata1 <= pdata1 (10 downto 0) & sdata1;
				pdata2 <= pdata2 (10 downto 0) & sdata2;
			end if;
		end process;
		
		sync	:	process
		begin
			wait until rising_edge(cs);
			data_1 <= pdata1;
			data_2 <= pdata2;
		end process;
end Behavioral;