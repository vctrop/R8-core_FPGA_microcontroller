library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

entity BidirectionalPort  is
    generic (
        DATA_WIDTH          : integer;                          -- Port width in bits
        PORT_DATA_ADDR      : std_logic_vector(1 downto 0);     -- NÃO ALTERAR!
        PORT_CONFIG_ADDR    : std_logic_vector(1 downto 0);     -- NÃO ALTERAR! 
        PORT_ENABLE_ADDR    : std_logic_vector(1 downto 0)      -- NÃO ALTERAR!
    );
    port (  
        clk         : in std_logic;
        rst         : in std_logic; 
        
        -- Processor interface
        data        : inout std_logic_vector (DATA_WIDTH-1 downto 0);
        address     : in std_logic_vector (1 downto 0);         -- NÃO ALTERAR!
        wr          : in std_logic;                             -- 1: write, 0: read
        ce          : in std_logic;
        
        -- External interface
        port_io     : inout std_logic_vector (DATA_WIDTH-1 downto 0)
    );
end BidirectionalPort ;


architecture Behavioral of BidirectionalPort  is
    signal PortEnable, PortConfig, PortData : std_logic_vector(15 downto 0);
    signal regSync1, regSync2               : std_logic_vector(15 downto 0);
    signal mux_read, mux_data  : std_logic_vector(15 downto 0);

begin
    process(clk, rst)
    begin
        if rst = '1' then
            PortEnable <= (others=>'0');
            PortConfig <= (others=>'1');
            PortData <= (others=>'0');
            RegSync1 <= (others=>'0');
            RegSync2 <= (others=>'0');
        elsif rising_edge(clk) then
            if address = PORT_ENABLE_ADDR and ce = '1' and wr = '1' then
                PortEnable <= data;
            elsif address = PORT_CONFIG_ADDR and ce = '1' and wr = '1' then
                PortConfig <= data;
            end if;
            --We set each bit in PortData individually
            for I in PortData'range loop
                if PortEnable(I) = '1' and (PortConfig(I) = '1' or (wr = '1' and address = PORT_DATA_ADDR and ce='1')) then
                    PortData(I) <= mux_data(I);
                end if;
            end loop;
            regSync2 <= regSync1;
            regSync1 <= port_io;    --synchronization registers are always enabled
        end if;
    end process;
    
    --port_io <= port_io_sig;
    
    
    GEN_MUX_TRISTATE: 
    for I in mux_data'range generate
        mux_data(I) <= data(I) when PortConfig(I) = '0' and PortEnable(I) = '1' else
                    regSync2(I);
        port_io(I)  <= PortData(I) when PortConfig(I) = '0' and PortEnable(I) = '1' else
                        'Z';
    end generate GEN_MUX_TRISTATE;

    --data inout tristate
    data <= mux_read when ce = '1' and wr = '0' else
            (others=>'Z');
            
    mux_read <= PortEnable when address = PORT_ENABLE_ADDR else 
                PortConfig when address = PORT_CONFIG_ADDR else
                PortData;
                
end Behavioral;