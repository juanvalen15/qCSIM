library ieee;

use ieee.std_logic_1164.all;
use ieee.math_real.all;

use IEEE.STD_LOGIC_arith.all;

library work;
use work.box.all;

entity grover_emulator is
	generic(
		dwidth : natural := 24;
		int_decimal : natural := 2;
		qubits : natural := 3
	);
	port(
		clk : in std_logic;
		rst : in std_logic;
		start : in std_logic;
		
	--Controlpath signals to check
		--k : out integer range 0 to (2**qubits)-1;

		--j : out integer range 0 to (2**qubits)-1;	-- Rows index
		input_x : in integer range 0 to (2**qubits)-1;	-- ELEMENT WE WANNA SEARCH

		--clk_en_mult : out std_logic;
				
		--s_op	   : out std_logic_vector(1 downto 0);
		--buffer_enable    : out std_logic;
		--buffer_set_value : out std_logic;
		
		--out_rst_buffer : out std_logic;
		--out_rst_mult : out std_logic;
		
		flag_read : out std_logic;
		
	--Datapath outputs
		--out_buffer : out in_out_generic((2**qubits)-1 downto 0);

		--out_operation_outputs : out in_out_generic((2**qubits)-1 downto 0);
		out_mux_dataB : out std_logic_vector(dwidth-1 downto 0)
		
		--out_C : out in_out_generic((2**qubits)-1 downto 0)

	);
end grover_emulator;

architecture rtl of grover_emulator is

	--Components
	--Grover Datapath Component
	component grover_datapath is
		generic(
			dwidth : natural := 18;
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
--			out_buffer : out in_out_generic((2**qubits)-1 downto 0);
--			
--			out_operation_outputs : out in_out_generic((2**qubits)-1 downto 0);
			out_mux_dataB : out std_logic_vector(dwidth-1 downto 0)
			

--			out_C : out in_out_generic((2**qubits)-1 downto 0)
		);
	end component grover_datapath;
	
	
	--Grover Controlpath Component
	component grover_controlpath is
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
	end component grover_controlpath;

		
			
	--signals
	signal s_rst_buffer_b : std_logic; --reset for buffer
	signal s_rst_mult_reg : std_logic; --reset for multiplier registers
	
	signal s_input_j : integer range 0 to (2**qubits)-1;	-- Rows index
	--signal s_input_x : integer range 0 to (2**qubits)-1;	-- ELEMENT WE WANNA SEARCH

	signal s_clk_enable_mult : std_logic;
	signal s_out_k : integer range 0 to (2**qubits)-1;
					
	signal s_sel_operation	   : std_logic_vector(1 downto 0);
	signal s_buffer_b_enable    : std_logic;
	signal s_buffer_b_set_value : std_logic;
	
	signal s_start : std_logic;
	signal s_rst : std_logic;
	
begin

	s_start <= not(start);
	s_rst <= not(rst);

	--k <= s_out_k;

	--j <= s_input_j;
	--x <= s_input_x;

	--clk_en_mult <= s_clk_enable_mult;
			
	--s_op	   		 <= s_sel_operation;
	--buffer_enable    <= s_buffer_b_enable;
	--buffer_set_value <= s_buffer_b_set_value;
	
	--out_rst_buffer <= s_rst_buffer_b;
	--out_rst_mult <= s_rst_mult_reg;
	
	
	datapath_component : grover_datapath
		generic map(
			dwidth => dwidth,
			int_decimal => int_decimal,
			qubits => qubits
		)
		port map(
			clk => clk,
			rst_buffer_b => s_rst_buffer_b,
			rst_mult_reg => s_rst_mult_reg,
			
			clk_enable => s_clk_enable_mult,
			
			input_j => s_input_j,
			input_x => input_x,
					
			sel_operation => s_sel_operation,
			buffer_b_enable => s_buffer_b_enable,
			buffer_b_set_value => s_buffer_b_set_value,
--			out_buffer => out_buffer,
--			
--			out_operation_outputs => out_operation_outputs,
			out_mux_dataB => out_mux_dataB
			

--			out_C => out_C
		);


	controlpath_component : grover_controlpath
		generic map(
			qubits => qubits
		)
		port map(
			clk => clk,
			rst => s_rst,
			start => s_start,
			
			rst_buffer_b => s_rst_buffer_b,
			rst_mult_reg => s_rst_mult_reg,	
			
			input_j => s_input_j,
			--input_x => s_input_x,

			clk_enable_mult => s_clk_enable_mult,
			out_k => s_out_k,
			
			s_flag_read => flag_read,
					
			sel_operation	   => s_sel_operation,
			buffer_b_enable    => s_buffer_b_enable,
			buffer_b_set_value => s_buffer_b_set_value
		);
	

end rtl;