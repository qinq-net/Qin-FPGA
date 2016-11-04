library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
	port(
		ea:in std_logic;
		ios:inout std_logic_vector(7 downto 0);
		addr:in std_logic_vector(10 downto 0));
end entity;

architecture ram of ram is
	type a2kb_array is array(2047 downto 0) of std_logic_vector(7 downto 0);
	signal data:a2kb_array:=(others=>(others=>'0'));
	signal n_addr:integer;
begin
	process(ea,ios,addr)
	begin
		case ea is
			when '0'=>ios<=data(n_addr);
			when '1'=>data(n_addr)<=ios;
			when others=>ios<=(others=>'Z');
		end case;
	end process;
	n_addr<=to_integer(unsigned(addr));
end architecture;
		
