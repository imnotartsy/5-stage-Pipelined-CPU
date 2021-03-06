library ieee;
use ieee.std_logic_1164.all;

entity SignExtend_tb is
end SignExtend_tb;

architecture behave of SignExtend_tb is
    component SignExtend
    port (
        x : in  STD_LOGIC_VECTOR(31 downto 0);
        b : in STD_LOGIC;
        y : out STD_LOGIC_VECTOR(63 downto 0) -- x and y
    );
    end component;

    signal in_sig : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal in_b : std_logic := '1';
    signal output_sig : std_logic_vector(63 downto 0);

begin
    signExtend_inst: SignExtend
    port map(
        x => in_sig,
        b => in_b,
        y => output_sig
    );

    process is
    begin

        in_sig <= "00000000000000000000000000000000";
        wait for 25 ns;
        -- assert output_sig = "0000000000000000000000000000000000000000000000000000000000000000"
         --   report "Broken :(" severity warning;
        
        wait for 25 ns;
        in_sig <= "00000000000000000000000000000001";
        wait for 25 ns;
        -- assert output_sig = "0000000000000000000000000000000000000000000000000000000000000001"
          --   report "Broken :(" severity warning;
        
        wait for 25 ns;
        in_sig <= "10000000000000000000000000000000";
        wait for 25 ns;
        assert output_sig = "1111111111111111111111111111111110000000000000000000000000000000" report "Broken :(" severity warning;
        
        wait for 25 ns;
        in_sig <= "01111111111111111111111111111111";
        wait for 25 ns;
        -- assert output_sig = "0000000000000000000000000000000001111111111111111111111111111111"
         --   report "Broken :(" severity warning;
        
        wait for 25 ns;

        
        in_b <= '0';

        in_sig <= "00000000000000000000000000000000";
        wait for 25 ns;
        -- assert output_sig = "0000000000000000000000000000000000000000000000000000000000000000"
         --   report "Broken :(" severity warning;
        
        wait for 25 ns;
        in_sig <= "00000000000000000000000000000001";
        wait for 25 ns;
        -- assert output_sig = "0000000000000000000000000000000000000000000000000000000000000001"
          --   report "Broken :(" severity warning;
        
        wait for 25 ns;
        in_sig <= "10000000000000000000000000000000";
        wait for 25 ns;
        assert output_sig = "1111111111111111111111111111111110000000000000000000000000000000" report "Broken :(" severity warning;
        
        wait for 25 ns;
        in_sig <= "01111111111111111111111111111111";
        wait for 25 ns;
        -- assert output_sig = "0000000000000000000000000000000001111111111111111111111111111111"
         --   report "Broken :(" severity warning;
        
        wait for 25 ns;


        wait;
    end process;

end behave;
-- end architecture;