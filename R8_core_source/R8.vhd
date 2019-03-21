-------------------------------------------------------------------------
--
--  R8 PROCESSOR   -  GOLD VERSION  -  05/JAN/2017
--
--  moraes - 30/09/2001  - project start
--  moraes - 22/11/2001  - instruction decoding bug correction
--  moraes - 22/03/2002  - store instruction correction            
--  moraes - 05/04/2003  - SIDLE state inclusion in the control unit
--  calazans - 02/05/2003  - translation of comments to English. Names of
--    some signals, entities, etc have been changed accordingly
--  carara - 03/2013 - project split in several files. Each entity is described in a file with the same name.
--  carara - 5/01/2017 - library std_logic_unsigned replaced by numeric_std
--
--  Notes: 1) In this version, the register bank is designed using 
--    for-generate VHDL construction
--         2) The top-level R8 entity is
--
--      entity R8 is
--            port( clk,rst: in std_logic;
--                  data_in:  in  std_logic_vector(15 downto 0);    -- Data from memory
--                  data_out: out std_logic_vector(15 downto 0);    -- Data to memory
--                  address: out std_logic_vector(15 downto 0);     -- Address to memory
--                  ce,rw: out std_logic );                         -- Memory control
--      end R8;
-- 
-------------------------------------------------------------------------



-------------------------------------------------------------------------
-- Design unit: R8
-- Description: Top-level instantiation of the R8 data and control paths
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.R8_pkg.all;

entity R8 is
    port( 
        clk     : in std_logic;
        rst     : in std_logic;
        
        -- Memory interface
        data_in : in std_logic_vector(15 downto 0);
        data_out: out std_logic_vector(15 downto 0);
        address : out std_logic_vector(15 downto 0);
        ce      : out std_logic;
        rw      : out std_logic 
    );
end R8;

architecture structural of R8 is   

    signal flag: std_logic_vector(3 downto 0);
    signal uins: Microinstruction;
    signal instruction: std_logic_vector(15 downto 0);

begin   
  
    DATA_PATH: entity work.DataPath 
        port map(
            uins        => uins, 
            clk         => clk,
            rst         => rst,
            instruction => instruction,
            address     => address,
            data_in     => data_in, 
            data_out    => data_out, 
            flag        => flag
        );

    CONTROL_PATH: entity work.ControlPath 
        port map(
            uins        => uins, 
            clk         => clk, 
            rst         => rst, 
            flag        => flag, 
            ir          => instruction
        );

    -- Memory signals
    ce <= uins.ce;
    rw <= uins.rw;

end structural;