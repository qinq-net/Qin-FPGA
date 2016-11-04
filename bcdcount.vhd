library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcdcount is
port(
	ina,inb:in std_logic;
	qa,qb,qc,qd:out std_logic;
	r0,r9:in std_logic_vector(1 downto 0));
end entity;

architecture bcdcount of bcdcount is
	signal c5:std_logic_vector(2 downto 0):="100";
	signal c2:std_logic:='1';
begin
	process(ina,r0,r9) --count2
	begin
		if(r9="11") then c2<='1';
		elsif(r0="11") then c2<='0';
		elsif(ina'event and ina='0') then c2 <= not c2;
		end if;
	end process;
	process(inb,r0,r9) --count5
	begin
		if(r9="11") then c5<="100";
		elsif(r0="11") then c5<="000";
		elsif(inb'event and inb='0') then
			case c5 is
				when "000"=>c5<="001";
				when "001"=>c5<="010";
				when "010"=>c5<="011";
				when "011"=>c5<="100";
				when "100"=>c5<="000";
				when others=>c5<="ZZZ";
			end case;
		end if;
	end process;
	qa<=c2;qb<=c5(0);qc<=c5(1);qd<=c5(2);
end architecture;
