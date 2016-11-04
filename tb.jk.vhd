library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_unsigned.all;

entity tb_jk is
end entity;

architecture testbench of tb_jk is
	component jk is
        	port(
        	j,k,clk:in std_logic;
        	qq,nq:out std_logic;
        	sd,rd:in std_logic);
	end component;
	signal clk_in,j_in,k_in,qq_out,nq_out,sd_in,rd_in:std_logic;
	signal ins:std_logic_vector(6 downto 0):=(others=>'0');
begin
	u_jk: jk port map (
				  j=>ins(1),
				  k=>ins(2),
				  clk=>ins(0),
				  qq=>qq_out,nq=>nq_out,
				  sd=>ins(5),
				  rd=>ins(6));
	j_in<=ins(1);k_in<=ins(2);clk_in<=ins(0);sd_in<=ins(5);rd_in<=ins(6);
	process begin
--		clk_in <= '0';
--		wait for 10 ns;
--		clk_in <= '1';
--		wait for 10 ns;
		ins<=std_logic_vector(unsigned(ins)+1);
		wait for 10 ns;
	end process;
end architecture;

configuration CFG_TB of tb_jk is
	for testbench
	end for;
end configuration;

