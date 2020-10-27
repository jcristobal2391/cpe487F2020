library ieee;
use ieee.std_logic_1164.all;

entity hexcount is
	port (clk_50MHz : in std_logic;
			anode : out std_logic_vector (3 downto 0);
			seg : out std_logic_vector (6 downto 0));
end hexcount;

architecture Behavioral of hexcount is

component counter is
	port(	clk : in std_logic;
			count: out std_logic_vector (3 downto 0));
end component;

component leddec is
	port ( 	dig : in std_logic_vector(1 downto 0);
			data : in std_logic_vector (3 downto 0);
			anode :out std_logic_vector (3 downto 0);
			seg : out std_logic_vector (6 downto 0));
end component;

signal S: std_logic_vector (3 downto 0);

begin
C1:		counter port map (clk => clk_50MHz, count=>S);
L1:		leddec port map (dig => "00", data=>S, anode => anode, seg=>seg);
end Behavioral;