-- CUSTOM UART COMM PROTOCOL RX TEST BENCH 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_UART_RX is
			generic (
						c_clock_freq   : integer := 100_000_000;
						c_baud_rate    : integer := 10_000_000
			);
end tb_UART_RX;

architecture Behavioral of tb_UART_RX is


COMPONENT UART_RX is
			generic (
						c_clock_freq   : integer := 100_000_000;
						c_baud_rate    : integer := 10_000_000
			);
			port(
						clk 		     : in  std_logic;
						rx_input_data_i  : in  std_logic;
						rx_done_tick_o   : out std_logic;
						rx_data_output_o : out std_logic_vector(7 downto 0)
			);
end COMPONENT;

signal clk 		        	: std_logic := '0';
signal rx_input_data_i  	: std_logic := '1';
signal rx_done_tick_o   	: std_logic := '0';
signal rx_data_output_o 	: std_logic_vector(7 downto 0) := (others => '0');

signal clock_period 		: time := 10 ns;
signal c_baud_time			: time := 100 ns;
constant example_hex_c1		: std_logic_vector(9 downto 0) := '1' & x"AA" & '0';
constant example_hex_c2		: std_logic_vector(9 downto 0) := '1' & x"13" & '0';
constant example_hex_c3		: std_logic_vector(9 downto 0) := '1' & x"5B" & '0';

begin


DUT : UART_RX 
			generic map(
						c_clock_freq     => c_clock_freq,
						c_baud_rate      => c_baud_rate
			)
			port	map(
						clk 		     => clk,
						rx_input_data_i  => rx_input_data_i,
						rx_done_tick_o   => rx_done_tick_o,
						rx_data_output_o => rx_data_output_o
			);



CLOCK_GENERATOR : process
	begin	
				clk <= '1';
				wait for clock_period/2;
				clk <= '0';
				wait for clock_period/2;
end process CLOCK_GENERATOR;


P_STIMULI : process
	begin
			wait for 100 ns;
			for i in 0 to 9 loop
					rx_input_data_i <= example_hex_c1(i);
					wait for c_baud_time;
			end loop;
			
			wait for c_baud_time;
			
			wait for 100 ns;
			for i in 0 to 9 loop
					rx_input_data_i <= example_hex_c2(i);
					wait for c_baud_time;
			end loop;
			
			wait for c_baud_time;
			
			wait for 100 ns;
			for i in 0 to 9 loop
					rx_input_data_i <= example_hex_c3(i);
					wait for c_baud_time;
			end loop;
			
			
			assert false
			report "SIM DONE"
			severity failure;
	
		
end process P_STIMULI;

end Behavioral;
