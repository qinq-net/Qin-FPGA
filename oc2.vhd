------------------------------------------------------------------------------------------
-- oc2.vhd -- 2 input OC door
-- Copyright (C) 2016 Beihang University, School of Physics and Nuclear Energy Engineering
-- Author: QIN Yuhao <qinq_net@buaa.edu.cn>
------------------------------------------------------------------------------------------
library ieee;
--use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
entity oc2 is
	port(a,b,c:in std_logic; --a->N18(SW1), b->M20(SW2), c->AA15(SW3)
		y:out std_logic); --y->U12(LED1,CON1.2)
end entity;
architecture oc2 of oc2 is
begin process(a,b,c)
begin	case c is
		when '1' => y <= (a nand b);
		when others => y <= 'Z';
	end case;
end process;
end architecture;
