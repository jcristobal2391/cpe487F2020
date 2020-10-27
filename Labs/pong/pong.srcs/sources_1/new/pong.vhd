library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pong is
	port
	(	clk_in		:	in std_logic;
		vga_red		:	out std_logic_vector (3 downto 0);
		vga_green	:	out std_logic_vector (3 downto 0);
		vga_blue	:	out std_logic_vector (3 downto 0);
		vga_hsync	:	out std_logic;
		vga_vsync	:	out std_logic;
		adc_cs		:	out std_logic;
		adc_sclk	:	out std_logic;
		adc_sdata1	:	in	std_logic;
		adc_sdata2	:	in	std_logic;
		btn0		:	in  std_logic);
	end pong;
	
architecture Behavioral of pong is
		signal pxl_clk	:	std_logic	:= '0';
		signal s_red, s_green, s_blue	:	std_logic;
		signal s_vsync	:	std_logic;
		signal s_pixel_row, s_pixel_col	: std_logic_vector (10 downto 0);
		signal batpos	:	std_logic_vector (10 downto 0);
		signal serial_clk, sample_clk	:	std_logic;
		signal adout	:	std_logic_vector (11 downto 0);
		signal count	:	std_logic_vector (9 downto 0);
		
		component adc_if is
			port
			(	sck		:	in std_logic;
				sdata1	:	in std_logic;
				sdata2	:	in std_logic;
				cs		:	in std_logic;
				data_1	:	out std_logic_vector(11 downto 0);
				data_2	:	out std_logic_vector(11 downto 0));
		end component;	
	
		component bat_n_ball is
			port
			(	v_sync		:	in std_logic;
				pixel_row	:	in std_logic_vector(10 downto 0);
				pixel_cow	:	in std_logic_vector(10 downto 0);
				bat_x		:	in std_logic_vector(10 downto 0);
				serve		:	in std_logic;
				red			:	out std_logic;
				green		:	out std_logic;
				blue		:	out std_logic);
		end component;	
		component vga_sync is
			port
			(	pixel_clk	:	in std_logic;
				red_in		: 	in std_logic_vector(3 downto 0);
				green_in	:	in std_logic_vector(3 downto 0);
				blue_in		:	in std_logic_vector(3 downto 0);
				red_out		:	out std_logic_vector(3 downto 0);
				green_out	:	out std_logic_vector(3 downto 0);
				blue_out	:	out std_logic_vector(3 downto 0);
				hsync		:	out std_logic;
				vsync		:	out std_logic;
				pixel_row	:	out std_logic_vector(10 downto 0);
				pixel_col	:	out std_logic_vector(10 downto 0));
			end component;
		
		component clk_wiz_0 is
		port
		(	clk_in1		:	in std_logic;
			clk_out1	:	in std_logic);
		end component;
		
	begin
		ckp	: process
		
		begin
			wait until rising_edge(clk_in);
				count <= count + 1;
		end process;
	
		serial_clk	<= not count (4);
		adc_sclk 	<= serial_clk;
		sample_clk	<= count(9);
		adc_cs		<= sample_clk;
		
		batpos <= ("00" & adout (11 downto 3)) + adout (11 downto 4);
		
		adc :	adc_if
		port map
		( 	sck		=> serial_clk,
			cs		=> sample_clk,
			sdata1	=> adc_sdata1,
			sdata2	=> adc_sdata2,
			data_1	=> open,
			data_2	=> adout);
		
		add_bb	:	bat_n_ball
		port map
		(	v_sync		=> s_vsync,
			pixel_row	=> s_pixel_row,
			pixel_col	=> s_pixel_col,
			bat_x		=> batpos,
			serve		=> btn0,
			red			=> s_red,
			green		=> s_green,
			blue		=> s_blue);
		
		vga_driver	:	vga_sync
		port map
		(	pixel_clk	=> 	pxl_clk,
			red_in		=>	s_red & "000",
			green_in	=> 	s_green & "000",
			blue_in		=>	s_blue & "000",
			red_out		=>	vga_red,
			green_out	=>	vga_green,
			blue_out	=>	vga_blue,
			pixel_row	=>	s_pixel_row,
			pixel_col	=>	s_pixel_col,
			hsync		=> 	vga_hsync,
			vsync		=>	s_vsync);
		
		vga_vsync		<= s_vsync;
		
		clk_wiz_0_inst	:	clk_wiz_0
		port map
		(	clk_in1		=> 	clk_in,
			clk_out1	=>	pxl_clk);
	end Behavioral;