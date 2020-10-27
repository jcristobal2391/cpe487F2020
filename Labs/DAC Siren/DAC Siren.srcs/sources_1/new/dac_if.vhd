library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dac_if is
		port
		(	sclk	:	in std_logic;
			l_start	:	in std_logic;
			r_start	:	in std_logic;
			l_data	:	in signed (15 downto 0);
			r_data	: 	in signed (15 downto 0);
			sdata	:	out std_logic);
		end dac_if;
		
architecture Behavioral of dac_if is
		signal sreg :	std_logic_vector (15 downto 0);
	begin
		dac_pros	: process
		begin
			wait until falling_edge(sclk);
				if l_start = '1' then
					sreg <= std_logic_vector (l_data);
				elsif r_start = '1' then
					sreg <= std_logic_vector (r_data);
				else
					sreg <= sreg (14 downto 0) & '0';
				end if;
			end process;
			sdata <= sreg (15);
end Behavioral;