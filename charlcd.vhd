library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
entity charlcd is
	generic(freq:integer:=24000000;
		N:integer:=24000000/250000;
--		N:integer:=200;
		delay:integer:=100);
	port(	clk:in std_logic; --system clock clk->P20(EA2+p6)~FREQ_HQ0(24MHz)
		rst:in std_logic; --system reset, low level effective rst->U15(SW1)
		oe:out std_logic; --LCD power port oe->A4(LCD_ES)
		rs:out std_logic; --LCD_da input rs->A6(LCD_R_NS)
		rw:out std_logic; --LCD rw input rw->A5(LCD_R_NW)
		data:out std_logic_vector(7 downto 0); -- LCD data input
		clk1s:out std_logic);
	--data->(AB17,AB18,C3,E5,C7,E6,F7,A3)
end entity;
architecture bhv of charlcd is
	type state is
		(clear_lcd,entry_set,display_set,function_set,position_set1,write_data1,position_set2,write_data2,stop);
	signal current_state:state:=clear_lcd; --current running state
	type ram is array(0 to 23) of std_logic_vector(7 downto 0);
	signal dataram:ram:=(
	"00110000",
	"00110000",
	"00111010",
	"00110000",
	"00110000",
	"00111010",
	"00110000",
	"00110000",
--	x"77",	x"77",	x"77",	x"2E",	x"42",	x"55",	x"41",	x"41",	x"2E",	x"65",	x"64",	x"75",	x"2E",	x"63",	x"6E",	x"80");
--	w	w	w	.	B	U	A	A	.	e	d	u	.	c	n	\x80
	x"B7",	x"D0",	x"20",	x"C9",	x"20",	x"C5",	x"CF",	x"B4",	x"20",	x"CA",	x"2E",	x"20",	x"31",	x"32",	x"30",	x"32");
--	ki	mi	\x20	no	\x20	na	ma	e	\x20	ha	.	\x20	1	2	0	2
	signal clk_250KHz, clk_1Hz:std_logic:='0';
	signal cnt1,cnt2:integer range 0 to 200000:=0;
	signal hour_h_tmp,hour_l_tmp,min_h_tmp,min_l_tmp,sec_h_tmp,sec_l_tmp:std_logic_vector(3 downto 0):="0000";
	
	function "+"(L: STD_LOGIC_VECTOR; R: STD_LOGIC) return STD_LOGIC_VECTOR is
		-- pragma label_applies_to_plus
		variable result:UNSIGNED(L'range);
	begin
		case R is
			when '1'=>result:=UNSIGNED(L)+1;
			when others=>result:=UNSIGNED(L);
		end case;
		return std_logic_vector(result);
	end function;

begin
	lcd_clk:process(clk,rst) -- LCD data exchange rate
		variable c1:integer range 0 to 100:=0;
		variable c2:integer range 0 to 50000000:=0;
		variable clk0,clk1:std_logic:='0';
	begin
		if rst='0' then c1:=0;c2:=0;
		elsif clk'event and clk='1' then
			if c1=N/2-1 then --250KHz rate divide
				c1:=0;clk0:=not clk0;
			else c1:=c1+1;
			end if;
			if c2=freq/2 -1 then --1Hz clock divide used for counting
				c2:=0;clk1:=not clk1;
			else c2:=c2+1;
			end if;
		end if;
		clk_250KHz<=clk0;clk_1Hz<=clk1;
	end process lcd_clk;
	write:process(clk_250KHz,rst)
	begin
		if rst='0' then
			dataram(0)<="00110000";
			dataram(1)<="00110000";
			dataram(3)<="00110000";
			dataram(4)<="00110000";
			dataram(6)<="00110000";
			dataram(7)<="00110000";
		elsif clk_250KHz'event and clk_250KHz='1' then --save clk count to dataram for timing
			dataram(0)<="0011"&hour_h_tmp;
			dataram(1)<="0011"&hour_l_tmp;
			dataram(3)<="0011"&min_h_tmp;
			dataram(4)<="0011"&min_l_tmp;
			dataram(6)<="0011"&sec_h_tmp;
			dataram(7)<="0011"&sec_l_tmp;
		end if;
	end process write;
	control:process(rst,clk_250KHz) --LCD powering part
--		variable cnt3:std_logic_vector(3 downto 0);
	begin
		if rst='0' then
			current_state<=clear_lcd;
			cnt1<=0;cnt2<=0; --cnt3<=(others=>'0');
		elsif rising_edge(clk_250KHz) then
			case current_state is
				when clear_lcd=> -- clear LCD, delay for AT LEAST 1.64ms
--					oe<='1';
					rs<='0';rw<='0';
					data<=x"01"; -- mode:clean
					cnt1<=cnt1+1;
					if cnt1>delay*1 and cnt1<=delay*6 then
						oe<='0';
					else
						oe<='1';
					end if;
					if cnt1=delay*7 then
--					if cnt1>=delay*7 then
						current_state<=entry_set;
						cnt1<=0;
					end if;
				when entry_set=> --ptr moves right after writing, holding screen
--					oe<='1';
					rs<='0';rw<='0';
					data<=x"06"; --ptr moves right after writing, holding screen
					cnt1<=cnt1+1;
					if cnt1>delay and cnt1<=delay*2 then --delay operation
						oe<='0';
					else oe<='1';
					end if;
					if cnt1=delay*3 then
--					if cnt1>=delay*3 then
						current_state<=display_set;
						cnt1<=0;
					end if;
				when display_set=> --switch display mode
--					oe<='1';
					rs<='0';rw<='0';
					data<=x"0C";
					cnt1<=cnt1+1;
					if cnt1>delay and cnt1<=delay*2 then
						oe<='0';
					else oe<='1';
					end if;
					if cnt1=delay*3 then
--					if cnt1>=delay*3 then
						current_state<=function_set;
						cnt1<=0;
					end if;
				when function_set=>
--					oe<='1';
					rs<='0';rw<='0';
					data<=x"38"; --8 bit parallel, 2*16, 5*7pnt
					cnt1<=cnt1+1;
					if cnt1>delay and cnt1<=delay*2 then
						oe<='0';
					else oe<='1';
					end if;
					if cnt1=delay*3 then
--					if cnt1>=delay*3 then
						current_state<=position_set1;
						cnt1<=0;
					end if;
				when position_set1=> --set position for line1
--					oe<='1';
					rs<='0';rw<='0';
					data<=x"84"; --
					cnt1<=cnt1+1;
					if cnt1>delay and cnt1<=delay*2 then
						oe<='0';
					else oe<='1';
					end if;
					if cnt1=delay*3 then
--					if cnt1>=delay*3 then
						current_state<=write_data1;
						cnt1<=0;
					end if;
				when write_data1=> -- write data to line1
					oe<='1';
					rs<='1';rw<='0';
					if cnt2<=7 then
						data<=dataram(cnt2);
						cnt1<=cnt1+1;
						if cnt1>delay and cnt1<=delay*2 then
							oe<='0';
						else oe<='1';
						end if;
						if cnt1=delay*3 then
--						if cnt1>=delay*3 then
							current_state<=write_data1;
							cnt1<=0;
							cnt2<=cnt2+1;
						end if;
					else
						cnt2<=0;
						current_state<=position_set2;
					end if;
				when position_set2=> --set position for line2
--					oe<='1';
					rs<='0';rw<='0';
					data<=x"c0"; --
					cnt1<=cnt1+1;
					if cnt1>delay and cnt1<=delay*2 then
						oe<='0';
					else oe<='1';
					end if;
					if cnt1=delay*3 then
--					if cnt1>=delay*3 then
						current_state<=write_data2;
						cnt1<=0;
					end if;
				when write_data2=> -- write data to line2
					oe<='1';	
					rs<='1';rw<='0';
					if cnt2<=15 then
						data<=dataram(cnt2+8);
						cnt1<=cnt1+1;
						if cnt1>delay and cnt1<=delay*2 then
							oe<='0';
						else oe<='1';
						end if;
						if cnt1=delay*3 then
--						if cnt1>=delay*3 then
							current_state<=write_data2;
							cnt1<=0;
							cnt2<=cnt2+1;
						end if;
					else
						cnt2<=0;
						current_state<=position_set1;
					end if;
				when stop=>oe<='1';
				when others=>null;
			end case;
		end if;
	end process;
	clock:process(clk_1Hz,rst) --parse running time
	begin
		if rst='0' then
			hour_h_tmp<="0000";
			hour_l_tmp<="0000";
			min_h_tmp<="0000";
			min_l_tmp<="0000";
			sec_h_tmp<="0000";
			sec_l_tmp<="0000";
		elsif clk_1Hz'event and clk_1Hz='1' then
			if sec_l_tmp="1001" then -- time carry
				sec_l_tmp<="0000";
				if sec_h_tmp="0101" then
					sec_h_tmp<="0000";
					if min_l_tmp="1001" then
						min_l_tmp<="0000";
						if min_h_tmp="0101" then
							min_h_tmp<="0000";
							if hour_h_tmp="0010" then
								if hour_l_tmp="0011" then
									hour_l_tmp<="0000";
									hour_h_tmp<="0000";
								else	hour_l_tmp<=hour_l_tmp+'1';
								end if;
							else
								if hour_l_tmp="1001" then
									hour_l_tmp<="0000";
									hour_h_tmp<=hour_h_tmp+'1';
								else	hour_l_tmp<=hour_l_tmp+'1';
								end if;
							end if;
						else	min_h_tmp<=min_h_tmp+'1';
						end if;
					else	min_l_tmp<=min_l_tmp+'1';
					end if;
				else	sec_h_tmp<=sec_h_tmp+'1';
				end if;
			else	sec_l_tmp<=sec_l_tmp+'1';
			end if;
		end if;
	end process;
	clk1s<=clk_1Hz;
end architecture bhv;
