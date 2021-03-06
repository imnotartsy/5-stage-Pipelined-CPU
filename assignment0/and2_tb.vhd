library ieee;
use ieee.std_logic_1164.all;

entity and2_tb is
end and2_tb;

architecture behave of and2_tb is
    component AND2
    port (
        in0    : in  STD_LOGIC;
        in1    : in  STD_LOGIC;
        output : out STD_LOGIC -- in0 and in1
    );
    end component;

    signal in_sig0 : std_logic := '0';
    signal in_sig1 : std_logic := '0';
    signal output_sig : std_logic;

begin
    and2_inst: AND2
    port map(
        in0 => in_sig0,
        in1 => in_sig1,
        output => output_sig
    );

    process is
    begin

        in_sig0 <= '0';
        in_sig1 <= '0';
        wait for 50 ns;
        -- assert output_sig = '0' report "Broken :(" severity warning;
        
        in_sig0 <= '0';
        in_sig1 <= '1';
        wait for 50 ns;
        -- assert output_sig = '0' report "Broken :(" severity warning;
        
        in_sig0 <= '1';
        in_sig1 <= '0';
        wait for 50 ns;
        -- assert output_sig = '0' report "Broken :(" severity warning;
        
        in_sig0 <= '1';
        in_sig1 <= '1';
        wait for 50 ns;
        -- assert output_sig = '1' report "Broken :(" severity warning;
        

        wait;
    end process;

end behave;
-- end architecture;