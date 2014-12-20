library ieee;

use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.box.all;

entity column_vector_multiplier is
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
end column_vector_multiplier;

architecture rtl of column_vector_multiplier is

	--components
	component datapath_fixed is
		generic(
				dwidth : natural := 18;
				int : natural := 2 --integer part of the (2*dwidth) bits
				);
		port(
			clk : in std_logic;
			rst : in std_logic;
			clk_enable : in std_logic;
			
			A : in std_logic_vector(dwidth-1 downto 0);
			B : in std_logic_vector(dwidth-1 downto 0);

			C : out std_logic_vector(dwidth-1 downto 0)
		);
	end component datapath_fixed;
	
	
begin
			
	--Datapath Blocks Generation This datapath is the Multiplier Accumulator for two inputs
	de : for i in (2**qubits)-1 downto 0 generate  --Datapath elements
	datapath_component : datapath_fixed
		generic map(
				dwidth => dwidth,
				int    => int_decimal
				)
		port map(
			clk => clk,
			rst => rst,
			clk_enable => clk_enable,
			
			A => inputA(i),
			B => inputB,

			C => outputC(i)
		);
	end generate de;			
			

		


end rtl;