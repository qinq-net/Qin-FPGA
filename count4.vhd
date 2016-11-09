------------------------------------------------------------------------------------------
-- count4.vhd -- 4-bit binary counter
-- Copyright (C) 2016 Beihang University, School of Physics and Nuclear Energy Engineering
-- Author: QIN Yuhao <qinq_net@buaa.edu.cn>
------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity count4 is
	port(
		clk: in std_logic; --pin_P20 FPGA_EA2_p6	--in bit 
		rst: in std_logic; --pin_N18 SW-1	--reset sign, high level effective
		q: out std_logic_vector( 3 downto 0 ); 
		notq: out std_logic_vector( 3 downto 0 ));
	--	nq3->U12LED1 nq2->V12LED2 nq1->V15LED3 nq0->W13LED4
end entity count4;
architecture bhv of count4 is
	signal q1:std_logic_vector( 3 downto 0 ):="0000";
	begin
		process(rst,clk)	--wait for sensitive signal
			begin
			if (rst='1') then q1<="0000";
			elsif(clk'event and clk='1') then	--wait for rising_edge(clk)
				--q1<=q1+1;
				q1<=std_logic_vector(unsigned(q1)+1);
			end if;
		end process;
		q <= q1;
		notq <= not q1;
end architecture bhv;
