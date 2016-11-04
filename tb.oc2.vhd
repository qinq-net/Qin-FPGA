library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_oc2 is
	end entity;

architecture tb of tb_oc2 is
	component oc2 is
		port(a,b,c:in std_logic;
		y:out std_logic);
	end component;
	signal ins:std_logic_vector(3 downto 0):=(others=>'0');
	signal u_y:std_logic;
begin
	u_oc2: oc2 port map(
		a=>ins(0),
		b=>ins(1),
		c=>ins(2),
		y=>u_y);
	process begin
		ins<=std_logic_vector(unsigned(ins)+1);
		wait for 10 ns;
	end process;
end architecture;

configuration CFG_TB of tb_oc2 is
	for tb
		end for;
end configuration;
