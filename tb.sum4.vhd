library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sum4 is
end entity;

architecture tb of tb_sum4 is
	component sum4 is
        	port(
        	INA,INB:in std_logic_vector(3 downto 0);
        	OUTS:out std_logic_vector(3 downto 0);
        	INC:in std_logic;
        	OUTY:out std_logic);
	end component;
	signal INA,INB,OUTS:std_logic_vector(3 downto 0):=(others=>'0');
	signal INC,OUTY:std_logic:='0';
begin
	u_sum4: sum4 port map(
		INA=>INA,
		INB=>INB,
		INC=>INC,
		OUTS=>OUTS,
		OUTY=>OUTY);
	process begin
		INA<=std_logic_vector(unsigned(INA)+1);
		wait for 10 ns;
	end process;
	process(INA(3)) begin
		if(INA(3)'event and INA(3)='0') then
			INB<=std_logic_vector(unsigned(INB)+1);
		end if;
	end process;
	process(INB(3)) begin
		if(INB(3)'event and INB(3)='0') then
			INC<=not INC;
		end if;
	end process;
end architecture;

configuration CFG_TB of tb_sum4 is
	for tb
		end for;
end configuration;
