library IEEE;
use IEEE.STD_LOGIC_1164.all;			 
use ieee.std_logic_unsigned.ALL;


entity SegmentDecoder is
	port(
		digit  : in std_logic_vector(3 downto 0);
		segment : out std_logic_vector(7 downto 0)
    );
end SegmentDecoder;


architecture sequential of SegmentDecoder is		 
begin						
    --using output sequence as ABCDEFG. and activated on HIGH
    DECODER: process(digit)
    begin
        case digit is
            when "0000" => segment <= "00000010"; -- "0"     
            when "0001" => segment <= "10011110"; -- "1" 
            when "0010" => segment <= "00100100"; -- "2" 
            when "0011" => segment <= "00001100"; -- "3" 
            when "0100" => segment <= "10011000"; -- "4" 
            when "0101" => segment <= "01001000"; -- "5" 
            when "0110" => segment <= "01000000"; -- "6" 
            when "0111" => segment <= "00011110"; -- "7" 
            when "1000" => segment <= "00000000"; -- "8"     
            when "1001" => segment <= "00001000"; -- "9" 
            when "1010" => segment <= "00000100"; -- "A"
            when "1011" => segment <= "11000000"; -- "B"
            when "1100" => segment <= "01100010"; -- "C"
            when "1101" => segment <= "10000100"; -- "D"
            when "1110" => segment <= "01100000"; -- "E"
            when "1111" => segment <= "01110000"; -- "F"
	    when others => segment <= "00000000";
        end case; 
    end process;
end sequential;