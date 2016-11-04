library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_unsigned.all;

entity tb_freqled is
end entity;

architecture testbench of tb_freqled is
	component freqled is
	port(
		clk,start,rst:in std_logic;
		--out0,out1,out2,out3,out4,out5,out6,out7:out std_logic_vector(3 downto 0);
		--led0,led1,led2,led3,led4,led5,led6,led7:out std_logic_vector(7 downto 0);
		clkled:in std_logic;
		ledout,ledds:out std_logic_vector(7 downto 0);
		clksgn_out:out std_logic);
	end component;
	signal clk_in,start_in,rst_in,clkled_in,clksgn_out:std_logic:='Z';
	signal ledout_out,ledds_out:std_logic_vector(7 downto 0);
	--signal out0,out1,out2,out3,out4,out5,out6,out7:std_logic_vector(3 downto 0);
        --signal led0,led1,led2,led3,led4,led5,led6,led7:std_logic_vector(7 downto 0);
begin
	fc:freqled port map(clk_in,start_in,rst_in,
				--out0,out1,out2,out3,out4,out5,out6,out7,
				--led0,led1,led2,led3,led4,led5,led6,led7,
				clkled_in,
				ledout_out,ledds_out,
				clksgn_out);
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
	process begin
		clkled_in <='0';
		wait for 5 us;
		clkled_in <='1';
		wait for 5 us;
	end process;
end architecture;

configuration CFG_TB of freqled_jk is
	for testbench
	end for;
end configuration;

