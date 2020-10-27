library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity siren is
	port
	(	clk_50MHz	:	in std_logic;
		dac_mclk	:	out std_logic;
		dac_lrck	:	out std_logic;
		dac_sclk	:	out std_logic;
		dac_sdin	:	out std_logic );
	end siren;

architecture Behavioral of siren is
	constant lo_tone : unsigned (13 downto 0) := to_unsigned (344, 14);
	constant hi_tone : unsigned (13 downto 0) := to_unsigned (687, 14);
	constant wail_speed : unsigned (7 downto 0) := to_unsigned (8, 8);
	component dac_if is
		port
		(	sclk	:	in std_logic;
			l_start	:	in std_logic;
			r_start	:	in std_logic;
			l_data	:	in signed (15 downto 0);
			r_data 	:	in signed (15 downto 0);
			sdata	:	out std_logic);
		end component;
		
	component wail is
		port
		(	lo_pitch	:	in unsigned (13 downto 0);
			hi_pitch	:	in unsigned (13 downto 0);
			wspeed		:	in unsigned (7 downto 0);
			wclk		:	in std_logic;
			audio_clk	:	in std_logic;
			audio_data	:	out signed (15 downto 0));
		end component;
	
	signal tcount	:	unsigned (19 downto 0) := (others => '0');
	signal data_l, data_r	: signed (15 downto 0);
	signal dac_load_l, dac_load_r	:	std_logic;
	signal slo_clk, sclk, audio_clk	:	std_logic;
begin
	tim_pr : process
	
	begin
		wait until rising_edge(clk_50MHz);
		if (tcount (9 downto 0) >= X"00F") and (tcount (9 downto 0) < X"02E") then
			dac_load_l <= '1';
		else
			dac_load_l <= '0';
		end if;
		
		if (tcount (9 downto 0) >= X"20F") and (tcount (9 downto 0) < X"22E") then
			dac_load_r <= '1';
		else dac_load_r <= '0';
		end if;
		tcount <= tcount + 1;
	end process;
	
		dac_mclk 	<= not tcount(1);
		audio_clk 	<= tcount (9);
		dac_lrck 	<= audio_clk;
		sclk 		<= tcount(4);
		dac_sclk 	<= sclk;
		slo_clk		<= tcount(19);
		dac		: dac_if
		port map
		(	sclk => sclk,
			l_start => dac_load_l,
			r_start => dac_load_r,
			l_data => data_l,
			r_data => data_r,
			sdata  => dac_sdin );
			wl : wail
		port map
		(	lo_pitch	=> lo_tone,
			hi_pitch	=> hi_tone,
			wspeed 		=> wail_speed,
			wclk		=> slo_clk,
			audio_clk	=> audio_clk,
			audio_data 	=> data_l);
		
		data_r <= data_l;
end Behavioral;
	