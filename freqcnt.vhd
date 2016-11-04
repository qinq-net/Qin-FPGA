--should include bcdcount.vhd oc2.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freqcnt is
port(
	clk,start,rst:in std_logic;
	out0,out1,out2,out3,out4,out5,out6,out7:out std_logic_vector(3 downto 0);
	--led0,led1,led2,led3,led4,led5,led6,led7:out std_logic_vector(7 downto 0);
	outy:out std_logic;
	clksgn_out:out std_logic);
end entity;

architecture freqcnt of freqcnt is
--	component ledtrans is
--	port(	ins:in std_logic_vector(3 downto 0);
--		rst:in std_logic;
--		sel:out std_logic;
--		d:out std_logic_vector(7 downto 0));
--	end component;
	component bcdcount is
	port(
		ina,inb:in std_logic;
		qa,qb,qc,qd:out std_logic;
		r0,r9:in std_logic_vector(1 downto 0));
	end component;
	component oc2 is
	port(a,b,c:in std_logic;
		y:out std_logic);
	end component;
	signal clksgn:std_logic:='Z';
	signal clkallow:std_logic:='0';
	signal c0,c1,c2,c3,c4,c5,c6,c7:std_logic_vector(3 downto 0):="0000";
	--signal l0,l1,l2,l3,l4,l5,l6,l7:std_logic_vector(7 downto 0):="ZZZZZZZZ";
	signal rstbcd:std_logic_vector(1 downto 0):="00";
begin
	clksgn_out<=clksgn;
	clkoc2:oc2 port map(a=>clk,b=>clkallow,c=>clkallow,y=>clksgn);
	rstbcd(0)<=not rst;
	rstbcd(1)<=not rst;
--	lt0:ledtrans port map(c0,rst,open,l0);
--	lt1:ledtrans port map(c1,rst,open,l1);
--	lt2:ledtrans port map(c2,rst,open,l2);
--	lt3:ledtrans port map(c3,rst,open,l3);
--	lt4:ledtrans port map(c4,rst,open,l4);
--	lt5:ledtrans port map(c5,rst,open,l5);
--	lt6:ledtrans port map(c6,rst,open,l6);
--	lt7:ledtrans port map(c7,rst,open,l7);
	bc0:bcdcount port map(clksgn,c0(0),c0(0),c0(1),c0(2),c0(3),rstbcd,"00");
	bc1:bcdcount port map(c0(3),c1(0),c1(0),c1(1),c1(2),c1(3),rstbcd,"00");
	bc2:bcdcount port map(c1(3),c2(0),c2(0),c2(1),c2(2),c2(3),rstbcd,"00");
	bc3:bcdcount port map(c2(3),c3(0),c3(0),c3(1),c3(2),c3(3),rstbcd,"00");
	bc4:bcdcount port map(c3(3),c4(0),c4(0),c4(1),c4(2),c4(3),rstbcd,"00");
	bc5:bcdcount port map(c4(3),c5(0),c5(0),c5(1),c5(2),c5(3),rstbcd,"00");
	bc6:bcdcount port map(c5(3),c6(0),c6(0),c6(1),c6(2),c6(3),rstbcd,"00");
	bc7:bcdcount port map(c6(3),c7(0),c7(0),c7(1),c7(2),c7(3),rstbcd,"00");
	out0<=c0;out1<=c1;out2<=c2;out3<=c3;
	out4<=c4;out5<=c5;out6<=c6;out7<=c7;
--	led0<=l0;led1<=l1;led2<=l2;led3<=l3;
--	led4<=l4;led5<=l5;led6<=l6;led7<=l7;
	outy<=c7(3);
	process begin
		wait until(start'event and start='1');
		clkallow<='1';
		wait for 1 sec;
		clkallow<='0';
	end process;
--	process(clkallow,clk) begin
--		case clkallow is
--			when '1'=>clksgn<=clk;
--			when others=>clksgn<='Z';
--		end case;
--	end process;
end architecture;

