library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_unsigned.all;

entity tb_freqcnt is
end entity;

architecture testbench of tb_freqcnt is
	component freqcnt is
	port(
		clk,start,rst:in std_logic;
		out0,out1,out2,out3,out4,out5,out6,out7:out std_logic_vector(3 downto 0);
		led0,led1,led2,led3,led4,led5,led6,led7:out std_logic_vector(7 downto 0);
		outy:out std_logic;
		clksgn_out:out std_logic);
	end component;
	signal clk_in,start_in,rst_in,outy_out,clksgn_out:std_logic:='Z';
	signal out0,out1,out2,out3,out4,out5,out6,out7:std_logic_vector(3 downto 0);
        signal led0,led1,led2,led3,led4,led5,led6,led7:std_logic_vector(7 downto 0);
begin
	fc:freqcnt port map(clk_in,start_in,rst_in,
				out0,out1,out2,out3,out4,out5,out6,out7,
				led0,led1,led2,led3,led4,led5,led6,led7,
				outy_out,clksgn_out);
	process begin
		clk_in <= '0';
		wait for 10 us;
		clk_in <= '1';
		wait for 10 us;
	end process;
	process begin
		wait for 50 us;
		rst_in <= '0'; start_in <= '0';
		wait for 50 us;
		rst_in <= '1';
		wait for 50 us;
		start_in <= '1';
		wait for 50 us;
		start_in <= '0';
		wait for 1.5 sec;
	end process;
end architecture;

configuration CFG_TB of freqcnt_jk is
	for testbench
	end for;
end configuration;

