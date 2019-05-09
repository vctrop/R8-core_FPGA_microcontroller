library IEEE;
use IEEE.std_logic_1164.all;        

entity R8_crypto is
end R8_crypto;

architecture testbench of r8_crypto is
	signal clk : std_logic := '0';  
	signal rst: std_logic;
	signal port_io	: std_logic_vector(15 downto 0);
	signal data_in, data_out : std_logic_vector(7 downto 0);
	alias tristate_ctrl is port_io(15);		--output		
	alias ack 			is port_io(14);		--output
	alias key_exg 		is port_io(13);		--input
	alias data_av 		is port_io(12);		--input
	alias eof			is port_io(11);		--input
	--portconfig x"38" for the most significant byte
	 
begin
	clk <= not clk after 10 ns;
	rst <='1', '0' after 5 ns; 
	
	R8_uC: entity work.R8_uC(structural) 
        port map (
            board_clock     => clk,
            board_rst       => rst,
            port_io         => port_io
        );
		
	Crypto:	entity work.CryptoMessage
    generic map(
        MSG_INTERVAL    => 5000,					--mudar talvez!
        FILE_NAME       => "message/empire.txt"
    )
    port map( 
        clk         => clk,
        rst         => rst,
        ack         => ack,
        data_in     => data_in,
        data_out    => data_out,
        data_av     => data_av,
        keyExchange => key_exg,
        eom         => eof
    );
	
	port_io(7 downto 0) <= data_out when tristate_ctrl = '1' else (others => 'Z');  
	data_in <= port_io(7 downto 0);
end testbench;
