-------------------------------------------------------------------------
-- Design unit: R8 simutation test bench
-- Description: R8 processor connected to a RAM memory
--      The RAM memory is able to load image files generated by the R8 simulator             
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;        
use ieee.std_logic_unsigned.ALL;


entity R8_uC is
    port(
        board_clock     : in std_logic;
        board_rst       : in std_logic;
        port_io         : inout std_logic_vector(15 downto 0);
        tx              : out std_logic
    );
end R8_uC;

architecture structural of R8_uC is
    
      signal clk, clk_mem, clk_div4 : std_logic;
      signal rw, ce, rst, ce_mem, ce_io, ce_portA, ce_PIC, rw_n, intr, ce_TX, TX_av, TX_ready : std_logic;
      signal R8_out, R8_in, addressR8, mem_out, data_portA, irq : std_logic_vector(15 downto 0);
      signal data_PIC, PIC_irq, data_TX : std_logic_vector(7 downto 0);
      alias address_peripherals is addressR8(7 downto 4);

begin
    
    PROCESSOR: entity work.R8(behavioral) 
        port map (
            clk         => clk, 
            rst         => rst, 
            data_in     => R8_in, 
            data_out    => R8_out, 
            address     => addressR8, 
            ce          => ce, 
            rw          => rw,
            intr 	=> intr                                      -- 
        );
    
    
    RAM : entity work.Memory   
        generic map (
            DATA_WIDTH  => 16,       
            ADDR_WIDTH  => 15,         
            IMAGE       => "memory_images/int_to_str_BRAM.txt"    
            )
        port map(  
            clk         => clk_mem,
            wr          => rw_n,              -- Write Enable (1: write; 0: read)
            en          => ce_mem,            -- Memory enable
            address     => addressR8(14 downto 0),
            data_in     => R8_out,
            data_out    => mem_out
        );
        
    PORT_A : entity work.BidirectionalPort
        generic map (
            DATA_WIDTH          => 16,
            PORT_DATA_ADDR      => "10",
            PORT_CONFIG_ADDR    => "01",
            PORT_ENABLE_ADDR    => "00",
            PORT_IRQ_ENABLE_ADDR => "11" 
        )
        port map(
            clk         => clk,
            rst         => rst, 
            
            -- Processor interface
            data        => data_portA,
            address     => addressR8(1 downto 0),
            wr          => rw_n,                -- 1: write, 0: read
            ce          => ce_portA,
            irq		    => irq,
            -- External interface
            port_io     => port_io
            
        );
        
    PIC : entity work.InterruptController
    generic map(
        IRQ_ID_ADDR     => "00", -- Interruption request number (vector)
        INT_ACK_ADDR    => "01", -- Interrupt acknowledgement address
        MASK_ADDR       => "10"  -- Mask register address
    )
    port map(  
        clk         => clk,
        rst         => rst, 
        data        => data_PIC,
        address     => addressR8(1 downto 0),
        wr          => rw_n, -- wr = 0: Read; wr = 1: Write
        ce          => ce_PIC,
        intr        => intr, -- To processor
        irq         => PIC_irq -- Interrupt request DATA PORT_A(15 DOWNTO 12) MUST BE ALWAYS INPUT
    );
    
    UART_TX : entity work.UART_TX
    generic map(
        RATE_FREQ_BAUD  =>  25000000/115200 --2605  -- ceil(25 Mhz/9600 bps)
    )
    port map(
        clk         => clk,
        rst         => rst,
        data_in     => data_TX,
        data_av     => TX_av,
        tx          => tx,
        ready       => TX_ready
    );
    
    
    CLOCK_MANAGER : entity work.ClockManager 
        port map(
          clk_in      => board_clock,
          clk_div2    => clk,
          clk_div4    => clk_div4
         );
         
    RESET_SYNCHRONIZER: entity work.ResetSynchonizer 
        port map(
            clk      => clk,
            rst_in   => board_rst,
            rst_out  => rst
        );

    --interrupt interface
    PIC_irq <= irq(15 downto 12) & x"0";
    
    -- Memory access control signals       
    rw_n   <= not rw;    
    
    data_portA <= R8_out when rw = '0' and ce_portA = '1' else      -- portA data i/o tristate
                (others => 'Z'); 
            
    data_PIC <= R8_out(7 downto 0) when rw = '0' and ce_PIC = '1' else           -- PIC data i/o tristate
                (others => 'Z');
            
    data_TX <= R8_out(7 downto 0);
          
    R8_in <=    data_portA                      when rw = '1' and ce_portA  = '1' else 
                x"00" & data_PIC                when rw = '1' and ce_PIC    = '1' else 
                (0 => TX_ready, others => '0')  when rw = '1' and ce_TX     = '1' else 
                mem_out;

    --memory clock is inverted to work at falling edge borders of the R8 clock
    clk_mem <= not clk;    

    
    -- write enable decoder:
    ce_mem      <= '1' when ce = '1' and addressR8(15) = '0' else '0';
    ce_io       <= '1' when ce = '1' and addressR8(15) = '1' else '0';
    ce_portA    <= '1' when ce_io = '1' and address_peripherals = x"0" else '0';
    ce_PIC      <= '1' when ce_io = '1' and address_peripherals = x"1" else '0';
    ce_TX       <= '1' when ce_io = '1' and address_peripherals = x"2" else '0';
    
	--Tx interface 
	TX_av <= '1' when ce_TX = '1' and rw = '0' else '0';

end structural;
