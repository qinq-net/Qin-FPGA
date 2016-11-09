------------------------------------------------------------------------------------------
-- freqcnt.vhd -- Frequency Meter with 8BCD output
-- Copyright (C) 2016 Beihang University, School of Physics and Nuclear Energy Engineering
-- Author: QIN Yuhao <qinq_net@buaa.edu.cn>
-- Note:Should include oc2.vhd bcdcount.vhd
--	Used as component, no binding available
------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freqcnt is
port(
	clk,clk1s,start,rst:in std_logic; --clk rising edge, rst low level effective
	out0,out1,out2,out3,out4,out5,out6,out7:out std_logic_vector(3 downto 0); --bcd
	outy:out std_logic; --for expansion
	clksgn_out:out std_logic); --output counted clk
end entity;

architecture freqcnt of freqcnt is
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
	signal clkallow,clkcnt:std_logic:='0';
	signal c0,c1,c2,c3,c4,c5,c6,c7:std_logic_vector(3 downto 0):="0000";
	signal rstbcd:std_logic_vector(1 downto 0):="00";
begin
	clksgn_out<=clksgn;
	clkoc2:oc2 port map(a=>clk,b=>clkcnt,c=>clkcnt,y=>clksgn); --control clk
	rstbcd(0)<=not rst; --bcdcount has opposed rst
	rstbcd(1)<=not rst;
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
	outy<=not c7(3); --outy should rise when back to 0
	process(start,clkcnt,rst) begin
		if rst='0' then clkallow<='0';
		elsif clkcnt='1' then
			clkallow<='0';
		elsif start'event and start='1' and clkallow/='1' then
			clkallow<='1';
		end if;
	end process;
	process(clk1s,rst) begin
		if rst='0' then clkcnt<='0';
		elsif clk1s'event and clk1s='1' then
			case clkcnt is
				when '0'=>if clkallow='1' then clkcnt<='1';end if;
				when '1'=>clkcnt<='0';
			end case;
		end if;
	end process;
--	process begin
--		wait until(start'event and start='1');
--		clkallow<='1';
--		wait for 1 sec;
--		clkallow<='0';
--	end process;
--	process(clkallow,clk) begin
--		case clkallow is
--			when '1'=>clksgn<=clk;
--			when others=>clksgn<='Z';
--		end case;
--	end process;
end architecture;

