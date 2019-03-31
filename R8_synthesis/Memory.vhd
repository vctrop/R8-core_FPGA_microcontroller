-------------------------------------------------------------------------
-- Design unit: Memory
-- Description: Parametrizable memory
--      Synchronous read and write
--      Coded to Xilinx block RAM inference
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.Util_package.all;


entity Memory is
    generic (
        DATA_WIDTH  : integer := 8;         -- Data bus width
        ADDR_WIDTH  : integer := 8;         -- Address bus width
        IMAGE       : string := "UNUSED"    -- Memory content to be loaded    (text file)
    );
    port (  
        clk         : in std_logic;
        wr          : in std_logic;            -- Write Enable (1: write; 0: read)
        en          : in std_logic;            -- Memory enable
        address     : in std_logic_vector (ADDR_WIDTH-1 downto 0);
        data_in     : in std_logic_vector (DATA_WIDTH-1 downto 0);
        data_out    : out std_logic_vector (DATA_WIDTH-1 downto 0)
    );
end Memory;

architecture BlockRAM of Memory is
    
    type RamType is array (0 to (2**ADDR_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    
    impure function InitRamFromFile (RamFileName : in string) return RamType is
        --FILE RamFile : text is in RamFileName;
        FILE RamFile : text open READ_MODE is RamFileName;
        variable RamFileLine : line;
        variable RAM : RamType;
        variable data_str : string(1 to 4);
    begin   
        for I in RamType'range loop
            readline (RamFile, RamFileLine);
            read (RamFileLine, data_str);
            RAM(I) := StringToStdLogicVector(data_str);
        end loop;
        return RAM;
    end function;
    
    signal RAM : RamType := InitRamFromFile(IMAGE);
            
    begin
    -- Process to control the memory access
    process(clk)
    begin
        if rising_edge(clk) then    -- Memory writing        
            if en = '1' then
                if wr = '1' then
                    RAM(TO_INTEGER(UNSIGNED(address))) <= data_in; 
                    data_out <= data_in; -- "Write first" mode or "transparent" mode
                else
                    -- Synchronous memory read (Block RAM)
                    data_out <= RAM(TO_INTEGER(UNSIGNED(address)));
                end if;
            end if;
        end if;   
    end process;
    
end BlockRAM;