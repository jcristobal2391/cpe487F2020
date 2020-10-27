library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bat_n_ball is
	port
	( 	v_sync		:	in std_logic;
		pixel_row	:	in std_logic_vector(10 downto 0);
		pixel_col	:	in std_logic_vector(10 downto 0);
		bat_x		:	in std_logic_vector(10 downto 0);
		serve		:	in std_logic;
		red			:	out std_logic;
		green		:	out std_logic;
		blue		:	out	std_logic);
	end bat_n_ball;
	
architecture Behavioral of bat_n_ball is
		constant bsize	: integer := 8;
		constant bat_w	: integer := 20;
		constant bat_h	: integer := 3;
		
		constant ball_speed	:	std_logic_vector(10 downto 0) := conv_std_logic_vector (6,11);
		signal ball_on	:	std_logic;
		signal bat_on	:	std_logic;
		signal game_on	:	std_logic := '0';
		
		signal ball_x	:	std_logic_vector(10 downto 0) := conv_std_logic_vector(400,11);
		signal ball_y	:	std_logic_vector(10 downto 0) := conv_std_logic_vector(300,11);
		
		constant bat_y	:	std_logic_vector(10 downto 0) := conv_std_logic_vector(500,11);
		
		signal ball_x_motion, ball_y_motion	:	std_logic_vector (10 downto 0)	:= ball_speed;
	begin
		red <= not bat_on;
		green <= not ball_on;
		blue <= not ball_on;
		
		balldraw	:	process (ball_x, ball_y, pixel_row, pixel_col) is
				variable vx, vy : std_logic_vector (10 downto 0);
			begin
				if pixel_col <= ball_x then
					vx	:= ball_x - pixel_col;
				else vx	:= pixel_col - ball_x;
				end if;
				
				if pixel_row <= ball_y then
					vy := ball_y - pixel_row;
				else vy := pixel_row - ball_y;
				end if;
			if((vx*vx) + (vy * vy)) < (bsize * bsize) then
				ball_on <= game_on;
			else ball_on <= '0';
			end if;
	end process;
	
	mball	:	process
		variable temp : std_logic_vector (11 downto 0);
	begin
		wait until rising_edge (v_sync);
		if serve = '1' and game_on = '0' then
			game_on <= '1';
			ball_y_motion <= (not ball_speed) + 1;
		elsif ball_y <= bsize then
			ball_y_motion <= ball_speed;
		elsif ball_y + bsize >= 600 then
			ball_y_motion <= (not ball_speed) + 1;
			game_on <= '0';
		end if;
		
		if ball_x + bsize >= 800 then
			ball_x_motion <= (not ball_speed) + 1;
		elsif ball_x <= bsize then
			ball_x_motion <= ball_speed;
		end if;
		
		if (ball_x + bsize/2) >= (bat_x - bat_w) and
			(ball_x - bsize/2) <= (bat_x + bat_w) and
			(ball_y + bsize/2) >= (bat_y - bat_h) and
			(ball_y - bsize/2) <= (bat_y + bat_h) then
				ball_y_motion <= (not ball_speed) +1;
		end if;
		
		temp := ('0' & ball_y) + (ball_y_motion (10) & ball_y_motion);
		if game_on = '0' then
			ball_y <= conv_std_logic_vector (440, 11);
		elsif temp (11) = '1' then
			ball_y <= (others => '0');
		else ball_y <= temp (10 downto 0);
		end if;
		
		temp := ('0' & ball_x) + (ball_x_motion (10) & ball_x_motion);
		if temp(11) = '1' then
			ball_x <= (others => '0');
		else ball_x <= temp (10 downto 0);
		end if;
		end process;
end Behavioral;