library ieee;
use ieee.std_logic_1164.all;

entity leddec16 is
	port
	(	dig		:	in std_logic_vector (1 downto 0);
		data	:	in std_logic_vector (15 downto 0);
		anode	:	out std_logic_vector (3 downto 0);
		seg		: 	out std_logic_vector (6 downto 0));
end leddec16;

architecture Behavioral of leddec16 is
	signal data4	:	std_logic_vector (3 downto 0);
begin
	data4 <= data(3 downto 0) when dig = "00" else
				data(7 downto 4) when dig = "01" else
				data(11 downto 8) when dig = "10" else
				data(15 downto 12);
		seg <= "0000001" when data4 = "0000" else --0
			   "1001111" when data4 = "0001" else --1
			   "0010010" when data4 = "0010" else --2
			   "0000110" when data4 = "0011" else --3
			   "1001100" when data4 = "0100" else --4
			   "0100100" when data4 = "0101" else --5
			   "0100000" when data4 = "0110" else --6
			   "0001111" when data4 = "0111" else --7
			   "0000000" when data4 = "1000" else --8
			   "0000100" when data4 = "1001" else --9
			   "0001000" when data4 = "1010" else --A
			   "1100000" when data4 = "1011" else --B
			   "0110001" when data4 = "1100" else --C
			   "1000010" when data4 = "1101" else --D
			   "0110000" when data4 = "1110" else --E
			   "0111000" when data4 = "1111" else --F
			   "1111111";
		
		anode <= "1110" when dig = "00" else -- digit 0
				 "1101" when dig = "01" else -- digit 1
				 "1011" when dig = "10" else -- digit 2
				 "0111" when dig = "11" else -- digit 3
				 "1111";
end Behavioral;