-- CUSTOM UART COMM PROTOCOL RX MODULE

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UART_RX is
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
end UART_RX;


architecture Behavioral of UART_RX is
-- CONSTANT DECLERATIONS
constant c_bit_timer_limit   : integer := c_clock_freq/c_baud_rate;
-- SIGNAL DECLERATIONS
signal bit_timer 			 : integer range 0 to c_bit_timer_limit := 0;
signal bit_counter			 : integer range 0 to 7 := 0;
signal bit_shifter_register	 : std_logic_vector(7 downto 0) := (others => '0');

type states is (RX_IDLE_STATE, RX_START_FRAME, RX_DATA_RECEIVE, RX_STOP_FRAME);
signal state : states := RX_IDLE_STATE;

begin

	process(clk)
		begin
		
			if (rising_edge(clk)) then
				
				case state is 

						when RX_IDLE_STATE   => 
								
									rx_done_tick_o <= '0';
									bit_timer      <= 0;
									if (rx_input_data_i = '0') then -- hat 0' a düştüğünde
											state <= RX_START_FRAME;
									end if;
						
						when RX_START_FRAME  => 

									if (bit_timer = (c_bit_timer_limit/2) - 1)then	-- MID BIT SAMPLING
									
											state 		<= RX_DATA_RECEIVE;
											bit_timer   <= 0;								
									else
											bit_timer   <= bit_timer + 1;
									end if;

						when RX_DATA_RECEIVE =>
						
									if (bit_timer = c_bit_timer_limit - 1) then
									
											if (bit_counter = 7) then
											
														state <= RX_STOP_FRAME;
														bit_counter <= 0;
											else 
														bit_counter <= bit_counter + 1;
											end if;
											bit_shifter_register <= rx_input_data_i & (bit_shifter_register(7 downto 1));
											bit_timer <= 0;
									else
											bit_timer <= bit_timer + 1;
									end if;
						
						when RX_STOP_FRAME	 =>
						
									if (bit_timer = c_bit_timer_limit - 1) then
											rx_done_tick_o <= '1';
											state <= RX_IDLE_STATE;
											bit_timer <= 0;
									else
											bit_timer <= bit_timer + 1;
									end if;
						
						when others 		 => 
									state <= RX_IDLE_STATE;
						
				end case;		
			end if;
	end process;
	rx_data_output_o <= bit_shifter_register;
end Behavioral;
