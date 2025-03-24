-- UART RX DESING WITH MID SAMPLING TECHNIQUE
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_RX is
			generic (
							CLOCK_FREQ 		: integer := 100_000_000;
							BAUD_RATE  		: integer := 115200
			);			
			port 	(
							CLK        		: in  std_logic;
							RX_INPUT   		: in  std_logic;
							RX_OUTPUT  		: out std_logic_vector(7 downto 0);
							RX_DONE_TICK	: out std_logic
			);
end UART_RX;

architecture Behavioral of UART_RX is


type states is (RX_IDLE_STATE, RX_START_STATE, RX_DATA_RECEIVE_STATE, RX_STOP_STATE);
signal state : states := RX_IDLE_STATE;

--SIGNAL DECLERATIONS
constant bit_timer_limit : integer 	:= CLOCK_FREQ/BAUD_RATE;

--CONSTANT DECLERATIONS
signal bit_timer    	 : integer range 0 to bit_timer_limit := 0;
signal bit_counter		 : integer range 0 to 7 			  := 0;
signal rx_data_register  : std_logic_vector (7 downto 0)      := (others => '0'); 

begin

	process(CLK)
		begin
		
						if rising_edge(CLK) then
						
									case state is
											
													when RX_IDLE_STATE => 													
														RX_DONE_TICK <= '0';
														bit_timer    <=  0 ;
														
														if(RX_INPUT = '0') then
														
																state <= RX_START_STATE;
																								
														end if;
													
													when RX_START_STATE =>
													
														if (bit_timer = bit_timer_limit/2 - 1) then
														
																	state <= RX_DATA_RECEIVE_STATE;
																	bit_timer <= 0;
														
														else
														
																	bit_timer <= bit_timer + 1;
															
														end if;
													
													
													when RX_DATA_RECEIVE_STATE => 
													
														if (bit_counter = 8) then
														
																	
																bit_counter <= 0;
																state 		<= RX_STOP_STATE;
																
														
														else
														
															if (bit_timer = bit_timer_limit - 1) then
															
																	rx_data_register(7) 		  <= RX_INPUT; -- MID SAMPLING TECHNIQUE
																	rx_data_register(6 downto 0)  <= rx_data_register(7 downto 1);
																	bit_counter 				  <= bit_counter + 1;
																	bit_timer    				  <= 0; 
															
															else
																
																	bit_timer <= bit_timer + 1;
															
															end if;
																
														
														
														end if;
													
													
													when RX_STOP_STATE => 
													
																	if (bit_timer = bit_timer_limit - 1) then
																	
																			bit_timer 	 <= 0;
																			RX_DONE_TICK <= '1';
																			state 		 <= RX_IDLE_STATE;
																	
																	else
																	
																		bit_timer <= bit_timer + 1;
																	
																	end if;
													
													
													when others =>
													
															state <= RX_IDLE_STATE;
									
									end case;
						
						end if;

	end process;

RX_OUTPUT <= rx_data_register;

end Behavioral;
