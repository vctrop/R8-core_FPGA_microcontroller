-------------------------------------------------------------------------
-- Design unit: Register file
-- Description: 16 general purpose registers
--              - 2 read ports
--              - 1 write port
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.R8_pkg.all;

entity RegisterFile is
    port(  
        clk     : in std_logic;
        rst     : in std_logic;
        wReg    : in std_logic;     -- Register file write enable
        mS2     : in std_logic;     -- Selects the 'ir' field used to index a register to the 'source2' output
        ir      : in   std_logic_vector(15 downto 0);   -- Current instruction
        inREG   : in   std_logic_vector(15 downto 0);   -- Register file write port
        source1 : out  std_logic_vector(15 downto 0);   -- Read port 1
        source2 : out  std_logic_vector(15 downto 0)    -- Read port 2
    );
end entity;

architecture structural of RegisterFile is

    type bank is array (0 to 15) of std_logic_vector(15 downto 0);
    signal reg          : bank;     -- Array with the stored registers value
    signal writeEnable  : std_logic_vector(15 downto 0);    -- Registers write enable signal
    signal destB        : std_logic_vector(3 downto 0);

begin            
    
    -- Generate the 16 registers
    REGS: for i in 0 to 15 generate   
        
        -- Generates each register write enable signal
        writeEnable(i) <= '1' when  TO_INTEGER(UNSIGNED(ir(11 downto 8))) = i  and wReg = '1' else '0';
        
        -- General purpose registers
        RX: entity work.RegisterNbits
            generic map (
                WIDTH   => 16
            )
            port map (
                clk     => clk, 
                rst     => rst, 
                ce      => writeEnable(i), 
                d       => inREG, 
                q       => reg(i)
            );               
    end generate REGS;       
  
    -- Selects the read register 1 (Rsource 1)	
	source1 <= reg(TO_INTEGER(UNSIGNED(ir(7 downto 4))));

    -- Selects the read register 2 (Rtarget or Rsource2)    
    source2 <= reg(TO_INTEGER(UNSIGNED(ir(3 downto 0)))) when mS2 = '0' else reg(TO_INTEGER(UNSIGNED(ir(11 downto 8))));
   
end structural;
