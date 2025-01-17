library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Fase1 is
	generic(numBits : positive := 8);
		port(CLOCK_50 : in  std_logic; 
			  KEY      : in  std_logic_vector(3 downto 0);
			  SW       : in  std_logic_vector(17 downto 0);
			  LEDG     : out std_logic_vector(0 downto 0);
			  HEX0     : out std_logic_vector(6 downto 0);
		     HEX1     : out std_logic_vector(6 downto 0);
		     HEX2     : out std_logic_vector(6 downto 0);
			  HEX3     : out std_logic_vector(6 downto 0);
			  HEX4     : out std_logic_vector(6 downto 0);
			  HEX5     : out std_logic_vector(6 downto 0));
end Fase1;

architecture Shell of Fase1 is
	signal s_key0, s_key1, s_key2, s_key3                         : std_logic;
	signal s_multdone, s_divdone, s_divStart, s_multStart         : std_logic;
	signal s_multsel                                              : std_logic_vector(1 downto 0);
	signal s_enable0, s_enable1                                   : std_logic_vector(0 downto 0);
	signal s_result00, s_result01, s_result11                     : std_logic_vector(7 downto 0);
	signal s_result10                                             : std_logic_vector(15 downto 0);
	signal s_result                                               : std_logic_vector(15 downto 0);
	signal s_outbcd0, s_outbcd1, s_outbcd2, s_outbcd3, s_outbcd4, s_outsign  : std_logic_vector(3 downto 0);
	signal s_resultsum, s_resultsub                               : std_logic_vector(7 downto 0);
	signal s_sumovf, s_subovf                                     : std_logic_vector(0 downto 0);
	signal s_enable2, s_enable3                                   : std_logic;
	signal s_inMult                                               : std_logic;

begin
	
	--Debouncers
	debounce_unit0 : entity work.DebounceUnit(Behavioral)
								 generic map(kHzClkFreq     => 50000,
												 mSecMinInWidth => 100,
												 inPolarity     => '0',
												 outPolarity    => '1')
									port map(refClk    => CLOCK_50,
												dirtyIn   => KEY(0),
												pulsedOut => s_key0);
												
	debounce_unit1 : entity work.DebounceUnit(Behavioral)
								 generic map(kHzClkFreq     => 50000,
												 mSecMinInWidth => 100,
												 inPolarity     => '0',
												 outPolarity    => '1')
									port map(refClk    => CLOCK_50,
												dirtyIn   => KEY(1),
												pulsedOut => s_key1);
												
	debounce_unit2 : entity work.DebounceUnit(Behavioral)
								 generic map(kHzClkFreq     => 50000,
												 mSecMinInWidth => 100,
												 inPolarity     => '0',
												 outPolarity    => '1')
									port map(refClk    => CLOCK_50,
												dirtyIn   => KEY(2),
												pulsedOut => s_key2);
												
	debounce_unit3 : entity work.DebounceUnit(Behavioral)
								 generic map(kHzClkFreq     => 50000,
												 mSecMinInWidth => 100,
												 inPolarity     => '0',
												 outPolarity    => '1')
									port map(refClk    => CLOCK_50,
												dirtyIn   => KEY(3),
												pulsedOut => s_key3);
	
	--MainCtrlUnit
	mainctrlunit_core: entity work.MainCtrlUnit(Behavioral)
								port map(clk      => CLOCK_50,
										   reset    => SW(17),
										   start    => SW(16),
										   sum      => s_key0,
										   sub      => s_key1,
										   mult     => s_key2,
										   div      => s_key3,
										   multDone => s_multDone,
										   divDone  => s_divDone,
										   multStart=> s_multStart,
										   divStart => s_divStart,
										   multSel  => S_multSel);
	
	--Blocos de Soma, Subtração, Multiplicação e Divisão
	sumunit_core : entity work.SumUnit(Behavioral)
								generic map(numBits  => 8)
									port map(operand0 => SW(15 downto 8),
												operand1 => SW(7 downto 0),
												ovf      => s_sumovf,
												result   => s_result00);
	
	subunit_core : entity work.SubUnit(Behavioral)
								generic map(numBits  => 8)
									port map(operand0 => SW(15 downto 8),
												operand1 => SW(7 downto 0),
												ovf      => s_subovf,
												result   => s_result01);
	
	itermultcore_core : entity work.IterMultCore(Shell)
									generic map(numBits  => 8)
										port map(clk      => CLOCK_50,
												   reset    => SW(17),
												   start    => s_multStart,
												   done     => s_multDone,
												   operand0 => SW(15 downto 8),
												   operand1 => SW(7 downto 0),
													ovf      => s_enable2,
												   result   => s_result10);
													
	iterdivcore_core : entity work.IterDivCore(Shell)
									generic map(numBits   => 8)
										port map(clk       => CLOCK_50,
												   reset     => SW(17),
												   start     => s_divStart,
												   operand0  => SW(15 downto 8),
												   operand1  => SW(7 downto 0),
												   done      => s_divDone,
												   result    => s_result11,
													ovf       => s_enable3);
	
	--Registos para o resultado da soma e da Subtracçã0
	shiftRegister_sum : entity work.ShiftRegister(Behavioral)
									generic map(N => 8)
										port map(clk        => CLOCK_50,
												   reset      => SW(17),
												   load       => s_key0,
												   shiftLeft  => '0',
												   shiftRight => '0',
												   shLeftin   => '0',
												   shRightin  => '0',
												   dataIn     => s_result00,
												   dataOut    => s_resultsum);
													
	shiftRegister_sub : entity work.ShiftRegister(Behavioral)
									generic map(N => 8)
										port map(clk        => CLOCK_50,
												   reset      => SW(17),
												   load       => s_key1,
												   shiftLeft  => '0',
												   shiftRight => '0',
												   shLeftin   => '0',
												   shRightin  => '0',
												   dataIn     => s_result01,
												   dataOut    => s_resultsub);
													
	--Registos para o overflow da soma e da Subtracçã0
	shiftRegister_sumovf : entity work.ShiftRegister(Behavioral)
									generic map(N => 1)
										port map(clk        => CLOCK_50,
												   reset      => SW(17),
												   load       => s_key0,
												   shiftLeft  => '0',
												   shiftRight => '0',
												   shLeftin   => '0',
												   shRightin  => '0',
												   dataIn     => s_sumovf,
												   dataOut    => s_enable0);
													
	shiftRegister_subovf : entity work.ShiftRegister(Behavioral)
									generic map(N => 1)
										port map(clk        => CLOCK_50,
												   reset      => SW(17),
												   load       => s_key1,
												   shiftLeft  => '0',
												   shiftRight => '0',
												   shLeftin   => '0',
												   shRightin  => '0',
												   dataIn     => s_subovf,
												   dataOut    => s_enable1);	
	
	--OutMux
	outmuxUnit_core : entity work.OutMux(Behavior)
								generic map(numBits     => 8)
									port map(l0          => s_resultsum,
												l1          => s_resultsub,
												l2          => s_result10,
												l3          => s_result11,
												SEL         => s_multSel,
												FINALRESULT => s_result,
												SIGNALMULT  => s_inMult);
	
	
	--PulseGenerator
	pulseGenerator_core : entity work.PulseGeneratorN(Behavioral)
										generic map(numberSteps => 50000000,
														outCompVal  => 25000000)
											port map(clkIn       => CLOCK_50,
														enable0(0)  => s_enable0(0),
														enable1(0)  => s_enable1(0),
														enable2(0)  => s_enable2,
														enable3(0)  => s_enable3,
														pulseOut    => LEDG(0));
	
	
	--Bin2BCDDecoder e Bin7SegDecoder
	bin2bcdDecore_core : entity work.Bin2BCDDecoder(Behavioral)
										port map(inMult  => s_inMult,
												   inBin	  => s_result,
												   outBCD0 => s_outbcd0,
												   outBCD1 => s_outbcd1,
												   outBCD2 => s_outbcd2,
												   outBCD3 => s_outbcd3,
													outBCD4 => s_outbcd4,
												   signBCD => s_outsign);
												  
	
	bin7seg_core0     : entity work.Bin7SegDecoder(Behavioral)
										port map(binInput => s_outbcd0,
													decOut_n => HEX0(6 downto 0));
													
	bin7seg_core1     : entity work.Bin7SegDecoder(Behavioral)
										port map(binInput => s_outbcd1,
													decOut_n => HEX1(6 downto 0));
	
	bin7seg_core2     : entity work.Bin7SegDecoder(Behavioral)
										port map(binInput => s_outbcd2,
													decOut_n => HEX2(6 downto 0));
	
	bin7seg_core3     : entity work.Bin7SegDecoder(Behavioral)
										port map(binInput => s_outbcd3,
													decOut_n => HEX3(6 downto 0));
													
	bin7seg_core4     : entity work.Bin7SegDecoder(Behavioral)
										port map(binInput => s_outbcd4,
													decOut_n => HEX4(6 downto 0));
	
	bin7seg_core5     : entity work.Bin7SegDecoder(Behavioral)
										port map(binInput => s_outsign,
													decOut_n => HEX5(6 downto 0));
																									
end Shell;