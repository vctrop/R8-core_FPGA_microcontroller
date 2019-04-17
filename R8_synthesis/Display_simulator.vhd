library IEEE;
use IEEE.STD_LOGIC_1164.all;			 
use ieee.std_logic_unsigned.ALL;


entity Display_simulator is
	port(
        segment : in std_logic_vector(7 downto 0)
		digit   : out std_logic_vector(3 downto 0);
		
    );
end Display_simulator;


architecture combinational of Display_simulator is		 
begin			
    digit <= x"0" when segment = "00000011" else
             x"1" when segment = "10011111" else
             x"2" when segment = "00100101" else
             x"3" when segment = "00001101" else
             x"4" when segment = "10011001" else
             x"5" when segment = "01001001" else
             x"6" when segment = "01000001" else
             x"7" when segment = "00011111" else
             x"8" when segment = "00000001" else
             x"9" when segment = "00001001" else
             x"A" when segment = "00000101" else
             x"B" when segment = "11000001" else
             x"C" when segment = "01100011" else
             x"D" when segment = "10000101" else
             x"E" when segment = "01100001" else
             x"F"             -- "01110001"
                    
end combinational;