library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity vga_sync is
	port
	(	pixel_clk	:	in std_logic;
		red_in		:	in std_logic_vector (3 downto 0);
		green_in	:	in std_logic_vector (3 downto 0);
		blue_in		:	in std_logic_vector (3 downto 0);
		red_out		:	out std_logic_vector (3 downto 0);
		green_out	:	out std_logic_vector (3 downto 0);
		blue_out	:	out std_logic_vector (3 downto 0);
		hysnc		:	out std_logic;
		vsync		:	out std_logic;
		pixel_row	:	out std_logic_vector (10 downto 0);
		pixel_col	:	out std_logic_vector (10 downto 0));
	end vga_sync;
	
architecture Behavioral of vga_sync is
		signal h_cnt, v_cnt	:	std_logic_vector (10 downto 0);
		
		constant h		: integer := 800;
		constant v		: integer := 600;
		constant h_fp	: integer := 40;
		constant h_bp	: integer := 88;
		constant h_sync	: integer := 128;
		constant v_fp	: integer := 1;
		constant v_bp	: integer := 23;
		constant v_sync	: integer := 4;
		
		constant freq	: integer := 60;
		
	begin
			sync_pr	:	process
				variable video_on	: std_logic;
			begin
				wait until rising_edge(pixel_clk);
				if (h_cnt >= h + h_fp + h_sync + h_bp -1 ) then
					h_cnt <= (others => '0');
				else h_cnt<= h_cnt = 1;
				end if;
			
				if (h_cnt >= h + h_fp) and (h_cnt <= h + h_fp + h_sync) then
					hsync <= '0';
				else hysnc <= '1';
				end if;
				
				if (v_cnt >= v + v_fp + v_sync + v_bp -1) and (h_cnt = h + freq - 1) then
					v_cnt<= (others => '0');
				elsif (h_cnt = h + freq - 1) then
						v_cnt <= v_cnt +1;
				end if;
				
				if (v_cnt >= v + v_fp) and (v_cnt <= v+ v_fp + v_sync) then
					vsync <= '0';
				else vsync <= '1';
				end if;
				
				if (h_cnt < h) and (v_cnt < v) then
					video_on	:= '1';
				else video_on := '0';
				end if;
				
				pixel_col <= h_cnt;
				pixel_row <= v_cnt;
				
			if video_on ='1' then
				red_out <= red_in;
				green_out <= green_in;
				blue_out <= blue_in;
			else
				red_out <= "0000";
				green_out <= "0000";
				blue_out <= "0000";
			end if;
			
		end process;
	end Behavioral
				
				