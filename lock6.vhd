library ieee;
use ieee.std_logic_1164.all;

entity lock6 is
	port(
		clk,rst,set:in std_logic;
--		clk->AB19(F3,CON1.12) rst->W19(F4,CON1.13) set->N18(SW2)
		pwd:in std_logic;
--		pwd->U15(SW1)
		ulk,ast:out std_logic);
--		ulk->U12(LED1) ast->V12(LED2)
end entity;

architecture bhv of lock6 is
	signal pwdtable:std_logic_vector(5 downto 0):=(others=>'0');
	signal ptr:integer:=0; -- range 0 to 5 :=0;
	signal ulk_sgn,ast_sgn:std_logic:='0';
	function to_std_logic(L:bit) return std_logic is
	begin
		case L is
			when '1'=>return '1';
			when '0'=>return '0';
		end case;
	end function;
	function to_std_logic(L:boolean) return std_ulogic is
	begin
		if L then return '1';
		else return '0';
		end if;
	end function;
begin
process(clk,rst,set) begin
	if(clk'event and clk='1' and rst='0' and ast_sgn='0' and ulk_sgn='0') then
		case set is
			when '1'=>pwdtable(ptr)<=pwd;
			when others=>ast_sgn<=pwdtable(ptr) xor pwd;
		end case;
		ulk_sgn<=to_std_logic(ptr=5 and ast_sgn='0' and set/='1');
		ptr<=(ptr+1)mod 6;
	elsif(rst='1' or set'event) then
		ptr<=0;
		ast_sgn<='0';
		ulk_sgn<='0';
	end if;
end process;
	ulk<=ulk_sgn;ast<=ast_sgn;
end architecture;
