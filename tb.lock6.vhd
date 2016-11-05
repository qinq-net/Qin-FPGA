library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_unsigned.all;

entity tb_lock6 is
end entity;

architecture testbench of tb_lock6 is
	component lock6 is
        	port(
		clk,rst,set:in std_logic;
		pwd:in std_logic;
		ulk,ast:out std_logic);
	end component;
	signal clk_i,rst_i,set_i,pwd_io,ulk_o,ast_o:std_logic:='0';
begin
	u_lock6: lock6 port map (
				  clk=>clk_i,
				  rst=>rst_i,
				  set=>set_i,
				  pwd=>pwd_io,
				  ulk=>ulk_o,
				  ast=>ast_o);
process begin
	set_i<='1';
	pwd_io<='1';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='1';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='1';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	set_i<='0'; wait for 10 ns;
	pwd_io<='1';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='1';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='1';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	wait for 20 ns;
	rst_i<='1'; wait for 10 ns; rst_i<='0';
	set_i<='1'; wait for 10 ns;
	pwd_io<='1';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	set_i<='0'; wait for 10 ns;
	pwd_io<='1';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='1';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	rst_i<='1'; wait for 10 ns; rst_i<='0';
	pwd_io<='1';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	pwd_io<='0';clk_i<='1';wait for 10 ns; clk_i<='0';wait for 10 ns;
	wait for 100 ns;
end process;


end architecture;

configuration CFG_TB of tb_lock6 is
	for testbench
	end for;
end configuration;

