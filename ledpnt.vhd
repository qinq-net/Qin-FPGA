------------------------------------------------------------------------------------------
-- ledpnt.vhd -- LED 8*8 Lattice Driver
-- Copyright (C) 2016 Beihang University, School of Physics and Nuclear Energy Engineering
-- Author: QIN Yuhao <qinq_net@buaa.edu.cn>
-- Note:OUTPUT:="\u541b\u306e\u540d\u306f\u3002"
------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ledpnt is
	generic(n:integer:=72); -- length of chararray
	port( clk:in std_logic; --clk->P20(EA2_p6)~FRQ_Q11(1024Hz)
	mode:in std_logic; --mode->N18(SW1) RST->AB15(F1)
	rst:in std_logic;
	row:out std_logic_vector(15 downto 0);
-- 	row(15 downto 0) ->	A4 A5 A6 B6 E11 C13 F11 C15
--				E14 B7 B8 B9 B10 D10 F9 A13
	col:out std_logic_vector(3 downto 0));
-- 	col 0->A14(COL1) 1->A15(COL2) 2->A16(COL3) 3->C4(COL4)
end entity;

architecture bhv of ledpnt is
	type code is array(0 to n-1) of std_logic_vector(15 downto 0);
	constant code_0:code:=(
	"0000000000000000", --kimi
	"0000000000000000",
	"0000000001000000",
	"0000100001000100",
	"0001001001001000",
	"0001001010110000",
	"0001001011100000",
	"0001111011111100",
	"0001111110100100",
	"0001010010100100",
	"0001010010100100",
	"0001111110100100",
	"0000010000111100",
	"0000010000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000", --no
	"0000000000000000",
	"0000000000000000",
	"0000000111100000",
	"0000001000010000",
	"0000010000010000",
	"0000100000010000",
	"0000100000100000",
	"0000100011000000",
	"0000111100000100",
	"0000100000001100",
	"0000010000111000",
	"0000001111000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000", --namae
	"0000000000000000",
	"0000000100000000",
	"0000000100010000",
	"0000001000110000",
	"0000010000100000",
	"0000101101000000",
	"0111000111111100",
	"0001000101000100",
	"0001001001000100",
	"0001010001000100",
	"0001110001000100",
	"0001100001111100",
	"0001000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000", --ha
	"0000000000000000",
	"0000000000000000",
	"0000000111111000",
	"0000111000001000",
	"0001000000011000",
	"0000000000000000",
	"0000000000111000",
	"0000001000101000",
	"0000001000101000",
	"0000001001110000",
	"0000001110010000",
	"0001110000001000",
	"0000010000001000",
	"0000010000000000",
	"0000000000000000",
	"0000000000000000", --puncmark
	"0000000000110000",
	"0000000001001000",
	"0000000010000100",
	"0000000010000100",
	"0000000001001000",
	"0000000000110000",
	"0000000000000000");
	signal cntscan, frame:std_logic_vector(3 downto 0):="0000";
	signal i,j,f:integer range 0 to n-1:=0;
	signal cnt,cnt1:integer range 0 to 32767:=0;
begin
process(clk,frame,rst) begin
	if rst='0' then
		cntscan<="0000";frame<="0000";i<=0;j<=0;cnt<=0;cnt1<=0;
		row<=x"0000";
	elsif clk'event and clk='1' then
		if mode='0' then
			if f=n/16 then
				f<=0;j<=0;
			else
				row<=code_0((to_integer(unsigned(cntscan))+j)mod n);
				col<=cntscan;
				if cntscan="1111" then
					cntscan<="0000";
					if cnt1=15 then
						j<=j+16;
						f<=f+1;
					end if;
					cnt1<=(cnt1+1)mod 16;
				else
					cntscan<=std_logic_vector(unsigned(cntscan)+1);
				end if;
			end if;
		else
			col<=frame;
			row<=code_0((i+to_integer(unsigned(frame)))mod n);
			if(frame="1111") then
				--i<=i+1;
				if cnt=15 then i<=(i+1)mod n;end if;
				cnt<=(cnt+1)mod 16;
				frame<="0000";
			else frame<=std_logic_vector(unsigned(frame)+1);
			end if;
		end if;
	end if;
end process;
end architecture;
