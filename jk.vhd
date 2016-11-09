library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
entity jk is
        port(
        j,k,clk:in std_logic;
        qq,nq:out std_logic;
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

