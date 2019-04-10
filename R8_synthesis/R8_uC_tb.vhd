-------------------------------------------------------------------------
-- Design unit: R8 simutation test bench
-- Description: R8 processor connected to a BRAM memory
--      The BRAM memory is able to load image files generated by the R8 simulator             
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;        

entity R8_uC_tb is
end R8_uC_tb;

architecture testbench of R8_uC_tb is
    
      signal clk : std_logic := '0';  
      signal rst: std_logic;
      signal port_io : std_logic_vector(15 downto 0);
      
    
begin
    
    R8_uC: entity work.R8_uC(structural) 
        port map (
            board_clock     => clk,
            board_rst       => rst,
            port_io         => port_io
        );
        
    -- Generates the clock signal            
    clk <= not clk after 10 ns;
    
    -- Generates the reset signal
    rst <='1', '0' after 5 ns;        
    
end testbench;
