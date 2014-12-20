library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library work;
use work.box.all;

library work;
use work.txt_util.all;

entity mux_generic is
	generic(
		dwidth : natural := 32;
		qubits : natural := 2
	);
	port(
	
		input : in in_out_generic((2**qubits)-1 downto 0);
				
		sel : in std_logic_vector(qubits-1 downto 0);
		
		out_mux : out std_logic_vector(dwidth-1 downto 0) 
	);
end mux_generic;

architecture rtl of mux_generic is

	--signal
	signal s_sel : unsigned(qubits-1 downto 0);


begin

	s_sel <= unsigned(sel);
	
	out_mux <= input(conv_integer(s_sel));


end rtl;