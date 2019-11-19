library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity GuessLogic is
	port (
		clk_50, btn0, new_code : in std_logic;
		ps2input : in std_logic_vector(6 downto 0);
		led0 : out std_logic := '0');
end GuessLogic;

architecture Behavior of GuessLogic is
	signal counter : std_logic_vector(25 downto 0);
	signal guess	: std_logic_vector(13 downto 0);
	signal enableLine  : boolean := true;
--	signal oldchar : std_logic_vector(6 downto 0);
	signal word : std_logic_vector(13 downto 0);
	
begin
	
	ClockGenerator: process (clk_50)
	begin
		if btn0 = '0' then
			enableLine <= true;
		end if;
		if clk_50'event and clk_50 = '1' then  -- rising clock edge
         if counter < "10111110101111000010000000" then   -- Binary value is
                                                         -- 25e6
            counter <= counter + 1;
				if enableLine then
					guess <= guess + 1;
				end if;
         else
            counter <= (others => '0');
         end if;
      end if;
		if word = "01100010110010" and enableLine then
			enableLine <= false;
			guess <= "00000000000000";
		end if;
   end process ClockGenerator;
	
	switch: process(ps2input, enableLine, btn0)
	begin
		if not enableLine then
			led0 <= '1';
		else
			led0 <= '0';
		end if;
	end process switch;
	
	wordAddition: process(ps2input, new_code)
	begin
		if new_code'event and new_code = '1' then
			word <= word(6 downto 0) & ps2input;
		end if;
	end process wordAddition;
	
end Behavior;