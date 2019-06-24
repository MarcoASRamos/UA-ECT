library IEEE;
use IEEE.STD_LOGIC_1164.all;

--declaração da entidade
entity IterDivCore_Tb is
end IterDivCore_Tb;

architecture Stimulus of IterDivCore_Tb is
	
	--sinais de entrada
	signal s_clk : std_logic;
	signal s_reset : std_logic;
	signal s_start : std_logic;
	signal s_operand0 : std_logic_vector(7 downto 0);
	signal s_operand1 : std_logic_vector(7 downto 0);
	--sinais de saída
	signal s_done : std_logic;
	signal s_result : std_logic_vector(7 downto 0);
	signal s_ovf : std_logic;
	
begin
	--instaciação da uut
	uut: entity work.IterDivCore(Shell)
		  port map(clk => s_clk,
					  reset => s_reset,
					  start => s_start,
					  operand0 => s_operand0,
					  operand1 => s_operand1,
					  done => s_done,
					  result => s_result,
					  ovf => s_ovf);
	--pocesso do clk			  
	clk_proc : process
	begin
		s_clk <= '0'; 
		wait for 10 ns;
		s_clk <= '1'; 
		wait for 10 ns;
	end process;
		
	stim_proc : process
	begin
		s_reset <= '0';
		s_start <= '0';
		s_operand0 <= "00000000";
		s_operand1 <= "00000000";
		wait for 25 ns;
		s_operand1 <= "00000001";
		s_operand0 <= "00001101";
		wait for 20 ns;
		s_start <= '1';
		wait for 20 ns;
		s_operand0 <= "00001110";
		s_operand1 <= "00000010";
		wait for 20 ns;
		s_operand1 <= "11111001";
		wait for 20 ns;
		s_operand0 <= "10000111";
		wait for 20 ns;
		s_operand1 <= "01110001";
		wait for 20 ns;
		s_reset <= '1';
		wait for 20 ns;
	end process;
end Stimulus;
		