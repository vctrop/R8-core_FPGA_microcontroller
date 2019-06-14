-------------------------------------------------------------------------
-- Design unit: R8 simutation test bench
-- Description: R8 processor connected to a BRAM memory
--      The BRAM memory is able to load image files generated by the R8 simulator             
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;       

entity R8_uC_tb is
end R8_uC_tb;

architecture testbench of R8_uC_tb is
  

	signal clk : std_logic := '0';  
	signal rst: std_logic;
	signal port_io, ram_out, data_TX : std_logic_vector(15 downto 0);
	signal data_RX : std_logic_vector(7 downto 0);
	signal rx, tx, mode, tx_tb, clk_div4, clk_div4_n, rst_tx, ce_mem: std_logic;
	signal ram_index : std_logic_vector(14 downto 0);
	signal TX_av, TX_ready, sendLo : std_logic;
    signal transfer : std_logic := '0';
    type BIN_TRANSFER_STATES is (Srst, Sidle, SsendHi, SsendLo);
    signal state : BIN_TRANSFER_STATES := Srst;
    
begin
    
    R8_uC: entity work.R8_uC(structural) 
        port map (
            board_clock     => clk,
            board_rst       => rst,
            port_io         => port_io,
            rx              => tx_tb,
            tx              => tx,
			mode 			=> mode
        );
    
    -- Send TB_RAM memory image to R8_uC via serial communication
	TB_TX : entity work.UART_TX
    generic map(
        FREQ_BAUD_ADDR  => "01",
        TX_DATA_ADDR    => "00"
    )
    port map(
        clk         => clk_div4,
        rst         => rst,
        data_av     => TX_av,
        address     => "00",
        data_in     => data_TX,
        tx          => tx_tb,
        ready       => TX_ready
    );
    
    TB_RAM : entity work.Memory   
        generic map (
            DATA_WIDTH  => 16,       
            ADDR_WIDTH  => 15,         
            IMAGE       => "memory_images/echo_BRAM.txt"    
            )
        port map(  
            clk         => clk_div4_n,
            wr          => '0',                     -- Write Enable (1: write; 0: read)
            en          => ce_mem,                  -- Memory enable
            address     => ram_index,
            data_in     => (others => '0'),
            data_out    => ram_out
        );
    
    TB_CLK_MANAGER : entity work.ClockManager 
        port map(
          clk_in      => clk,
          clk_div2    => OPEN,
          clk_div4    => clk_div4
         );
         
    BIN_TRANSFER_SIMULATOR: process (clk_div4, rst, mode, transfer)
    begin
        if rst = '1' or mode = '0' then
            state <= Srst;
            
        elsif rising_edge(clk_div4) and transfer = '1' then
            case state is
                when Srst => 
                    ram_index <= (others => '0');
                    TX_av <= '0';
                    sendLo <= '0';
					if mode = '1' then 
						state <= Sidle;
                    else 
						state <= Srst;
					end if;
					
                when Sidle =>
                    TX_av <= '0';
					
					if unsigned(ram_index) >= 6 then			-- mudar isso pra dizer o numero de linhas a se transferir
						state <= Sidle;
					elsif TX_ready = '1' and sendLo = '0' then
                        state <= SsendHi;
                    elsif TX_ready = '1' and sendLo = '1' then
                        state <= SsendLo;
                    else
                        state <= Sidle;
                    end if;
                
                when SsendHi =>
                    TX_av <= '1';
                    
                   
                    if TX_ready = '0' then
                        state <= Sidle;
						sendLo <= '1';
					else
						state <= SsendHi;
                    end if;

                when SsendLo =>
                    TX_av <= '1';
               
                    if TX_ready = '0' then
						sendLo <= '0';
                        state <= Sidle;
						ram_index <= std_logic_vector(unsigned(ram_index) + 1);
					else
						state <= SsendLo;
                    end if;   
            end case;
        end if;
    end process;
        
	data_tx(15 downto 8) <= (others=>'0');
    data_TX(7 downto 0) <= ram_out(7 downto 0) when sendLo = '1' else ram_out(15 downto 8) ;
    ce_mem <= '1' when state = SsendHi or state = SsendLo else '0';
     
    clk_div4_n <= not clk_div4;
    
	transfer <= '0', '1' after 40 us;
     
	DISP: entity work.Display_simulator
	port map(
        segment  => port_io(15 downto 8),
		digit    => OPEN
	);
    
    mode <= '0', '1' after 5 us, '0' after 400 us;
    -- Generates the clock signal            
    clk <= not clk after 10 ns;
    port_io(3) <= '0', '1' after 40 us, '0' after 80 us;
	port_io(2) <= '0', '1' after 40 us, '0' after 80 us;
    -- Generates the reset signal
    rst <='1', '0' after 5 ns;    
    
end testbench;
