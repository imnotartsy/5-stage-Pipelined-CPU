library ieee;
use ieee.std_logic_1164.all;

entity ShiftLeft2_tb is
end ShiftLeft2_tb;

architecture behave of ShiftLeft2_tb is
    component ShiftLeft2
    port (
        x : in  STD_LOGIC_VECTOR(63 downto 0);
        y : out STD_LOGIC_VECTOR(63 downto 0) -- x and y
    );
    end component;

    signal in_sig : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
    signal output_sig : std_logic_vector(63 downto 0);

begin
    shiftleft2_inst: ShiftLeft2
    port map(
        x => in_sig,
        y => output_sig
    );

    process is
    begin

        
        in_sig <= "0000000000000000000000000000000000000000000000000000000000000000";
	    wait for 50 ns;

        in_sig <= "0000000000000000000000000000000000000000000000000000000000000001";
        wait for 50 ns;
        --assert output_sig = "0000000000000000000000000000000000000000000000000000000000000100"
          --  report "Broken :(" severity warning;
        
        -- wait for 25ns;
        in_sig <= "0010000000000000000000000000000000000000000000000000000000000000";
        wait for 50 ns;
        -- assert output_sig = "1000000000000000000000000000000000000000000000000000000000000001"
         --   report "Broken :(" severity warning;
        
        -- wait for 25ns;
        in_sig <= "0000000000000000000000000000000000000000000000000000000000000000";
	    wait for 50 ns;

        in_sig <= "0000000000000000000000000000000000000000000000000000000000000001";
        wait for 50 ns;


        wait;
    end process;

end behave;
-- end architecture;