------------------------------------------------------------------------------------------
-- fpga3.vhd -- oc2+ledtrans+jk 
-- Copyright (C) 2016 Beihang University, School of Physics and Nuclear Energy Engineering
-- Author: QIN Yuhao <qinq_net@buaa.edu.cn>
-- Note:CPRL_SW=00XX(MODE1)
--	Should include oc2.vhd, ledtrans.vhd, jk.vhd
------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity fpga3 is
	port(oca,ocb,occ:in std_logic; --oca->N18(SW1) ocb->M20(SW2) occ->AA15(SW3)
	ocy:out std_logic; --ocy->U12(LED1,CON1.2)
	ledins:in std_logic_vector(3 downto 0);
--	ledins	3->AB17(SW9) 2->AB18(SW10) 1->C3(SW11) 0->E5(SW12)
	ledcon,ledout:out std_logic_vector(7 downto 0);
--	ledcon	7->AB20(DS1) 6->Y21(DS2) 5->Y22(DS3) 4->W22(DS4)
--		3->V22(DS5) 2->U22(DS6) 1->AA17(DS7) 0->V16(DS8)
--	ledout	7->AA20(LA) 6->W20(LB) 5->R21(LC) 4->P21(LD)
--		3->N21(LE) 2->N20(LF) 1->M21(LG) 0->M19(LH)
	j,k,jkclk,jksd,jkrd:in std_logic;
--	j->V13(SW4) k->D6(SW5) jkclk->AB15(F1,CON1.10) jksd->C8(SW6) jkrd->E7(SW7)
	jkq,jknq:out std_logic); -- jkq->V15(LED3) jknq->W13(LED4)
end entity;
architecture fpga3 of fpga3 is
	component oc2 is
	port(a,b,c:in std_logic;
		y:out std_logic);
	end component;
	component ledtrans is
	port(	ins:in std_logic_vector(3 downto 0);
		rst,pnt:in std_logic;
		sel:out std_logic;
		d:out std_logic_vector(7 downto 0));
	end component;
	component jk is
        port(
        j,k,clk:in std_logic;
        qq,nq:out std_logic;
        sd,rd:in std_logic);
	end component;
begin
	u_oc2:oc2 port map(a=>oca,b=>ocb,c=>occ,y=>ocy);
	u_ledtrans:ledtrans port map(ins=>ledins,rst=>'1',pnt=>'0',sel=>open,d=>ledout);
	ledcon<="11111110";
	u_jk:jk port map(j=>j,k=>k,clk=>jkclk,qq=>jkq,nq=>jknq,sd=>jksd,rd=>jkrd);
end architecture;

