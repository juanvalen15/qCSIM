--package "box" definition
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-----------------------------------------------------
-- HOW CAN I MAKE A GENERIC HERE!!!!!!!!!!!!!!!!!!!!!
-----------------------------------------------------

package box is

	--types
	-- General signal
	type in_out_generic   is array (natural range <>) of std_logic_vector(23 downto 0); 

	--functions
	--FUCNTION REAL2BIN --> ALVARO CAICEDO's FUNCTION TO CONVERT REAL NUMBERS TO A BINARY REPRESENTATION
	--FUCNTION REAL2BIN --> ALVARO CAICEDO's contact: alvaro.caicedo@yahoo.com
	function real2bin(a_in: real; Nout, Mout: integer) return std_logic_vector;


end box;

package body box is

	--function real2bin
	--FUCNTION REAL2BIN --> ALVARO CAICEDO's FUNCTION TO CONVERT REAL NUMBERS TO A BINARY REPRESENTATION
	--FUCNTION REAL2BIN --> ALVARO CAICEDO's contact: alvaro.caicedo@yahoo.com
	function real2bin(a_in: real; Nout, Mout: integer) return std_logic_vector is
		variable a_real: real;
		variable a_bin: std_logic_vector(Nout+Mout-1 downto 0);
		variable negate : boolean;
	begin
		a_real := abs(a_in);
		for i in Nout-1 downto -Mout loop
			if a_real >= 2**real(i) then
				a_bin(Mout+i) := '1';
				a_real := a_real - 2**real(i);
			else
				a_bin(Mout+i) := '0';
			end if;
		end loop;

	--For sign-magnitude
--		if a_in < 0.0 then
--			a_bin(Nout+Mout-1) := '1';
--		end if;

	--For two's complement
		if a_in < 0.0 then
			negate := false;
			for i in 0 to Nout+Mout-1 loop
				if negate then
					a_bin(i) := not a_bin(i);
				else
					a_bin(i) := a_bin(i);
					if a_bin(i) = '1' then
						negate := true;
					end if;
				end if;
			end loop;
		end if;

		return a_bin;
	end function real2bin;	
	
	--How to use REAL2BIN function
	--constant cos_phi: std_logic_vector(N-1 downto 0) := real2bin(cos(phi), 2, N-2);
	-- 2 is the number of decimal bits
	-- N is the number of data width in this case im using 32 bits
	
end box;