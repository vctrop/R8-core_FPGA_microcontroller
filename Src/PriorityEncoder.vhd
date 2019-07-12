-----------------------------------------------------------------------------
-- DESIGN UNIT  : Priority Encoder                                       --
-- DESCRIPTION  :  --
--              :                     --
-- AUTHOR       : Everton Alceu Carara                                     --
-- CREATED      : February, 2014                                          --
-- VERSION      : 1.0                                                      --
-- HISTORY      : Version 1.0 - February, 2014 - Everton Alceu Carara     --
--------------------------------------------------------------------------------------------

library IEEE;						
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity PriorityEncoder is
	port (
		requests	: in std_logic_vector(7 downto 0);		
		reqID	    : out std_logic_vector(2 downto 0);
		idle	    : out std_logic
	);
end PriorityEncoder;


architecture behavioural of PriorityEncoder is
begin
	
	reqID <=    "000" when requests(0) = '1' else
                "001" when requests(1) = '1' else
                "010" when requests(2) = '1' else
                "011" when requests(3) = '1' else
                "100" when requests(4) = '1' else
                "101" when requests(5) = '1' else
                "110" when requests(6) = '1' else
                "111";	-- Default output
			
	-- idle is active when there is no requests
	idle <= '1' when requests = 0 else '0';
	
end behavioural;

