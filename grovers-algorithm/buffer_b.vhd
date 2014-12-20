library ieee;

use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.box.all;

entity buffer_b is
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
end buffer_b;

architecture rtl of buffer_b is

	--components
	--Register with Initial Value set in ONE
	component register_initial_value_one IS
		generic(
			dwidth : natural := 32
		);
		PORT
		(
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (dwidth-1 DOWNTO 0);
			enable		: IN STD_LOGIC ;
			sclr		: IN STD_LOGIC ;
			sset		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (dwidth-1 DOWNTO 0)
		);
	END component register_initial_value_one;

	--Register with Initial Value set in ZERO
	component register_initial_value_zero IS
		generic(
			dwidth : natural := 32
		);
		PORT
		(
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (dwidth-1 DOWNTO 0);
			enable		: IN STD_LOGIC ;
			sclr		: IN STD_LOGIC ;
			sset		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (dwidth-1 DOWNTO 0)
		);
	END component register_initial_value_zero;	



	
begin
	
			
	--Register B components
	generate_registers : for i in (2**qubits)-1 downto 0 generate  
	
		gen_reg_value_one : if i = 0 generate
		reg_value_one : register_initial_value_one	
			generic map(
				dwidth => dwidth
			)
			PORT map(
				clock		=> clk,
				data		=> data_in(i),
				enable		=> enable,
				sclr		=> rst,
				sset		=> set_value,
				q		    => data_out(i)
			);
		end generate;

		gen_reg_value_zero : if i > 0 generate
		reg_value_zero : register_initial_value_zero	
			generic map(
				dwidth => dwidth
			)
			PORT map(
				clock		=> clk,
				data		=> data_in(i),
				enable		=> enable,
				sclr		=> rst,
				sset		=> set_value,
				q		    => data_out(i)
			);
		end generate;
		
	end generate generate_registers;			
			

end rtl;