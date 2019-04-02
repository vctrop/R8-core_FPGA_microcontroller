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
            when "0000" => segment <= "00000011"; -- "0"     
            when "0001" => segment <= "10011111"; -- "1" 
            when "0010" => segment <= "00100101"; -- "2" 
            when "0011" => segment <= "00001101"; -- "3" 
            when "0100" => segment <= "10011001"; -- "4" 
            when "0101" => segment <= "01001001"; -- "5" 
            when "0110" => segment <= "01000001"; -- "6" 
            when "0111" => segment <= "00011111"; -- "7" 
            when "1000" => segment <= "00000001"; -- "8"     
            when "1001" => segment <= "00001001"; -- "9" 
            when "1010" => segment <= "00000101"; -- "A"
            when "1011" => segment <= "11000001"; -- "B"
            when "1100" => segment <= "01100011"; -- "C"
            when "1101" => segment <= "10000101"; -- "D"
            when "1110" => segment <= "01100001"; -- "E"
            when others => segment <= "01110001"; -- "F"
        end case; 
    end process;
end sequential;