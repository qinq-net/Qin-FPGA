------------------------------------------------------------------------------------------
-- ledtrans.vhd -- bin2LED Translator
-- Copyright (C) 2016 Beihang University, School of Physics and Nuclear Energy Engineering
-- Author: QIN Yuhao <qinq_net@buaa.edu.cn>
------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ledtrans is
	port(	ins:in std_logic_vector(3 downto 0);
--		ledcon	7->AB20(DS1) 6->Y21(DS2) 5->Y22(DS3) 4->W22(DS4)
--			3->V22(DS5) 2->U22(DS6) 1->AA17(DS7) 0->V16(DS8)
		rst,pnt:in std_logic; --rst->'1', pnt->'0'
		sel:out std_logic; --sel->open
		d:out std_logic_vector(7 downto 0));
--		ledout	7->AA20(LA) 6->W20(LB) 5->R21(LC) 4->P21(LD)
--			3->N21(LE) 2->N20(LF) 1->M21(LG) 0->M19(LH)
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
