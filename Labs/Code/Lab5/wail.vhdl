library.ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wail is
		port
		(	lo_pitch	:	in unsigned (13 downto 0);
			hi_pitch	:	in unsigned (13 downto 0);
			wspeed		:	in unsigned (7 downto 0);
			wclk		:	in std_logic;
			audio_clk	:	in std_logic;
			audio_data	:	out signed (15 downto 0));
		end wail;
	
architecture Behavioral of wail is
	component tone is
		port
		(	clk		:	in std_logic;
			pitch	:	in unsigned(13 downto 0);
			data	:	out signed (15 downto 0));
		end component;
		signal curr_pitch	:	unsigned (13 downto 0);
	begin
		wp	:	process
			variable updn	:	std_logic;
		begin
			wait until rising_edge(wclk);
			if curr_pitch	>=	hi_pitch then
				updn	:= '0';
			elsif curr_pitch <= lo_pitch then
				updn	:= '1';
			end if;
			if updn = '1' then
				curr_pitch <= curr_pitch + wspeed;
			else
				curr_pitch <= curr_pitch - wspeed;
			end if;
		end process;
		tgen : tone
		port map
		( clk => audio_clk,
			pitch => curr_pitch,
			data => audio_data);
end Behavioral;
