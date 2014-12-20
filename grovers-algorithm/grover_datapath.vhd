library ieee;

use ieee.std_logic_1164.all;
use ieee.math_real.all;

USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

library work;
use work.box.all;

entity grover_datapath is
	generic(
		dwidth : natural := 32;
		int_decimal : natural := 2;
		qubits : natural := 2
	);
	port(
		clk : in std_logic;
		rst_buffer_b : in std_logic; --reset for buffer 
		rst_mult_reg : in std_logic; --reset for multiplier registers
		
		clk_enable : in std_logic;
		
		input_j : in integer range 0 to (2**qubits)-1;	-- Column index
		input_x : in integer range 0 to (2**qubits)-1;	-- ELEMENT WE WANNA SEARCH
				
		sel_operation : in std_logic_vector(1 downto 0);
		buffer_b_enable : in std_logic;
		buffer_b_set_value : in std_logic;
		
		--out_operation_outputs : out in_out_generic((2**qubits)-1 downto 0);
		out_mux_dataB : out std_logic_vector(dwidth-1 downto 0)
		--out_buffer : out in_out_generic((2**qubits)-1 downto 0);
		

--		out_C : out in_out_generic((2**qubits)-1 downto 0)
	);
end grover_datapath;

architecture rtl of grover_datapath is

	--components
	--OPERATION ELEMENTS
	component operation_parallel is
		generic(
			dwidth : natural := 18;
			qubits : natural := 2
		);
		port(
			
			--in_i : in integer;
			in_j : in integer range 0 to (2**qubits)-1;
			in_x : in integer range 0 to (2**qubits)-1;
			
			sel_operation : in std_logic_vector(1 downto 0);
			
			operation_outputs : out in_out_generic((2**qubits)-1 downto 0)
		);
	end component operation_parallel;	


	
	--COLUMN VECTOR MULTIPLIER
	component column_vector_multiplier is
		generic(
			dwidth : natural := 18;
			int_decimal : natural := 2;
			qubits : natural := 2
		);
		port(
			clk : in std_logic;
			rst : in std_logic;
			clk_enable : in std_logic;
			
			inputA : in in_out_generic((2**qubits)-1 downto 0);
			--inputB : in in_out_generic((2**qubits)-1 downto 0);
			inputB : in std_logic_vector(dwidth-1 downto 0);
			
			outputC : out in_out_generic((2**qubits)-1 downto 0)
		);
	end component column_vector_multiplier;

	
	--BUFFER DATA IN B
	component buffer_b is
		generic(
			dwidth : natural := 32;
			qubits : natural := 2
		);
		port(
			clk 	  : in std_logic;
			rst 	  : in std_logic;
			enable 	  : in std_logic;
			set_value : in std_logic;
			
			data_in : in in_out_generic((2**qubits)-1 downto 0);
			
			data_out : out in_out_generic((2**qubits)-1 downto 0)
		);
	end component buffer_b;	
	
	--MUX GENERIC AFTER BUFFER B DATA
	component mux_generic is
		generic(
			dwidth : natural := 32;
			qubits : natural := 2
		);
		port(
		
			input : in in_out_generic((2**qubits)-1 downto 0);
					
			sel : in std_logic_vector(qubits-1 downto 0);
			
			out_mux : out std_logic_vector(dwidth-1 downto 0) 
		);
	end component mux_generic;


			
	--signals
	--signals for multiplexer
	signal s_input_j : std_logic_vector(qubits-1 downto 0);
	signal s_operation_outputs : in_out_generic((2**qubits)-1 downto 0);
	
	signal s_out_C : in_out_generic((2**qubits)-1 downto 0);
	
	signal s_to_dataB : std_logic_vector(dwidth-1 downto 0);
	signal s_to_mux_dataB : in_out_generic((2**qubits)-1 downto 0);
	
	signal signal_test : in_out_generic((2**qubits)-1 downto 0);
	
	
begin


	s_input_j <= std_logic_vector(to_unsigned(input_j,qubits));
			
	--Operations in Parallel Component
	operations_component : operation_parallel
		generic map(
			dwidth => dwidth,
			qubits => qubits
		)
		port map(
			
			--in_i : in integer;
			in_j => input_j,
			in_x => input_x,
			
			sel_operation => sel_operation,
			
			operation_outputs => s_operation_outputs
		);	
		
		
	--Column Vector Multiplier Component
	column_vector_multiplier_component : column_vector_multiplier
		generic map(
			dwidth => dwidth,
			int_decimal => int_decimal,
			qubits => qubits
		)
		port map(
			clk => clk,
			rst => rst_mult_reg,
			clk_enable => clk_enable,
			
			inputA => s_operation_outputs,
			--inputB : in in_out_generic((2**qubits)-1 downto 0);
			inputB => s_to_dataB,
			
			outputC => s_out_C
		);
	
	--Buffer for Data-In B
	buffer_data_b : buffer_b
		generic map(
			dwidth => dwidth,
			qubits => qubits
		)
		port map(
			clk 	  => clk,
			rst 	  => rst_buffer_b,
			enable 	  => buffer_b_enable,
			set_value => buffer_b_set_value,
			
			data_in => s_out_C,
			
			data_out => s_to_mux_dataB
		);	
		
	--Mux for input data B
	mux_in_data_b : mux_generic 
		generic map(
			dwidth => dwidth,
			qubits => qubits
		)
		port map(
		
			input => s_to_mux_dataB,
					
			sel => s_input_j,
			
			out_mux => s_to_dataB
		);	
		
	
	--Outputs
	--out_operation_outputs <= s_operation_outputs; --output multiplexer with transformations
	
	out_mux_dataB <= s_to_dataB; --output multiplexer for Buffer B
	
	--out_buffer <= s_to_mux_dataB;	
	
	--out_C <= s_out_C; --output vector or quantum state
	



end rtl;