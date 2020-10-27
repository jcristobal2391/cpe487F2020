library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ball is
	port( 	v_sync		: in std_logic;
			pixel_row	: in std_logic_vector(10 downto 0);
			pixel_col	: in std_logic_vector(10 downto 0);
			red			: out std_logic;
			green		: out std_logic;
			blue		: out std_logic );
end ball;

architecture Behavorial of ball is
	constant size	: integer := 8;
	signal ball_on	: std_logic; --is ball over pixel position
	--current ball position - initialized to center of screen
	signal ball_x 	: std_logic_vector(10 downto 0) := conv_std_logic_vector(400,11);
	signal ball_y	: std_logic_vector(10 downto 0) := conv_std_logic_vector(300,11);
	-- current ball motion - initalized to +4 pixels/frame
	signal ball_y_motion : std_logic_vector(10 downto 0) := "00000000100";
	
begin
	red <= '1' ; --color for red ball on white background
	green <= not ball_on;
	blue <= not ball_on;
	--process to draw ball current pixel address covered by ball position
	bdraw : process (ball_x, ball_y, pixel_row, pixel_col) is
		begin
				if (pixel_col >= ball_x - size) and
					(pixel_col <= ball_x + size) and
					(pixel_row >= ball_y - size) and
					(pixel_row <= ball_y + size) then
						ball_on <= '1';
					else ball_on <= '0';
					end if;
					end process;
				-- process to move ball once every frame
		mball : process
		begin
				wait until rising_edge(v_sync);
				--allow for bounce off top or bottom of screen
				if ball_y + size >= 600 then
					ball_y_motion <= "11111111100"; -- -4 pixels
				elsif ball_y <= size then
					ball_y_motion <= "00000000100"; -- +4 pixels
				end if;
				ball_y <= ball_y + ball_y_motion; --compute next ball position
			end process;
end behavioral;