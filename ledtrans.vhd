library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;

entity ledtrans is
	port(	ins:in std_logic_vector(3 downto 0);
		rst:in std_logic;
		sel:out std_logic;
		d:out std_logic_vector(7 downto 0));
end entity;
architecture ledtrans of ledtrans is
	begin
	process(ins)
		begin if(rst='1') then sel<='0';
		case ins is
			when "0000"=>d<="11111100";
			when "0001"=>d<="01100000";
			when "0010"=>d<="11011010";
			when "0100"=>d<="01100110";
			when "0101"=>d<="10110110";
			when "0110"=>d<="10111110";
			when "0111"=>d<="11100000";
			when "1000"=>d<="11111110";
			when "1001"=>d<="11110110";
			when "1010"=>d<="11101110";
			when "1011"=>d<="00111110";
			when "1100"=>d<="10011100";
			when "1101"=>d<="01111010";
			when "1110"=>d<="10011110";
			when "1111"=>d<="10001110";
			when others=>d<="00000000";
		end case;
		else sel<='1';d<=(others=>'Z');
		end if;
	end process;
end architecture;
