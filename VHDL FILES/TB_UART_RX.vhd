

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_UART_RX is
			generic (
							CLOCK_FREQ 		: integer := 100_000_000;
							BAUD_RATE  		: integer := 115200
			);
end TB_UART_RX;

architecture Behavioral of TB_UART_RX is

COMPONENT UART_RX is
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
end COMPONENT;

signal CLK        		: std_logic 				   := '0';
signal RX_INPUT   		: std_logic 				   := '1';
signal RX_OUTPUT        : std_logic_vector(7 downto 0) := (others => '0');
signal RX_DONE_TICK		: std_logic 				   := '0';
signal clock_period	    : time						   := 10 ns;

constant TEXT_DATA1			: std_logic_vector(9 downto 0) := "1" & x"24" & "0";
constant TEXT_DATA2			: std_logic_vector(9 downto 0) := "1" & x"48" & "0";
constant TEXT_DATA3			: std_logic_vector(9 downto 0) := "1" & x"AF" & "0";
constant TEXT_DATA4			: std_logic_vector(9 downto 0) := "1" & x"54" & "0";
constant TEXT_DATA5			: std_logic_vector(9 downto 0) := "1" & x"42" & "0";
constant TEXT_DATA6			: std_logic_vector(9 downto 0) := "1" & x"67" & "0";
constant TEXT_DATA7			: std_logic_vector(9 downto 0) := "1" & x"54" & "0";
constant TEXT_DATA8			: std_logic_vector(9 downto 0) := "1" & x"AB" & "0";
constant TEXT_DATA9			: std_logic_vector(9 downto 0) := "1" & x"B2" & "0";
constant TEXT_DATA10		: std_logic_vector(9 downto 0) := "1" & x"A4" & "0";
constant TEXT_DATA11		: std_logic_vector(9 downto 0) := "1" & x"CC" & "0";
constant TEXT_DATA12		: std_logic_vector(9 downto 0) := "1" & x"FF" & "0";
constant BAUD_TIME 		: time 						   := (1 sec) /BAUD_RATE;

begin


DUT : UART_RX 
			generic map(
							CLOCK_FREQ 		=> CLOCK_FREQ,
							BAUD_RATE  		=> BAUD_RATE
			)		
			port 	map(
							CLK        		=> CLK,
							RX_INPUT   		=> RX_INPUT,
							RX_OUTPUT  		=> RX_OUTPUT,
							RX_DONE_TICK	=> RX_DONE_TICK
			);


	CLOCK_GENERATOR : PROCESS
		begin	
					CLK <= '1';
					wait for clock_period/2;
					CLK <= '0';
					wait for clock_period/2;
	END PROCESS CLOCK_GENERATOR;
	
	
	P_SUMILATION : PROCESS
		begin

				
				for i in 0 to 9 loop
				
						RX_INPUT <= TEXT_DATA1(i);
						wait for BAUD_TIME;
				
				end loop;
				wait for BAUD_TIME;
				
				for i in 0 to 9 loop
				
						RX_INPUT <= TEXT_DATA2(i);
						wait for BAUD_TIME;
				
				end loop;
		
				wait for BAUD_TIME;
				
				for i in 0 to 9 loop
				
						RX_INPUT <= TEXT_DATA3(i);
						wait for BAUD_TIME;
				
				end loop;		
		
				wait for BAUD_TIME;
				
				for i in 0 to 9 loop
				
						RX_INPUT <= TEXT_DATA4(i);
						wait for BAUD_TIME;
				
				end loop;		
				wait for BAUD_TIME;
				
				for i in 0 to 9 loop
				
						RX_INPUT <= TEXT_DATA5(i);
						wait for BAUD_TIME;
				
				end loop;		
				wait for BAUD_TIME;
				for i in 0 to 9 loop
				
						RX_INPUT <= TEXT_DATA6(i);
						wait for BAUD_TIME;
				
				end loop;		
				wait for BAUD_TIME;
				for i in 0 to 9 loop
				
						RX_INPUT <= TEXT_DATA7(i);
						wait for BAUD_TIME;
				
				end loop;		
				wait for BAUD_TIME;
				for i in 0 to 9 loop
				
						RX_INPUT <= TEXT_DATA8(i);
						wait for BAUD_TIME;
				
				end loop;		
				wait for BAUD_TIME;
				for i in 0 to 9 loop
				
						RX_INPUT <= TEXT_DATA9(i);
						wait for BAUD_TIME;
				
				end loop;		
				wait for BAUD_TIME;
				for i in 0 to 9 loop
				
						RX_INPUT <= TEXT_DATA10(i);
						wait for BAUD_TIME;
				
				end loop;		
				wait for BAUD_TIME;
				for i in 0 to 9 loop
				
						RX_INPUT <= TEXT_DATA11(i);
						wait for BAUD_TIME;
				
				end loop;		
				wait for BAUD_TIME;
				for i in 0 to 9 loop
				
						RX_INPUT <= TEXT_DATA12(i);
						wait for BAUD_TIME;
				
				end loop;		
				wait for BAUD_TIME;				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
	END PROCESS;
	
	

end Behavioral;
