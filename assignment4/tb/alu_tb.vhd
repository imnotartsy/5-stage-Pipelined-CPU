library ieee;
use ieee.std_logic_1164.all;

entity alu_tb is
end alu_tb;

architecture behave of alu_tb is
    component ALU
    port(
        in0       : in     STD_LOGIC_VECTOR(63 downto 0);
        in1       : in     STD_LOGIC_VECTOR(63 downto 0);
        operation : in     STD_LOGIC_VECTOR(3 downto 0);
        result    : buffer STD_LOGIC_VECTOR(63 downto 0);
        zero      : buffer STD_LOGIC;
        overflow  : buffer STD_LOGIC
    );
    end component;

    -- Add signals
    signal in_sig0 : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
    signal in_sig1 : std_logic_vector(63 downto 0) := "1111111111111111111111111111111111111111111111111111111111111111";
    signal op : std_logic_vector(3 downto 0) := "0000";
    signal output_sig : std_logic_vector(63 downto 0);
    signal z : std_logic;
    signal ov : std_logic;

    
begin
    alu_inst: ALU
    -- Update Port map
    port map(
        in0 => in_sig0,
        in1 => in_sig1,
        operation => op,
        result => output_sig,
        zero => z,
        overflow => ov
    );

    process is
    begin

        -- tests all operations for the default inputs of 0x00000000 and 0xFFFFFFF
        op <= "0000";
        wait for 20 ns;

        op <= "0001";
        wait for 20 ns;

        op <= "0010";
        wait for 20 ns;

        op <= "0011";
        wait for 20 ns;

        op <= "0111";
        wait for 20 ns;

        op <= "1100";
        wait for 20 ns;


        -- tests all operations for the default inputs of 0x00000000 and 0xFFFFFFF
        in_sig0 <= "1111111111111111111111111111111111111111111111111111111111111111";
        op <= "0000";
        wait for 20 ns;

        op <= "0001";
        wait for 20 ns;

        op <= "0010";
        wait for 20 ns;

        op <= "0011";
        wait for 20 ns;

        op <= "0111";
        wait for 20 ns;

        op <= "1100";
        wait for 20 ns;



        -- Addition flag tests
        -- test zero flag ('0')
        in_sig0 <= "0000000000000000000000000000000000000000000000000000000000000000";
        in_sig1 <= "0000000000000000000000000000000000000000000000000000000000000000";
        op <= "0010";
        wait for 20 ns;

        -- test zero flag ('1')
        in_sig1 <= "0000000000000000000000000000000000000000000000000000000000000001";
        wait for 20 ns;

        -- test overflow flag ('0')
        in_sig0 <= "0000000000000000000000000000000000000000000000000000000000000000";
        in_sig1 <= "0000000000000000000000000000000000000000000000000000000000000000";
        wait for 20 ns;

        -- test overflow flag ('1')
        in_sig0 <= "1111111111111111111111111111111111111111111111111111111111111111";
        in_sig1 <= "0000000000000000000000000000000000000000000000000000000000000010";
        wait for 20 ns;

        op <= "1100";
        wait for 20 ns;

        wait;
    end process;


end behave;
-- end architecture;



-- vcom -quiet -2008 alu.vhd alu_tb.vhd
-- vsim -quiet -c work.alu_tb -do "log -r /*; run 500ns; exit" -wlf alu.wlf
-- wlf2vcd alu.wlf -o alu.vcd