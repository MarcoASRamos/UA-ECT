library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Bin2BCDDecoder is
	port(inMult  : in  std_logic;
		  inBin	 : in  std_logic_vector(15 downto 0);
		  outBCD0 : out std_logic_vector(3 downto 0);
		  outBCD1 : out std_logic_vector(3 downto 0);
		  outBCD2 : out std_logic_vector(3 downto 0);
		  outBCD3 : out std_logic_vector(3 downto 0);
		  outBCD4 : out std_logic_vector(3 downto 0);
		  signBCD : out std_logic_vector(3 downto 0));
end Bin2BCDDecoder;

architecture Behavioral of Bin2BCDDecoder is
	signal num0,num00, num1, num11, num2, num22, num3, num33, num4:	natural;
	signal s_inBin  : std_logic_vector(15 downto 0);
begin
	
	proc_verivy : process(inBin, inMult)
	begin
		if(inMult = '1')then
			if(inBin(15) = '1')then
				s_inBin <= std_logic_vector((unsigned(inBin) xor "1111111111111111") + 1);
			else
				s_inBin <= inBin;
			end if;
		else
			if(inBin(7) = '1')then
				s_inBin(7 downto 0) <= std_logic_vector((unsigned(inBin(7 downto 0) xor "11111111") + 1));
				s_inBin(15 downto 8) <= (others => '0');
			else
				s_inBin <= inBin;
			end if;
		end if;
			
			
	end process;
	
	
	num0 <= to_integer(unsigned(s_inBin));  
	
	
	
	proc_sign : process(inBin, inMult)
	begin
		if(inMult = '1')then
			if(inBin(15) = '1')then
				signBCD <= "1111";   --caso seja negativo
			else
				signBCD <= "1110";   --caso seja positivo
			end if;
		else
			if(inBin(7) = '1')then
				signBCD <= "1111";   --caso seja negativo
			else
				signBCD <= "1110";   --caso seja positivo
			end if;
		end if;
	end process;
	
		
	outBCD4 <=	"0000" when num0<10000 else 
					"0001" when num0<20000 else  
					"0010" when num0<30000 else  
					"0011" when num0<40000 else
					"0100" when num0<50000 else
					"0101" when num0<60000 else
					"0110" when num0<70000 else
					"0111" when num0<80000 else
					"1000" when num0<90000 else
					"1001";
					
	num00		<=	0     when num0<10000 else       
					10000 when num0<20000 else      
					20000 when num0<30000 else
					30000 when num0<40000 else
					40000 when num0<50000 else
					50000 when num0<60000 else
					60000 when num0<70000 else
					70000 when num0<80000 else
					80000 when num0<90000 else
					90000;
	num1 <= num0-num00;  

	
	
	
	outBCD3 <=	"0000" when num1<1000 else   
					"0001" when num1<2000 else
					"0010" when num1<3000 else
					"0011" when num1<4000 else
					"0100" when num1<5000 else
					"0101" when num1<6000 else
					"0110" when num1<7000 else
					"0111" when num1<8000 else
					"1000" when num1<9000 else
					"1001";
	num11		<=	0    when num1<1000 else       
					1000 when num1<2000 else      
					2000 when num1<3000 else
					3000 when num1<4000 else
					4000 when num1<5000 else
					5000 when num1<6000 else
					6000 when num1<7000 else
					7000 when num1<8000 else
					8000 when num1<9000 else
					9000;
	num2 <= num1-num11;
	
	
	
	outBCD2 <=  "0000" when num2<100 else   
					"0001" when num2<200 else
					"0010" when num2<300 else
					"0011" when num2<400 else
					"0100" when num2<500 else
					"0101" when num2<600 else
					"0110" when num2<700 else
					"0111" when num2<800 else
					"1000" when num2<900 else
					"1001";
	num22		<=	0    when num2<100 else       
					100 when num2<200 else      
					200 when num2<300 else
					300 when num2<400 else
					400 when num2<500 else
					500 when num2<600 else
					600 when num2<700 else
					700 when num2<800 else
					800 when num2<900 else
					900;
	num3 <= num2-num22;

	
	
	
	outBCD1 <=  "0000" when num3<10 else   
					"0001" when num3<20 else
					"0010" when num3<30 else
					"0011" when num3<40 else
					"0100" when num3<50 else
					"0101" when num3<60 else
					"0110" when num3<70 else
					"0111" when num3<80 else
					"1000" when num3<90 else
					"1001";
	num33		<=	0  when num3<10 else       
					10 when num3<20 else      
					20 when num3<30 else
					30 when num3<40 else
					40 when num3<50 else
					50 when num3<60 else
					60 when num3<70 else
					70 when num3<80 else
					80 when num3<90 else
					90;
	num4 <= num3-num33;
	
	
	
	outBCD0 <=  "0000" when num4=0 else   
					"0001" when num4=1 else
					"0010" when num4=2 else
					"0011" when num4=3 else
					"0100" when num4=4 else
					"0101" when num4=5 else
					"0110" when num4=6 else
					"0111" when num4=7 else
					"1000" when num4=8 else
					"1001";
	
	

end Behavioral;