library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
	Port (clk : in std_logic;
			count :out std_logic_vector (15 downto 0); --16 bits revision
			mpx : out std_logic_vector (1 downto 0)); --sends signals to displays
end counter;

architecture Behavioral of counter is
	signal cnt: std_logic_vector (38 downto 0); --39 bit counter
begin
	process(clk)
	begin
		if clk'event and clk='1' then --on rising edge of clock
			cnt <= cnt +1; --increment counter
		end if;
	end process;
	count <= cnt (38 downto 23); --16bits
	mpx <= cnt (18 down to 17); --2bits
end Behavioral;