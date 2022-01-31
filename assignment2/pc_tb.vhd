library ieee;
use ieee.std_logic_1164.all;

entity pc_tb is
end pc_tb;

architecture behave of pc_tb is
    component pc
    port(
        clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
        write_enable : in  STD_LOGIC; -- Only write if '1'
        rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
        AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
        AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
    );
    end component;

    signal in_clk : std_logic := '0';
    signal in_we : std_logic := '0';
    signal in_rst : std_logic := '0';
    signal in_addIn  : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
    signal out_addOut : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000001";


begin
    pc_inst: PC
    port map(
        clk => in_clk,
        write_enable => in_we,
        rst => in_rst,
        AddressIn => in_addIn,
        AddressOut => out_addOut
    );

    process is
    begin

        -- enable test
        -- out_addOut <= "1000000000000000000000000000000000000000000000000000000000000000";
        in_clk <= '0';
        wait for 50 ns;

        in_clk <= '1';
        in_we <= '1';
        in_rst <= '0';
        in_addIn <= "0000000000000000000000000000000000000000000000000000000000000001";
        wait for 50 ns;

        -- assert out_addOut = "0000000000000000000000000000000000000000000000000000000000000000"
        --    report "Broken :(" severity warning;
        in_clk <= '0';
        wait for 50 ns;

        in_clk <= '1';
        in_we <= '0';
        in_addIn <= "1000000000000000000000000000000000000000000000000000000000000000";
        wait for 50 ns;
        in_we <= '1';

        in_clk <= '0';
        wait for 50 ns;

        in_clk <= '1';
        wait for 50 ns;

        --assert out_addOut = "0000000000000000000000000000000000000000000000000000000000000001"
        --    report "Broken :(" severity warning;
        in_clk <= '0';
        wait for 50 ns;

        in_rst <= '1';
        --assert out_addOut = "0000000000000000000000000000000000000000000000000000000000000000"
        --    report "Broken :(" severity warning;
        wait for 50 ns;

        wait;
    end process;

end behave;
-- end architecture;