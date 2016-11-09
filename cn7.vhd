library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
--use ieee.numeric_std.all;

entity cn7 is
	port(clk:in std_logic; --rising edge --clk->P20(EA2_p6)~FRQ_Q9(4096Hz)
	start:in std_logic; --low level effective --start->M20(SW3)
	KBCol:in std_logic_vector(3 downto 0);
--	KBCol 0->B10(SWC0) 1->D10(SWC1) 2->F9(SWC2) 3->A13(SWC3)
	KBRow:out std_logic_vector(3 downto 0);
--	KBRow 3->A14(SWR0) 2->A15(SWR1) 1->A16(SWR2) 0->C4(SWR3)
	seg7:out std_logic_vector(6 downto 0);
--	scan 7->AB20(DS1) 6->Y21(DS2) 5->Y22(DS3) 4->W22(DS4) 3->V22(DS5) 2->U22(DS6) 1->AA17(DS7) 0->V16(DS8)
--	seg7 7->AA20(LA) 6->W20(LB) 5->R21(LC) 4->P21(LD) 3->N21(LE) 2->N20(LF) 1->M21(LG) 0->M19(LH)
	scan:out std_logic_vector(7 downto 0));
end entity;
architecture bev of cn7 is
	signal count,sta:std_logic_vector(1 downto 0):="00";
	signal seg7_sgn:std_logic_vector(6 downto 0):=(others=>'0');
begin
	scan<="11111110";
	a:process(clk) begin
		if(clk'event and clk='1') then
			count<=count+1;
			--count<=std_logic_vector(unsigned(count)+1);
		end if;
	end process;
	b:process(clk) begin
		if(clk'event and clk='1') then
			case count(1 downto 0) is
				when "00"=>KBRow<="0111";sta<="00";
				when "01"=>KBRow<="1011";sta<="01";
				when "10"=>KBRow<="1101";sta<="10";
				when "11"=>KBRow<="1110";sta<="11";
				when others=>KBRow<="ZZZZ";sta<="ZZ";
			end case;
		end if;
	end process b;
	c:process(clk,start) begin
		if(start='0') then
			seg7_sgn<="0000000";
			case sta is
				when "00"=>
					case KBCol is
						when "1110"=>seg7_sgn<="1001110"; --"1001110"; --c c
						when "1101"=>seg7_sgn<="0111101"; --"1111111"; --8 d
						when "1011"=>seg7_sgn<="1001111"; --"0110011"; --4 e
						when "0111"=>seg7_sgn<="1000111"; --"1111110"; --0 f
						when others=>seg7_sgn<="0000000";
					end case;
				when "01"=>
					case KBCol is
						when "1110"=>seg7_sgn<="1111110"; --0	"1111111"; --"0111101"; --d 8
						when "1101"=>seg7_sgn<="0110000"; --1	"1110011"; --"1110011"; --9 9
						when "1011"=>seg7_sgn<="1101101"; --2	"1110111"; --"1011011"; --5 a
						when "0111"=>seg7_sgn<="1111001"; --3	"0011111"; --"0110000"; --1 b
						when others=>seg7_sgn<="0000000";
					end case;
				when "10"=>
					case KBCol is
						when "1110"=>seg7_sgn<="0110011"; --"1001111"; --e 4
						when "1101"=>seg7_sgn<="1011011"; --"1110111"; --a 5
						when "1011"=>seg7_sgn<="1011111"; --"1011111"; --6 6
						when "0111"=>seg7_sgn<="1110000"; --"1101101"; --2 7
						when others=>seg7_sgn<="0000000";
					end case;
				when "11"=>
					case KBCol is
						when "1110"=>seg7_sgn<="1111111"; --8	"1111110"; --"1000111"; --f 0
						when "1101"=>seg7_sgn<="1110011"; --9	"0110000"; --"0011111"; --b 1
						when "1011"=>seg7_sgn<="1110111"; --A	"1101101"; --"1110000"; --7 2
						when "0111"=>seg7_sgn<="0011111"; --B	"1111001"; --"1111001"; --3 3
						when others=>seg7_sgn<="0000000";
					end case;
				when others=>null;
			end case;
		end if;
	end process c;
	seg7<=seg7_sgn;
end architecture;

