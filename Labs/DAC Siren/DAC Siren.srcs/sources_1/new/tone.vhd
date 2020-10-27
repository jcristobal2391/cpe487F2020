library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tone is
	port
	( 	clk		:	in std_logic;
		pitch	:	in unsigned (13 downto 0);
		data	: 	out signed (15 downto 0));
	end tone;
	
architecture Behavioral of tone is
	signal count	:	unsigned (15 downto 0);
	signal quad		:	std_logic_vector(1 downto 0);
	signal index 	:	signed (15 downto 0);
begin
	cnt_pr	:	process
	begin
		wait until rising_edge (clk);
		count <= count + pitch;
	end process;
	quad <= std_logic_vector (count (15 downto 14));
	index <= signed ("00" & count (13 downto 0));
	
	with quad select
	data <= index when "00",
			16383 - index when "01",
			0 - index when "10",
			index - 16383 when others;
end Behavioral;