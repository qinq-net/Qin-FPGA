------------------------------------------------------------------------------------------
-- freqled.vhd -- Frequency Meter with LED output support
-- Copyright (C) 2016 Beihang University, School of Physics and Nuclear Energy Engineering
-- Author: QIN Yuhao <qinq_net@buaa.edu.cn>
-- Note:Should include oc2.vhd ledtrans.vhd freqcnt.vhd bcdcount.vhd count4.vhd trans3.vhd
------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freqled is
port(
	clk,start,rst:in std_logic; --rst low level effective, start rising edge effective
--	clk->N19(EA2_p5)~target start->AB15(F1,CON1.10) rst->AA15(SW4)
	clk1s:in std_logic; --clk1s->R17(EA2_p4)
	clkled:in std_logic;
--	clkled->P20(EA2_p6)~FRQ_Q9(4096Hz)
	ledout,ledds:out std_logic_vector(7 downto 0);
--	ledds	7->AB20(DS1) 6->Y21(DS2) 5->Y22(DS3) 4->W22(DS4) 
--		3->V22(DS5) 2->U22(DS6) 1->AA17(DS7) 0->V16(DS8)
--	ledout	7->AA20(LA) 6->W20(LB) 5->R21(LC) 4->P21(LD) 
--		3->N21(LE) 2->N20(LF) 1->M21(LG) 0->M19(LH)
	clksgn_out:out std_logic);
end entity;

architecture freqled of freqled is
	component freqcnt is
	port(
		clk,start,rst:in std_logic;
		clk1s:in std_logic;
		out0,out1,out2,out3,out4,out5,out6,out7:out std_logic_vector(3 downto 0);
		outy:out std_logic;
		clksgn_out:out std_logic);
	end component;
	component ledtrans is
	port(	ins:in std_logic_vector(3 downto 0);
		rst,pnt:in std_logic;
		sel:out std_logic;
		d:out std_logic_vector(7 downto 0));
	end component;
	component count4 is
	port(
		clk: in std_logic;	--in bit
		rst: in std_logic;	--reset sign, high level effective
		q: out std_logic_vector( 3 downto 0 );
		notq: out std_logic_vector( 3 downto 0 ));
	end component;
	component trans3 is
	port(
		ins:in std_logic_vector(2 downto 0);
		notpwr:in std_logic; --low level effective
		outs:out std_logic_vector(7 downto 0));
	end component;
	type cnts_t is array(7 downto 0) of std_logic_vector(3 downto 0);
	signal cnts:cnts_t;
	signal ledout_sgn,ledds_sgn:std_logic_vector(7 downto 0):=(others=>'1');
	signal ins_sgn,ct4_sgn:std_logic_vector(3 downto 0):=(others=>'0');
	signal ledptr:integer:=0;
	signal notrst:std_logic;
begin
	notrst<=not rst;
	fc:freqcnt port map(clk,start,rst,clk1s,
		cnts(0),cnts(1),cnts(2),cnts(3),cnts(4),cnts(5),cnts(6),cnts(7),
		open, --outy,
		clksgn_out);
	lt:ledtrans port map(ins=>ins_sgn,rst=>'1',pnt=>'0',sel=>open,d=>ledout_sgn);
--	process(clkled) begin
--		if(clkled'event and clkled='1') then
--			if(0<=ledptr<7) then ledptr:=ledptr+1;
--			else ledptr:=0;
--			end if;
--			ledds_sgn<=(others=>'1');
--			ledds_sgn(ledptr)<='0';
--			ins_sgn<=cnts(ledptr);
--		end if;
--	end process;
	ct4:count4 port map(clk=>clkled,rst=>'0',q=>ct4_sgn,notq=>open);
	ledptr<=(to_integer(unsigned(ct4_sgn)) mod 8);
	ins_sgn<=cnts(ledptr);
	tr3:trans3 port map(ins=>ct4_sgn(2 downto 0),notpwr=>'0',outs=>ledds_sgn);
	ledds<=ledds_sgn;ledout<=ledout_sgn;
end architecture;
