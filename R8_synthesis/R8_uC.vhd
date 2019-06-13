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
        -- Bidirectional data port
        port_io         : inout std_logic_vector(15 downto 0);
        -- Serial communication
        rx              : in std_logic;
        tx              : out std_logic;
		--selects between programing mode and user mode
		mode			: in std_logic	 -- user mode: 0 , programing mode: 1
    );
end R8_uC;

architecture structural of R8_uC is
    
	signal clk, clk_mem : std_logic;
	signal rw, ce, rst, rst_sync, rst_mode, ce_mem, ce_io, ce_portA, ce_PIC, rw_n, intr, ce_TX, TX_av, TX_ready, RX_av, RX_baud_av, ce_RX, ce_ROM: std_logic;
	signal R8_out, R8_in, addressR8, ram_mem_out, rom_mem_out, data_portA, irq, RX_baud_in, data_TX : std_logic_vector(15 downto 0);
	signal data_PIC, PIC_irq, data_RX : std_logic_vector(7 downto 0);
	alias address_peripherals is addressR8(7 downto 4);
	alias address_registers   is addressR8(1 downto 0);
	  
	--signals for MODE_CHANGE_RESET process
	type RESET_PULSE_STATES is (Sidle, Srst);
	signal state: RESET_PULSE_STATES;
	signal mode_rst, last_signal, current_signal : std_logic;
	

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
    
    --32 KB random access memory , contains user program
    RAM : entity work.Memory   
        generic map (
            DATA_WIDTH  => 16,       
            ADDR_WIDTH  => 15,         
            IMAGE       => "memory_images/RX_TX_test_BRAM.txt"    
            )
        port map(  
            clk         => clk_mem,
            wr          => rw_n,              -- Write Enable (1: write; 0: read)
            en          => ce_mem,            -- Memory enable
            address     => addressR8(14 downto 0),
            data_in     => R8_out,
            data_out    => ram_mem_out
        );
	
	-- 1 KB memory , contains programing mode loader through USART
	ROM : entity work.Memory_ROM   
        generic map (
            DATA_WIDTH  => 16,       
            ADDR_WIDTH  => 15,         
            IMAGE       => "memory_images/ROM_BRAM.txt"    
            )
        port map(  
            clk         => clk_mem,
            wr          => rw_n,              -- Write Enable (1: write; 0: read)
            en          => ce_ROM,            -- Memory enable
            address     => addressR8(14 downto 0),
            data_in     => (others => '0'),
            data_out    => rom_mem_out
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
            address     => address_registers,
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
        MASK_ADDR       => "10",  -- Mask register address
    	IRQ_REG_ADDR    => "11"
	)
    port map(  
        clk         => clk,
        rst         => rst, 
        data        => data_PIC,
        address     => address_registers,
        wr          => rw_n, -- wr = 0: Read; wr = 1: Write
        ce          => ce_PIC,
        intr        => intr, -- To processor
        irq         => PIC_irq -- Interrupt request DATA PORT_A(15 DOWNTO 12) MUST BE ALWAYS INPUT
    );
    
    UART_TX : entity work.UART_TX
    generic map(
        FREQ_BAUD_ADDR  => "01",
        TX_DATA_ADDR    => "00"
    )
    port map(
        clk         => clk,
        rst         => rst,
        data_av     => TX_av,
        address     => address_registers,
        data_in     => data_TX,
        tx          => tx,
        ready       => TX_ready
    );
    
    UART_RX : entity work.UART_RX
    port map(
        clk         => clk,
        rst         => rst,
        baud_av     => RX_baud_av,
        baud_in     => RX_baud_in,
        rx          => rx,
        data_out    => data_RX,
        data_av     => RX_av
    );
    
    CLOCK_MANAGER : entity work.ClockManager 
        port map(
          clk_in      => board_clock,
          clk_div2    => OPEN,
          clk_div4    => clk
         );
         
    RESET_SYNCHRONIZER: entity work.ResetSynchonizer 
        port map(
            clk      => clk,
            rst_in   => rst_sync,
            rst_out  => rst
        );

	
	--sets a 1 clock cycle reset pulse whenever MODE signal changes
	MODE_CHANGE_RESET:	process(clk, board_rst, mode)
	begin
		if board_rst = '1' then
			last_signal <= mode;
			current_signal <= mode;
			mode_rst <= '0';
			
		elsif rising_edge(clk) then
			case state is
				when Sidle =>
					last_signal <= current_signal;
					current_signal <= mode;
					mode_rst <= '0';
					if current_signal /= last_signal then 
						state <= Srst;
					else
						state <= Sidle;
					end if;
				when Srst =>
					mode_rst <= '1';
					state <= Sidle;
			end case;
		end if;
	end process;
		
	rst_sync <= mode_rst or board_rst;
	
    --interrupt interface
    --port_io(3) <= increment_button
    --port_io(2) <= decrement button
    --PIC_irq(7 downto 4) <= irq(15 downto 12);     --no longer used
    PIC_irq(7 downto 6) <= irq(3 downto 2);
    PIC_irq(5 downto 0) <= (1 => RX_av, others => '0');
    
    -- Memory access control signals       
    rw_n   <= not rw;    
    
    data_portA <= R8_out when rw = '0' and ce_portA = '1' else      -- portA data i/o tristate
                (others => 'Z'); 
            
    data_PIC <= R8_out(7 downto 0) when rw = '0' and ce_PIC = '1' else           -- PIC data i/o tristate
                (others => 'Z');
            
    data_TX     <= R8_out;
    RX_baud_in  <= R8_out; 
      
    R8_in <=    data_portA                      when rw = '1' and ce_portA  = '1' else 
                x"00" & data_PIC                when rw = '1' and ce_PIC    = '1' else 
                (0 => TX_ready, others => '0')  when rw = '1' and ce_TX     = '1' else 
                x"00" & data_RX                 when rw = '1' and ce_RX     = '1' else
				rom_mem_out						when              ce_ROM    = '1' else
                ram_mem_out;

    --memory clock is inverted to work at falling edge borders of the R8 clock
    clk_mem <= not clk;    
    
    -- write enable decoder:
    ce_mem      <= '1' when ce = '1' and addressR8(15) = '0'            else '0';
    ce_ROM      <= '1' when ce_mem = '1' and mode = '1' and rw = '1'    else '0';
    ce_io       <= '1' when ce = '1' and addressR8(15) = '1'            else '0';
    ce_portA    <= '1' when ce_io = '1' and address_peripherals = x"0"  else '0';
    ce_PIC      <= '1' when ce_io = '1' and address_peripherals = x"1"  else '0';
    ce_TX       <= '1' when ce_io = '1' and address_peripherals = x"2"  else '0';
    ce_RX       <= '1' when ce_io = '1' and address_peripherals = x"3"  else '0';
     
	TX_av       <= '1' when ce_TX = '1' and rw = '0' else '0';
    RX_baud_av  <= '1' when ce_RX = '1' and rw = '0' else '0';
end structural;
