library IEEE;
use IEEE.std_logic_1164.all;        

entity r8_crypto_tb is
end r8_crypto_tb;

architecture testbench of r8_crypto_tb is
	signal clk_r8 : std_logic := '0';  
	signal clk_crypto : std_logic := '0';  
	signal rst: std_logic;
begin
	clk_r8 <= not clk_r8 after 10 ns;			--this frequency is halfed by clock_manager
	clk_crypto <= not clk_crypto after 40 ns;	--this frequency must be half the frequency of r8
	rst <='1', '0' after 5 ns; 
	
	r8_crypto : entity work.R8_crypto
	port map(
		clk_r8 => clk_r8,
		clk_crypto => clk_crypto,
		rst => rst
	);

end testbench;