library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
entity sum4 is
        port(
        INA,INB:in std_logic_vector(3 downto 0);
        OUTS:out std_logic_vector(3 downto 0);
        INC:in std_logic;
        OUTY:out std_logic);
end entity;
architecture sum4 of sum4 is
        signal a,b,c,s:std_logic_vector(3 downto 0);
        begin process(INA,INB)
		begin a<=INA;b<=INB;
		c(0)<=INC;
		s(0)<=a(0) xor b(0) xor c(0);
		c(1)<=(a(0) and b(0)) or (c(0) and (a(0) xor b(0)));
		s(1)<=a(1) xor b(1) xor c(1);
		c(2)<=(a(1) and b(1)) or (c(1) and (a(1) xor b(1)));
		s(2)<=a(2) xor b(2) xor c(2);
		c(3)<=(a(2) and b(2)) or (c(2) and (a(2) xor b(2)));
		s(3)<=a(3) xor b(3) xor c(3);
		OUTY<=(a(3) and b(3)) or (c(3) and (a(3) xor b(3)));
		OUTS<=s;
        end process;
end architecture;

