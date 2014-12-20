library ieee;

use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_arith.all;
use ieee.math_real.all;

library work;
use work.box.all;

entity grover_controlpath is
	generic(
		qubits : natural := 2
	);
	port(
		clk : in std_logic;
		rst : in std_logic;
		start : in std_logic;
		
		rst_buffer_b : out std_logic; --reset for buffer 
		rst_mult_reg : out std_logic; --reset for multiplier registers
		
		input_j : out integer range 0 to (2**qubits)-1;	-- Rows index
		--input_x : out integer range 0 to (2**qubits)-1;	-- ELEMENT WE WANNA SEARCH

		clk_enable_mult : out std_logic;
		out_k : out integer range 0 to (2**qubits)-1;
		
		s_flag_read : out std_logic;
				
		sel_operation	   : out std_logic_vector(1 downto 0);
		buffer_b_enable    : out std_logic;
		buffer_b_set_value : out std_logic
	);
end grover_controlpath;

architecture rtl of grover_controlpath is

	--constants
	--constant k number of iterations of the algorithm
	constant k : real := ((Math_Pi)/4.0)*(sqrt(2.0**qubits));	
	

	--types
	type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11);

			
	--signals
	signal state, next_state   : state_type; 
	signal j : integer range 0 to (2**qubits)-1;
	signal s_iterations : integer range 0 to integer(floor(k));
	
	signal flag_read : std_logic;


	--components


	
begin
			
	--ELEMENT WE WANT TO SEARCH
	s_flag_read <= flag_read;
	
	--input_x <= 2; 
	
	out_k <= integer(floor(k));
	
	input_j <= j;	-- It is connected and is gonna vary only in the output section
			
	-- FSM to execute an appropiate multiplication
	process (clk, rst)
	begin
		if rst = '1' then
			state <= s0;
		elsif (rising_edge(clk)) then
			case state is
				
				when s0=>
				j <= 0;
				s_iterations <= 0;
				flag_read <= '0';
				
					if start = '1' then
						state <= s1;
					else
						state <= s0;
					end if;
					
			
				when s1=>
				j <= 0;
				s_iterations <= 0;
				flag_read <= '0';
				
					if j = (2**qubits)-2 then
						state <= s3;
					else
						state <= s2;
					end if;

				
				when s2=>
				j <= j+1;
				s_iterations <= 0;
				flag_read <= '0';
				
					if j = (2**qubits)-2 then
						state <= s3;
					else
						state <= s2;
					end if;
					
					
				when s3 =>
				j <= 0;
				s_iterations <= 0;	
				flag_read <= '0';				

					if s_iterations = integer(floor(k)) then
						state <= s10;
					else
						state <= s4;
					end if;

				
				when s4 =>
				j <= 0;
				s_iterations <= s_iterations+1;					
				flag_read <= '0';
											
					if j = (2**qubits)-2 then
						state <= s6;
					else
						state <= s5;
					end if;		
					
				
				when s5 =>	
				j <= j+1;	
				--s_iterations <= s_iterations;		
				flag_read <= '0';
							
					if j = (2**qubits)-2 then
						state <= s6;
					else
						state <= s5;
					end if;		
					
					
				when s6 =>
				j <= 0;
				--s_iterations <= s_iterations;	
				flag_read <= '0';				

					state <= s7;
					
					
				when s7 =>	
				j <= 0;			
				--s_iterations <= s_iterations;	
				flag_read <= '0';	
										
					if j = (2**qubits)-2  then
						state <= s9;
					else
						state <= s8;
					end if;					
			

				when s8 =>	
				j <= j+1;			
				--s_iterations <= s_iterations;	
				flag_read <= '0';	
				
					if j = (2**qubits)-2  then
						state <= s9;
					else
						state <= s8;
					end if;	


				when s9 =>	
				j <= 0;			
				--s_iterations <= s_iterations;	
										
					if s_iterations = integer(floor(k)) then
						flag_read <= '1';
						state <= s10;
					else
						state <= s4;
					end if;

					
				when s10 =>	
				j <= 0;			
				s_iterations <= 0;
				--flag_read <= '0';
									
					if j = (2**qubits)-2  then
						state <= s0;
					else
						state <= s11;
					end if;
					
				when s11 =>	
				j <= j+1;			
				s_iterations <= 0;
				--flag_read <= '0';
				
					if j = (2**qubits)-2  then
						flag_read <= '0';
						state <= s0;
					else
						state <= s11;
					end if;					

					
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	process (state)
	begin
		case state is
			when s0 =>
				buffer_b_enable    	<= '0';
				buffer_b_set_value 	<= '0';
				clk_enable_mult 	<= '0';
				sel_operation 		   	<= "11";
				
				rst_buffer_b <= '1';
				rst_mult_reg <= '1';

		
				
			when s1 =>
				buffer_b_enable    	<= '1';
				buffer_b_set_value 	<= '1';
				clk_enable_mult 	<= '1';
				sel_operation 		   	<= "00";
				
				rst_buffer_b <= '0';
				rst_mult_reg <= '0';
				
						

			when s2 =>
				buffer_b_enable    	<= '1';
				buffer_b_set_value 	<= '1';
				clk_enable_mult 	<= '1';
				sel_operation 		   	<= "00";

				rst_buffer_b <= '0';
				rst_mult_reg <= '0';				


			when s3 =>
				buffer_b_enable    	<= '1';
				buffer_b_set_value 	<= '1';
				clk_enable_mult 	<= '1';
				sel_operation 		   	<= "00";

				rst_buffer_b <= '0';
				rst_mult_reg <= '0';


			when s4 =>
				buffer_b_enable    	<= '1';
				buffer_b_set_value 	<= '0';
				clk_enable_mult 	<= '1';
				sel_operation 		   	<= "11";

				rst_buffer_b <= '0';
				rst_mult_reg <= '1';		


			when s5 =>
				buffer_b_enable    	<= '0';
				buffer_b_set_value 	<= '0';
				clk_enable_mult 	<= '1';
				sel_operation 		   	<= "01";

				rst_buffer_b <= '0';
				rst_mult_reg <= '0';					
				
				
			when s6 =>
				buffer_b_enable    	<= '0';
				buffer_b_set_value 	<= '0';
				clk_enable_mult 	<= '1';
				sel_operation 		   	<= "01";

				rst_buffer_b <= '0';
				rst_mult_reg <= '0';					
				
				
			when s7 =>
				buffer_b_enable    	<= '1';
				buffer_b_set_value 	<= '0';
				clk_enable_mult 	<= '1';
				sel_operation 		   	<= "11";

				rst_buffer_b <= '0';
				rst_mult_reg <= '1';					
				
								
			when s8 =>
				buffer_b_enable    	<= '0';
				buffer_b_set_value 	<= '0';
				clk_enable_mult 	<= '1';
				sel_operation 		   	<= "10";

				rst_buffer_b <= '0';
				rst_mult_reg <= '0';					
				

			when s9 =>
				buffer_b_enable    	<= '0';
				buffer_b_set_value 	<= '0';
				clk_enable_mult 	<= '1';
				sel_operation 		   	<= "10";

				rst_buffer_b <= '0';
				rst_mult_reg <= '0';				
				
				
			when s10 =>
				buffer_b_enable    	<= '1';
				buffer_b_set_value 	<= '0';
				clk_enable_mult 	<= '0';
				sel_operation 		   	<= "11";

				rst_buffer_b <= '0';
				rst_mult_reg <= '1';					
				
				
			when s11 =>
				buffer_b_enable    	<= '1';
				buffer_b_set_value 	<= '0';
				clk_enable_mult 	<= '0';
				sel_operation 		   	<= "11";

				rst_buffer_b <= '0';
				rst_mult_reg <= '1';	


				
				
		end case;
		
				
		
	end process;


			

end rtl;