library ieee;

use ieee.std_logic_1164.all;
use ieee.math_real.all;

USE ieee.numeric_std.ALL;

library work;
use work.box.all;

entity operation_parallel is
	generic(
		dwidth : natural := 32;
		qubits : natural := 2
	);
	port(
		
		--in_i : in integer;
		in_j : in integer range 0 to (2**qubits)-1;
		in_x : in integer range 0 to (2**qubits)-1;
		
		sel_operation : in std_logic_vector(1 downto 0);
		
		operation_outputs : out in_out_generic((2**qubits)-1 downto 0)
	);
end operation_parallel;

architecture rtl of operation_parallel is

	--components
	component operation_element is
		generic(
			dwidth : natural := 18;
			qubits : natural := 2
		);
		port(
			input_i : in integer range 0 to (2**qubits)-1;	-- Matrix Rows
			input_j : in integer range 0 to (2**qubits)-1;   -- Matrix Columns		
			input_x : in integer range 0 to (2**qubits)-1;   -- Element we search
			
			sel_operation : in std_logic_vector(1 downto 0);
					
			op_e_ij : out std_logic_vector(dwidth-1 downto 0)  --Output operation_element_ij
		);
	end component operation_element;



begin

	--Blocks Generation
	op_e : for i in (2**qubits)-1 downto 0 generate
	op_component : operation_element
		generic map(
			dwidth => dwidth,
			qubits => qubits
		)
		port map(
			input_i => i,
			input_j => in_j,
			input_x => in_x,
			
			sel_operation => sel_operation,
					
			op_e_ij => operation_outputs(i)
		);
	end generate op_e;
	


end rtl;