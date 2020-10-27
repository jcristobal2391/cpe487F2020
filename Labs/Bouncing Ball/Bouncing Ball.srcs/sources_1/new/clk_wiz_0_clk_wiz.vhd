library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity clk_wiz_0_clk_wiz is
port
 ( clk_in1      : in     std_logic;
   clk_out1     : out    std_logic);
end clk_wiz_0_clk_wiz;

architecture xilinx of clk_wiz_0_clk_wiz is
  -- Input clock buffering / unused connectors
  signal clk_in1_clk_wiz_0      : std_logic;
  -- Output clock buffering / unused connectors
  signal clkfbout_clk_wiz_0         : std_logic;
  signal clkfbout_buf_clk_wiz_0     : std_logic;
  signal clkfboutb_unused : std_logic;
  signal clk_out1_clk_wiz_0          : std_logic;
  signal clkout0b_unused         : std_logic;
  signal clkout1_unused   : std_logic;
  signal clkout1b_unused         : std_logic;
  signal clkout2_unused   : std_logic;
  signal clkout2b_unused         : std_logic;
  signal clkout3_unused   : std_logic;
  signal clkout3b_unused  : std_logic;
  signal clkout4_unused   : std_logic;
  signal clkout5_unused   : std_logic;
  signal clkout6_unused   : std_logic;
  -- Dynamic programming unused signals
  signal do_unused        : std_logic_vector(15 downto 0);
  signal drdy_unused      : std_logic;
  -- Dynamic phase shift unused signals
  signal psdone_unused    : std_logic;
  signal locked_int : std_logic;
  -- Unused status signals
  signal clkfbstopped_unused : std_logic;
  signal clkinstopped_unused : std_logic;

begin
	--input buffering
		clk_in1_clk_wiz_0 <= clk_in1;
	mmcm_adv_inst : MMCME2_ADV
	generic map
	(	bandwidth			=> "optimized",
		clkout4cascade		=> false,
		compensation		=> "zhold",
		startup_wait		=> false,
		divclk_divide		=> 1,
		clkfbout_mult_f		=> 10.125,
		clkfbout_phase		=> 0.000,
		clkfbout_use_fine_ps => false,
		clkout0_divide_f 	=> 25.3125,
		clkout0_phase		=> 0.000,
		clkout0_duty_cycle	=> 0.500,
		clkout0_use_fine_ps	=> false,
		clkin1_period 		=> 10.0,
		ref_jitter1			=> 0.010)
	port map --output clocks
	(	clkfbout 			=> clkfbout_clk_wiz_0,
		clkfboutb			=> clkfboutb_unused,
		clkout0				=> clk_out1_clk_wiz_0,
		clkout0b			=> clkout0b_unused,
		clkout1				=> clkout1_unused,
		clkout1b			=> clkout1b_unused,
		clkout2				=> clkout2_unused,
		clkout2b			=> clkout2b_unused,
		clkout3				=> clkout3_unused,
		clkout3b			=> clkout3b_unused,
		clkout4				=> clkout4_unused,
		clkout5				=> clkout5_unused,
		clkout6				=> clkout6_unused,
		
		clkfbin				=> clkfbout_buf_clk_wiz_0,
		clkin1				=> clk_in1_clk_wiz_0,
		clkin2				=> '0',
		
		clkinsel			=> '1',
		
		daddr				=> (others => '0'),
		dclk				=> '0',
		den					=> '0',
		di					=> (others => '0'),
		do					=> do_unused,
		drdy				=> drdy_unused,
		dwe					=> '0',
		
		psclk				=> '0',
		psen				=> '0',
		psincdec			=> '0',
		psdone				=> psdone_unused,
		
		locked				=> locked_int,
		clkinstopped		=> clkinstopped_unused,
		clkfbstopped		=> clkfbstopped_unused,
		pwrdown				=> '0',
		rst					=> '0');

clkf_buf : BUFG
	port map
	(	O	=> clkfbout_buf_clk_wiz_0,
		I 	=>	clkfbout_clk_wiz_0);
		
clkout1_buf	: BUFG
	port map
	(	O	=> clk_out1,
		I	=> clk_out1_clk_wiz_0);
end xilinx;