library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ledpnt4 is
	generic(n:integer:=72); -- length of chararray
	port(clk,mode,rst:in std_logic;-- mode n18 sw1 -rst ab15 F1
		row:out std_logic_vector(15 downto 0);
		col:out std_logic_vector(3 downto 0));
end entity;

architecture bhv of ledpnt4 is
	type code is array(0 to n-1) of std_logic_vector(15 downto 0);
	constant code_0:code:=(
	"0000000000000011",
	"0000000000001100",
	"0000000000110000",
	"0000000010010000",
	"0000000010010000",
	"0000000000110000",
	"0000000000001100",
	"0000000000000011"
	);
	signal cntscan, frame:std_logic_vector(3 downto 0);
	signal i,j,f:integer range 0 to n-1;
	signal cnt,cnt1:integer range 0 to 20;
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
				row<=code_0(conv_integer(cntscan)+j);
				col<=cntscan;
				if cntscan="1111" then
					cntscan<="0000";


