library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity counter is
    generic (N: integer := 3);													--number of digits
    port (
	clock : in std_logic;															--clk signal
	reset : in std_logic;															--reset signal
	q0 : out unsigned (3 downto 0);												--output digit0
	q1 : out unsigned (3 downto 0);												--output digit1
	q2 : out unsigned (3 downto 0);												--output digit2
	carry : out std_logic															--carry signal
);
end counter;
 
architecture behavioral of counter is
    signal temp0 : unsigned(3 downto 0);
	 signal temp1 : unsigned(3 downto 0);
	 signal temp2 : unsigned(3 downto 0);
    constant INITIAL_STATE : unsigned (3 downto 0) := (others=>'0');
begin
    counting: process(clock, reset)
    begin
		if( reset = '1') then
			temp0 <= INITIAL_STATE;
			temp1 <= INITIAL_STATE;
			temp2 <= INITIAL_STATE;
			carry <= '0';
		else
			if rising_edge(clock) then
				if (temp0 = 9) then
					temp0 <= INITIAL_STATE;
					temp1 <= temp1 +1;
					if (temp1 = 9) then
						temp1 <= INITIAL_STATE;
						temp2 <= temp2 +1;
						if (temp2 = 9) then
							temp2 <= INITIAL_STATE;
							carry <= '1';
						else
							temp2 <= temp2 +1;
						end if;
					else
						temp1 <= temp1 +1;
					end if;
				else
					temp0 <= temp0 + 1;
					carry <= '0';
				end if;
			end if;
		end if;
    end process;
    q0 <= temp0;
	 q1 <= temp1;
	 q2 <= temp2;
end behavioral;