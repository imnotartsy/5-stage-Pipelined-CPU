library ieee;
use ieee.std_logic_1164.all;

entity mux64_tb is
end mux64_tb;

architecture behave of mux64_tb is
    component MUX64
    port (
        in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 0
        in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 1
        sel    : in STD_LOGIC; -- selects in0 or in1
        output : out STD_LOGIC_VECTOR(63 downto 0)
    );
    end component;

    signal in_sig0 : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
    signal in_sig1 : std_logic_vector(63 downto 0) := "1111111111111111111111111111111111111111111111111111111111111111";
    signal in_sel : std_logic := '0';
    signal output_sig : std_logic_vector(63 downto 0);

begin
    mux64_inst: MUX64
    port map(
        in0 => in_sig0,
        in1 => in_sig1,
        sel => in_sel,
        output => output_sig
    );

    process is
    begin

        in_sel <= '1';
        wait for 50 ns;
        -- assert output_sig = "1111111111111111111111111111111111111111111111111111111111111111"
        --    report "Broken :(" severity warning;
        
        -- wait for 25ns;
        in_sel <= '0';
        wait for 50 ns;
        -- assert output_sig = "0000000000000000000000000000000000000000000000000000000000000000"
         --    report "Broken :(" severity warning;
        
        -- wait for 25ns;

        wait;
    end process;

end behave;
-- end architecture;