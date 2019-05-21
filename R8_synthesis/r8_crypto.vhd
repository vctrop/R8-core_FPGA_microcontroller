library IEEE;
use IEEE.std_logic_1164.all;        

entity R8_crypto is
	port(
		clk_r8 : in std_logic;
		clk_crypto : in std_logic;
		rst : in std_logic
	);
end R8_crypto;

architecture structural of r8_crypto is
	signal port_io	: std_logic_vector(15 downto 0);
	signal data_mux, data_in, data_out0, data_out1, data_out2, data_out3 : std_logic_vector(7 downto 0);
	signal ack0, ack1, ack2, ack3 : std_logic;
	signal eom0, eom1, eom2, eom3 : std_logic;
	signal data_av0, data_av1, data_av2, data_av3 : std_logic;
	
	
	alias key_exg3 		is port_io(15);		--input		
	alias key_exg2 		is port_io(14);		--input
	alias key_exg1		is port_io(13);		--input
	alias key_exg0		is port_io(12);		--input
	alias id			is port_io(11 downto 10);		--output
	alias ack 			is port_io(9);					--output
	alias op			is port_io(9 downto 8);			--output
	alias crypto_io		is port_io(7 downto 0);			--input/output
	--portA config is 0xF0XX
	--portA intrConfig is 0xF000
	--PIC_mask config is 0xF000 
	
begin
	R8_uC: entity work.R8_uC(structural) 
        port map (
            board_clock     => clk_r8,
            board_rst       => rst,
            port_io         => port_io
        );
		
	Crypto0:	entity work.CryptoMessage
    generic map(
        MSG_INTERVAL    => 2500,					--mudar talvez!
        FILE_NAME       => "message/empire.txt"
    )
    port map( 
        clk         => clk_crypto,
        rst         => rst,
        ack         => ack0,
        data_in     => crypto_io,
        data_out    => data_out0,
        data_av     => data_av0,
        keyExchange => key_exg0,
        eom         => eom0
    );
	
	Crypto1:	entity work.CryptoMessage
    generic map(
        MSG_INTERVAL    => 2500,					--mudar talvez!
        FILE_NAME       => "message/DoctorRockter.txt"
    )
    port map( 
        clk         => clk_crypto,
        rst         => rst,
        ack         => ack1,
        data_in     => crypto_io,
        data_out    => data_out1,
        data_av     => data_av1,
        keyExchange => key_exg1,
        eom         => eom1
    );
	
	Crypto2:	entity work.CryptoMessage
    generic map(
        MSG_INTERVAL    => 2500,					--mudar talvez!
        FILE_NAME       => "message/RevolutionCalling.txt"
    )
    port map( 
        clk         => clk_crypto,
        rst         => rst,
        ack         => ack2,
        data_in     => crypto_io,
        data_out    => data_out2,
        data_av     => data_av2,
        keyExchange => key_exg2,
        eom         => eom2
    );
	
	Crypto3:	entity work.CryptoMessage
    generic map(
        MSG_INTERVAL    => 2500,					--mudar talvez!
        FILE_NAME       => "message/AllAlongTheWatchTower.txt"
    )
    port map( 
        clk         => clk_crypto,
        rst         => rst,
        ack         => ack3,
        data_in     => crypto_io,
        data_out    => data_out3,
        data_av     => data_av3,
        keyExchange => key_exg3,
        eom         => eom3
    );
	
	--op = "00" indica leitura de sinais de data_av e eom 
	--op = "01" indica leitura de DADOS do crypto sem mandar sinal de ack 
	--op = "10" indica leitura de DADOS do crypto COM sinal de ack 
	--op = "11" indica ESCRITA de dados no crypto COM sinal de ack
	
	data_mux <= data_out0 when id = "00" and (op = "01" or op = "10") else
				data_out1 when id = "01" and (op = "01" or op = "10") else
				data_out2 when id = "10" and (op = "01" or op = "10") else
				data_out3 when id = "11" and (op = "01" or op = "10") else
				(0 => data_av0, 1 => eom0, others => '0') when id = "00" and op = "00" else  
				(0 => data_av1, 1 => eom1, others => '0') when id = "01" and op = "00" else  
				(0 => data_av2, 1 => eom2, others => '0') when id = "10" and op = "00" else  
				(0 => data_av3, 1 => eom3, others => '0');
				
	crypto_io <= data_mux when op /= "11" else (others => 'Z');
	
	--
	ack0 <= ack when id = "00" else '0';
	ack1 <= ack when id = "01" else '0';
	ack2 <= ack when id = "10" else '0';
	ack3 <= ack when id = "11" else '0';
	
end structural;
