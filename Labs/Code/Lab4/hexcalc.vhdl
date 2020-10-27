library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity hexcalc is
	port
	(	clk_50MHz	:	in std_logic;
		seg7_anode	:	out std_logic_vector (3 downto 0);
		seg7_seg	:	out std_logic_vector (6 downto 0);
		bt_clr		:	in std_logic;
		bt_plus		:	in std_logic;
		bt_eq		:	in std_logic;
		kb_col		:	out std_logic_vector (4 downto 1);
		kb_row		:	in std_logic_vector (4 downto 1));
end hexcalc;

architecture Behavioral of hexcalc is
	component keypad is
		port
		(	samp_ck	:	in std_logic;
			col		:	out std_logic_vector(4 downto 1);
			row		:	in	std_logic_vector(4 downto 1);
			value	:	out std_logic_vector(3 downto 0);
			hit		:	out std_logic);
	end component;
	
	component leddec16 is
		port
		(	dig		:	in std_logic_vector(1 downto 0);
			data	:	in std_logic_vector(15 downto 0);
			anode	:	out std_logic_vector(3 downto 0);
			seg		:	out std_logic_vector(6 downto 0));
	end component;
	
	signal cnt	:	std_logic_vector(20 downto 0);
	signal kp_clk, kp_hit, sm_clk	:	std_logic;
	signal kp_value	:	std_logic_vector(3 downto 0);
	signal nx_acc, acc	:	std_logic_vector (15 downto 0);
	signal nx_operand, operand	: std_logic_vector (15 downto 0);
	signal display : std_logic_vector (15 downto 0);
	signal led_mpx	: std_logic_vector (1 downto 0);
	type state is (enter_acc, acc_release, start_op, op_release, enter_op, show_result);
	signal pr_state, nx_state : state;

begin
	ck_proc	: process (clk_50MHz)
	begin
		if rising_edge(clk_50MHz) then
			cnt <= cnt + 1;
		end if;
	end process;
	kp_clk <= cnt(15);
	sm_clk <= cnt(20);
	led_mpx <= cnt(18 downto 17);
	kp1	: keypad
		port map
			( 	dig => led_mpx, data => display,
				anode => seg7_anode, seg => seg7_seg);
		sm_ck_pr	: process (bt_clr, sm_clk)
		begin
				if bt_clr ='1' then
					acc <= X"0000";
					operand <= X"0000";
					pr_state <= enter_acc;
				elsif rising_edge (sm_clk) then
					pr_state <= nx_state;
					acc <= nx_acc;
					operand <= nx_operand;
				end if;
		end process;
		
		sm_comb_pr	:	process (kp_hit, kp_value, bt_plus, bt_eq, acc, operand, pr_state)
		begin
			nx_acc <= acc;
			nx_operand <= operand;
			display <= acc;
				case pr_state is
					when enter acc =>
						if kp_hit = '1' then
							nx_acc <= acc(11 downto 0) & kp_value;
							nx_state <= acc_release;
						elsif bt_plus ='1' then
								nx_state <= start_op;
						else
								nx_state <= enter_acc;
						end if;
					when acc_release =>
							if kp_hit = '0' then
								nx_state <= enter_acc;
							else nx_state <= acc_release;
							end if;
					when start_op =>
							if kp_hit = '1' then
								nx_operand <= X"000" & kp_value;
								nx_state <= op_release;
								display <= operand;
							else nx_state <= start_op;
							end if;
					when op_release =>
							display <= operand;
							if kp_hit ='0' then
								nx_state <= enter_op;
							else nx_state <= op_release;
							end if;
					when enter_op =>
							display <= operand;
							if bt_eq = '1' then
								nx_acc <= acc + operand;
								nx_state <= show_result;
							elsif kp_hit = '1' then
								nx_operand <= operand(11 downto 0) & kp_value;
								nx_state <= op_release;
							else nx_state <= enter_op;
							end if;
					when show_result =>
							if kp_hit = '1' then
								nx_acc <= X"000" & kp_value;
								nx_state <= acc_release;
							else nx_state <= show_result;
							end if;
					end case;
				end process;
end Behavioral;