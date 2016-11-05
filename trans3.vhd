library ieee;
use ieee.std_logic_1164.all;

entity trans3 is
	port(
		ins:in std_logic_vector(2 downto 0);
		notpwr:in std_logic; --low level effective
		outs:out std_logic_vector(7 downto 0));
end entity;

architecture trans3 of trans3 is
begin
process(ins,notpwr) begin
	if (notpwr='0') then
	case ins is
		when "000"=>outs<="11111110";
		when "001"=>outs<="11111101";
		when "010"=>outs<="11111011";
		when "011"=>outs<="11110111";
		when "100"=>outs<="11101111";
		when "101"=>outs<="11011111";
		when "110"=>outs<="10111111";
		when "111"=>outs<="01111111";
		when others=>outs<=(others=>'1');
	end case;
	else outs<=(others=>'Z');
	end if;
end process;
end architecture;