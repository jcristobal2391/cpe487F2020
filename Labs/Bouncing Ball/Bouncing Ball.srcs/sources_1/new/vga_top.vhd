library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity vga_top is
	port
	( clk_in		:	in	std_logic;
		vga_red		:	out	std_logic_vector(2 downto 0);
		vga_green	:	out std_logic_vector(2 downto 0);
		vga_blue	: 	out	std_logic_vector(1 downto 0);
		vga_hsync	:	out	std_logic;
		vga_vsync	:	out std_logic );
	end vga_top;
	
architecture Behavioral of vga_top is
	signal pxl_clk	:	std_logic;
	signal s_red, s_green, s_blue : std_logic;
	signal s_vsync : std_logic;
	signal s_pixel_row, s_pixel_col	:	std_logic_vector(10 downto 0);
	component ball is
		port
		(	v_sync		: in std_logic;
			pixel_row	: in std_logic_vector(10 downto 0);
			pixel_col	: in std_logic_vector(10 downto 0);
			red			: out std_logic;
			green		: out std_logic;
			blue		: out std_logic);
	end component;
	
	component vga_sync is
		port
		(	pixel_clk	:	in std_logic;
			red_in		:	in std_logic;
			green_in	:	in std_logic;
			blue_in		:	in std_logic;
			red_out		:	out std_logic;
			green_out	:	out std_logic;
			blue_out	:	out std_logic;
			hsync		:	out std_logic;
			vsync		:	out	std_logic;
			pixel_row	:	out std_logic_vector (10 downto 0);
			pixel_col	:	out std_logic_vector (10 downto 0));
	end component;
	
	component clk_wiz_0 is
		port
		( clk_in1		:	in std_logic;
			clk_out1 	:	out std_logic);
	end component;
	
begin
	vga_red(1 downto 0) <= "00";
	vga_green(1 downto 0) <= "00";
	vga_blue (0) <= '0';
	
	add_ball : ball
	port map
	( 	v_sync		=> s_vsync,
		pixel_row	=> s_pixel_row,
		pixel_col	=> s_pixel_col,
		red			=> s_red,
		green		=> s_green,
		blue		=> s_blue);
	
	vga_driver : vga_sync
	port map
	( 	pixel_clk		=> pxl_clk,
		red_in			=> s_red,
		green_in		=> s_green,
		blue_in			=> s_blue,
		red_out			=> vga_red(2),
		green_out		=> vga_green(2),
		blue_out		=> vga_blue(1),
		pixel_row		=> s_pixel_row,
		pixel_col		=> s_pixel_col,
		hsync			=> vga_hsync,
		vsync			=> s_vsync);
	vga_vsync <= s_vsync;
	
	clk_wiz_0_inst	: clk_wiz_0
	port map
	(	clk_in1 	=> clk_in,
		clk_out1	=> pxl_clk);
end Behavioral;
	
	