-------------------------------------------------------------------------
-- Design unit: R8 simutation test bench
-- Description: R8 processor connected to a BRAM memory
--      The BRAM memory is able to load image files generated by the R8 simulator             
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;        

entity R8_BRAM is
end R8_BRAM;

architecture behavioral_tb of R8_tb is
    
      signal clk : std_logic := '0';  
      signal rw, ce, rst, ce_n, we_n, oe_n : std_logic;
      signal dataR8, dataBus, addressR8, address : std_logic_vector(15 downto 0);    
    
begin
    
    PROCESSOR: entity work.R8(behavioral) 
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
            DATA_WIDTH  => 16,         
            ADDR_WIDTH  => 15,       
            IMAGE       => "memory_images/Todas_Instrucoes_R8.txt"    
            )
        port map(  
            clk         => clk;
            wr          : in std_logic;            -- Write Enable (1: write; 0: read)
            en          : in std_logic;            -- Memory enable
            address     => addressR8(14 downto 0);
            data_in     => dataR8;
            data_out    => dataBus
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
  
    
end behavioral_tb;