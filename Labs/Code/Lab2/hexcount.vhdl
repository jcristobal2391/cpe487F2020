library ieee;
use ieee.std_logic_1164.all;

entity hexcount is
	port (clk_50MHz : in std_logic;
			anode : out std_logic_vector (3 downto 0);
			seg : out std_logic_vector (6 downto 0));
end hexcount

architecture Behavioral of hexcount is

component counter is
	port(	clk : in std_logic;
			count: out std_logic_vector (15 downto 0); --counter output 16 bits for 4 displays
			mpx : out std_logic_vector (1 downto 0));
end component;

component leddec is
	port ( 	dig : in std_logic_vector(1 downto 0);
			data : in std_logic_vector (3 downto 0); --data fixed 4 bits for each displays
			anode :out std_logic_vector (3 downto 0);
			seg : out std_logic_vector (6 downto 0));
end component;

signal S: std_logic_vector (15 downto 0); --C1 and L1 for values of 4 digits
signal md : std_logic_vector (1 downto 0); --mpx selects displays
signal display : std_logic_vector (3 downto 0);

begin
C1:		counter port map (clk => clk_100MHz, count=>S, mpx => md);
L1:		leddec port map (dig => md, data=> display, anode => anode, seg=>seg);

display <= S (3 downto 0) when md ="00" else
			S (7 downto 4) when md = "01" else
			S (11 downto 8) when md = "10" else
			S (15 downto 12);

end Behavioral;