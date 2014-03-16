library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  
entity counter_test is
end counter_test;
  
architecture behavior of counter_test is
   
	 constant N : integer := 3;
    constant CLOCK_PERIOD : time := 10 ns;
    constant WIDTH : integer := 4;
    signal clock_run : boolean := true;
 
    signal clock : std_logic;
    signal reset : std_logic;
    signal q0 : unsigned(3 downto 0);
	 signal q1 : unsigned(3 downto 0);
	 signal q2 : unsigned(3 downto 0);
	 signal carry : std_logic;
	 
begin
  
    -- instantiate the unit under test (uut)
    uut: entity work.counter
        port map (
            clock => clock,
            reset => reset,
            q0 => q0,
				q1 => q1,
				q2 => q2,
				carry => carry
        );
 
   -- clock process
    clock_process :process
    begin
        if clock_run then
            clock <= '0';
            wait for CLOCK_PERIOD/2;
            clock <= '1';
            wait for CLOCK_PERIOD/2;
        else
            wait;
        end if;
    end process;
  
    -- stimulus process
    stim_proc: process
    begin
		-- Err1 - testing for values when reset = 1
      reset <= '1';
      wait until falling_edge(clock);
      assert q0 = to_unsigned(0, WIDTH) report "Err1";
		assert q1 = to_unsigned(0, WIDTH) report "Err1";
		assert q2 = to_unsigned(0, WIDTH) report "Err1";

		-- Err2 - testing for initial values after reset <= 0
		reset <= '0';
		assert q0 = to_unsigned(0, WIDTH) report "Err2 DIG0_0";
		assert q1 = to_unsigned(0, WIDTH) report "Err2 DIG1_0";
		assert q2 = to_unsigned(0, WIDTH) report "Err2 DIG2_0";
		-- Err3 - testing for counting up (0 to 999)
		for a in 0 to 9 loop
			assert q2 = to_unsigned(a, WIDTH) report "Err3 DIG2 should be " & integer'image(a) & ", but is " & integer'image(to_integer(q2));
			for b in 0 to 9 loop
				assert q1 = to_unsigned(b, WIDTH) report "Err3 DIG1 should be " & integer'image(b) & ", but is " & integer'image(to_integer(q1));
				for c in 0 to 9 loop
					assert q0 = to_unsigned(c, WIDTH) report "Err3 DIG0 should be " & integer'image(c) & ", but is " & integer'image(to_integer(q0));
					wait until falling_edge(clock);
				end loop;
			end loop;
		end loop;
		
		-- Err4 - testing for carry signal generation
		assert carry = '1' report "Err4 CARRY signal is not generated after DIG2 overflow";
		-- Err5 - testing for carry signal duration
		wait until falling_edge(clock);
		assert carry = '0' report "Err4 CARRY duration is longer than expected";

		-- Err6 - testing for output values after reset signal
		wait for 1us;
		wait until falling_edge(clock);
		reset <='1';
		wait until falling_edge(clock);
		reset <='0';
		assert q0 = to_unsigned(0, WIDTH) report "Err6 DIG0_0";
		assert q1 = to_unsigned(0, WIDTH) report "Err6 DIG1_0";
		assert q2 = to_unsigned(0, WIDTH) report "Err6 DIG2_0";
		
      clock_run <= false;
      wait;
    end process;
end;