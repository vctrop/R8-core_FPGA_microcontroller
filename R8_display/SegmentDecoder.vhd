library IEEE;
use IEEE.STD_LOGIC_1164.all;			 
use ieee.std_logic_unsigned.ALL;


entity SegmentDecoder is
	port(
		digit  : in std_logic_vector(3 downto 0);
		segment : out std_logic_vector(7 downto 0)
    );
end SegmentDecoder;


architecture combinational of SegmentDecoder is		 
begin						
    --using output sequence as ABCDEFG. and activated on HIGH
	segment <= 	"00000011" when  digit = x"0" else
				"10011111" when  digit = x"1" else
				"00100101" when  digit = x"2" else
				"00001101" when  digit = x"3" else
				"10011001" when  digit = x"4" else
				"01001001" when  digit = x"5" else
				"01000001" when  digit = x"6" else
				"00011111" when  digit = x"7" else
				"00000001" when  digit = x"8" else
				"00001001" when  digit = x"9" else
				"00000101" when  digit = x"A" else
				"11000001" when  digit = x"B" else
				"01100011" when  digit = x"C" else
				"10000101" when  digit = x"D" else
				"01100001" when  digit = x"E" else
				"01110001";            -- "F"
end combinational;