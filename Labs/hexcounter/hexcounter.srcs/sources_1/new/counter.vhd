library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
	Port (clk : in std_logic;
			count :out std_logic_vector (3 downto 0));
end counter;

architecture Behavioral of counter is
signal cnt: std_logic_vector (28 downto 0); --29 bit counter
begin
	process(clk)
	begin
		if clk'event and clk='1' then --on rising edge of clock
			cnt <= cnt +1; --increment counter
		end if;
	end process;
	count <= cnt (28 downto 25);
end Behavioral;