-------------------------------------------------------------------------
-- Design unit: R8 simutation test bench
-- Description: R8 processor connected to a RAM memory
--      The RAM memory is able to load image files generated by the R8 simulator             
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;        
use work.R8_pkg.all;

entity R8_tb is
end R8_tb;

architecture behavioral of R8_tb is
    
      signal clk : std_logic := '0';  
      signal rw, ce, rst, ce_n, we_n, oe_n : std_logic;
      signal dataR8, dataBus, addressR8, address : std_logic_vector(15 downto 0);    
    
begin
    
    PROCESSOR: entity work.R8 
        port map (
            clk         => clk, 
            rst         => rst, 
            data_in     => dataBus, 
            data_out    => dataR8, 
            address     => addressR8, 
            ce          => ce, 
            rw          => rw
        );
    
    
    RAM : entity work.Memory   
        generic map (
           SIZE         => 1024,    -- 1024 words (2KB)
           -- imageFileName => "Todas_Instrucoes_R8.txt"
           imageFileName => "selection_sort.txt"
        )
        port map (
            clk     => clk,
            ce_n    => ce_n, 
            we_n    => we_n, 
            oe_n    => oe_n, 
            data    => dataBus, 
            address => addressR8
        );
    
    -- Generates the clock signal            
    clk <= not clk after 10 ns;
    
    -- Generates the reset signal
    rst <='1', '0' after 5 ns;        

    -- Memory access control signals       
    ce_n <= '0' when (ce='1') else '1';
    oe_n <= '0' when (ce='1' and rw='1') else '1';       
    we_n <= '0' when (ce='1' and rw='0') else '1';    
        
    dataBus <= dataR8 when ce = '1' and rw='0' else     -- Writing access
            (others => 'Z');    
  
    
end behavioral;