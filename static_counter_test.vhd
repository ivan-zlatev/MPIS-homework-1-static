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
      reset <= '1';
      wait until falling_edge(clock);
      assert q0 = to_unsigned(0, WIDTH) report "Err1";
		assert q1 = to_unsigned(0, WIDTH) report "Err1";
		assert q2 = to_unsigned(0, WIDTH) report "Err1";

		reset <= '0';
		wait until (carry = '1');
		wait for 100ns;
--		for a in 0 to 9 loop
--			for b in 0 to 9 loop
--				for c in 0 to 9 loop
--					wait until falling_edge(clock);
--					assert q0 = to_unsigned(c, WIDTH) report "Err2 DIG0";
--				end loop;
--				assert q1 = to_unsigned(b, WIDTH) report "Err2 DIG1";
--			end loop;
--			assert q2 = to_unsigned(a, WIDTH) report "Err2 DIG2";
--		end loop;

      clock_run <= false;
      wait;
    end process;
end;