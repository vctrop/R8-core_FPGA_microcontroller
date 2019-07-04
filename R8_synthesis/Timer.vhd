------------------------------------------------------------------------------
-- DESIGN UNIT  : Timer                                                     --
-- DESCRIPTION  :                                                           --
--              :                                                           --
-- AUTHOR       : Everton Alceu Carara                                      --
-- CREATED      : February, 2014                                            --
-- VERSION      : 1.0                                                       --
-- HISTORY      : Version 1.0 - January, 2014 - Everton Alceu Carara        --
--                Version 1.1 - May, 2016 - Everton Alceu Carara            --
--                  - Read/write interface changed                          --
--                  - Added read current countering                         --
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Timer  is   
    generic (
        DATA_WIDTH          : integer
    );
    port (  
        clk         : in std_logic;
        rst         : in std_logic; 
        data        : inout std_logic_vector (DATA_WIDTH-1 downto 0);
        wr          : in std_logic; -- Read = 0; Write = 1
        ce          : in std_logic;
        time_out    : out std_logic
    );
end Timer ;


architecture Behavioral of Timer  is

    signal counter      : UNSIGNED (DATA_WIDTH-1 downto 0);
    signal initialized  : boolean;

begin

    time_out <= '1' when (counter = 0 and initialized) else '0';
    
    process(clk, rst)
    begin
        if rst = '1' then
            initialized <= false;
            counter <= (others=>'0');
        
        elsif rising_edge(clk) then
            if ce = '1' and wr = '1' then                
                counter <= UNSIGNED(data);
                initialized <= true;
                
            elsif counter /= 0 then 
                counter <= counter - 1;              
            end if;
            
        end if;
    end process;
    
    data <= STD_LOGIC_VECTOR(counter) when ce = '1' and wr = '0' else (others=>'Z');
        
        
end Behavioral;