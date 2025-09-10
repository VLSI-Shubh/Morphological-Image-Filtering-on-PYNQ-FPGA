library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY FilterSelectColorG IS
GENERIC (
n: INTEGER := 3; --number of coefficients (always square - n pixels per side)
m: INTEGER := 9;  --number of bits per coefficient
pixperline: INTEGER := 64  --number of pixels per video line 
); 

PORT (clk, rst: 	IN STD_LOGIC;
--load: 			IN STD_LOGIC; --to enter new coefficient values
run: 			IN STD_LOGIC; --to compute the output
x_inputG: 	IN SIGNED(m-1 DOWNTO 0);
--switch: IN Unsigned(3 downto 1);
switch_0 : in std_logic;
switch_1 : in std_logic;

yG: 			OUT SIGNED(m-1 DOWNTO 0)
--overflow:   OUT STD_LOGIC
);
END FilterSelectColorG;

-----------------------------------------------------------------
ARCHITECTURE Behavioral OF FilterSelectColorG IS
TYPE internal_array_c IS ARRAY (1 TO 9) OF SIGNED(m-1 DOWNTO 0);

TYPE internal_array_x IS ARRAY (1 TO (n-1)*pixperline+3) OF SIGNED(m-1 DOWNTO 0);   -- assume 3x3 array

--SIGNAL c: internal_array_c; --stored coefficients
--Signal switch: unsigned(2 downto 0);
SIGNAL x: internal_array_x; --stored input values

--SIGNAL coef_input_signed: 		SIGNED(m-1 DOWNTO 0);
BEGIN
PROCESS (clk, rst)
	VARIABLE acc: SIGNED(m-1 DOWNTO 0) := (OTHERS=>'0');
    Variable Kernel: internal_array_c;
	VARIABLE sign_prod, sign_acc: STD_LOGIC;
	variable temp: signed(m-1 downto 0);
	variable switch0: STD_LOGIC;
	variable switch1: STD_LOGIC;
	
BEGIN
--Reset:---------------------------------   
		IF (rst='0') THEN

			FOR i IN 1 TO (n-1)*pixperline+3 LOOP


				FOR j IN m-1 DOWNTO 0 LOOP

						x(i)(j) <= '0';

				END LOOP;
			END LOOP;
--Shift registers:-----------------------
		ELSIF (clk'EVENT AND clk='1') THEN

			
				
			IF (run='1') THEN
				x <= (x_inputG & x(1 TO (n-1)*pixperline + 2));


			END IF;
		END IF;
		
--MACs and output (w/ overflow check):---
		acc := (OTHERS=>'0');
-- Here we add the bulk of the changes: 
		FOR i IN 1 TO 3 LOOP
	kernel(i) := x(((i-1)*pixperline)+1)*1;
	kernel(i+3) := x(((i-1)*pixperline)+2)*1;
	kernel(i+6) := x(((i-1)*pixperline)+3)*1;
	
	

		END LOOP;
		for j in 1 to 9 loop
	        for k in j+1 to 9 loop
	        if(kernel(j) > kernel(k)) then
	        temp:=kernel(k);
	        kernel(k):=kernel(j);
	        kernel(j):=temp;
	        end if;
	        end loop;
	end loop;
		if(switch_0 = '0' and switch_1= '0') then
		acc:=kernel(1);
		elsif(switch_0 = '0' and switch_1= '1') then
		acc:=kernel(9);
		elsif(switch_0 = '1' and switch_1= '0')then
		acc:=kernel(5);
		else
		acc:=((kernel(1)+kernel(2)+kernel(3)+kernel(4)+kernel(5)+kernel(6)+kernel(7)+kernel(8)+kernel(9))/9);
		end if;
		IF (clk'EVENT AND clk='1') THEN

			yG <= acc;

		END IF;
END PROCESS;
END Behavioral;