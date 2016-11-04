library ieee;
--use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
entity oc2 is
	port(a,b,c:in std_logic;
		y:out std_logic);
end entity;
architecture oc2 of oc2 is
begin process(a,b,c)
begin	case c is
		when '1' => y <= (a nand b);
		when others => y <= 'Z';
	end case;
end process;
end architecture;
