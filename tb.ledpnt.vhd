--
--
--

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_ledpnt is
	generic(n:integer:=72); -- length of chararray
	port( --clk:in std_logic;
	mode,rst:in std_logic;-- mode n18 sw1 -rst ab15 F1
		row:out std_logic_vector(15 downto 0);
		col:out std_logic_vector(3 downto 0));
end entity;

architecture bhv of tb_ledpnt is
	signal clk:std_logic;
	type code is array(0 to n-1) of std_logic_vector(15 downto 0);
	constant code_0:code:=(
	"0000000000000011",
	"0000000000001100",
	"0000000000110000",
	"0000000010010000",
	"0000000010010000",
	"0000000000110000",
	"0000000000001100",
	"0000000000000011",
	"0000000000000000",
	"0000000011111111",
	"0000000010010001",
	"0000000010010001",
	"0000000010010001",
	"0000000010101010",
	"0000000001000100",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000"
	);
	signal cntscan, frame:std_logic_vector(3 downto 0):="0000";
	signal i,j,f:integer range 0 to n-1:=0;
	signal cnt,cnt1:integer range 0 to 20:=0;
begin
process(clk,frame,rst) begin
	if rst='0' then
		cntscan<="0000";frame<="0000";i<=0;j<=0;cnt<=0;cnt1<=0;
		row<=x"0000";
	elsif clk'event and clk='1' then
		if mode='0' then
			if f=4 then
				f<=0;j<=0;
			else
				row<=code_0((to_integer(unsigned(cntscan))+j)mod n);
				col<=cntscan;
				if cntscan="1111" then
					cntscan<="0000";
					cnt1<=(cnt1+1)mod 20;
				else
					cntscan<=std_logic_vector(unsigned(cntscan)+1);
				end if;
				if cnt1=30 then
					j<=j+18;
					f<=f+1;
					cnt1<=0;
				end if;
			end if;
		else
			col<=frame;
			row<=code_0((i+to_integer(unsigned(frame)))mod n);
			if(frame="1111") then
				i<=i+1;
				cnt<=(cnt+1)mod 20;
				frame<="0000";
			end if;
			if i=n-1 then
				i<=0;
			else
				if cnt1=10 then
					i<=i+1;
					cnt<=0;
				end if;
			end if;
			frame<=std_logic_vector(unsigned(frame)+1);
		end if;
	end if;
end process;
tb:process begin
	clk<='0';
	wait for 100 us;
	clk<='1';
	wait for 100 us;
end process;
end architecture;
configuration CFG_TB of tb_jk is
	for bhv
		end for;
end configuration;
