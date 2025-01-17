library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
entity SubUnit is
	generic(numBits  : positive := 8);
		port(operand0 : in  std_logic_vector((numBits-1) downto 0);
			  operand1 : in  std_logic_vector((numBits-1) downto 0);
			  ovf      : out std_logic_vector(0 downto 0);
			  result   : out std_logic_vector((numBits-1) downto 0));
end SubUnit;

architecture Behavioral of SubUnit is
	signal op0, op1, res: signed((numBits-1) downto 0);

begin 
	--realização da operação
	op0 <= signed(operand0);
	op1 <= signed(operand1);
	res <= op0 - op1;
	
	--verificação do overflow
	process(op0, op1, res)
	begin
		if(not(op1(numBits-1) = op0(numBits-1)))then
			if(res(numBits-1) = op1(numBits-1))then
				ovf(0) <= '1';
			else
				ovf(0) <= '0';
			end if;
		else
			ovf(0) <= '0';
		end if;		
	end process;
	result <= std_logic_vector(res);
end Behavioral;