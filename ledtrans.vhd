library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;

entity ledtrans is
	port(	ins:in std_logic_vector(3 downto 0);
		rst,pnt:in std_logic;
		sel:out std_logic;
		d:out std_logic_vector(7 downto 0));
end entity;
architecture ledtrans of ledtrans is
	begin
	process(ins)
		begin if(rst='1') then sel<='0';
		case ins is
			when "0000"=>d<="1111110"&pnt;
			when "0001"=>d<="0110000"&pnt;
			when "0010"=>d<="1101101"&pnt;
			when "0011"=>d<="1111001"&pnt;
			when "0100"=>d<="0110011"&pnt;
			when "0101"=>d<="1011011"&pnt;
			when "0110"=>d<="1011111"&pnt;
			when "0111"=>d<="1110000"&pnt;
			when "1000"=>d<="1111111"&pnt;
			when "1001"=>d<="1111011"&pnt;
			when "1010"=>d<="1110111"&pnt;
			when "1011"=>d<="0011111"&pnt;
			when "1100"=>d<="1001110"&pnt;
			when "1101"=>d<="0111101"&pnt;
			when "1110"=>d<="1001111"&pnt;
			when "1111"=>d<="1000111"&pnt;
			when others=>d<="0000000"&pnt;
		end case;
		else sel<='1';d<=(others=>'0');
		end if;
	end process;
end architecture;
