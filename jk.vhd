------------------------------------------------------------------------------------------
-- jk.vhd -- 74LS74 JK trigger
-- Copyright (C) 2016 Beihang University, School of Physics and Nuclear Energy Engineering
-- Author: QIN Yuhao <qinq_net@buaa.edu.cn>
------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity jk is
        port(
        j,k,clk:in std_logic;
--	j->V13(SW4) k->D6(SW5) clk->AB15(F1,CON1.10) sd->C8(SW6) rd->E7(SW7)
        qq,nq:out std_logic; -- jkq->V15(LED3) jknq->W13(LED4)
        sd,rd:in std_logic);
end entity;
architecture jk of jk is
signal q:std_logic:='0';
begin process(sd,rd,clk)
        begin if(sd='0' and rd='1') then q<='0';nq<='1';
        elsif(sd='1' and rd='0') then q<='1';nq<='0';
        elsif(sd='1' and rd='1') then q<='1';nq<='1';
        elsif(clk'event and clk='1') then
                q<=(j and not q) or (not k and q);
                nq<=not((j and not q) or (not k and q));
        end if;
end process;
qq<=q;
end architecture;

