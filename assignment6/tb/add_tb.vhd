library ieee;
use ieee.std_logic_1164.all;

entity add_tb is
end add_tb;

architecture behave of add_tb is
    component ADD
    port(
        in0    : in  STD_LOGIC_VECTOR(63 downto 0);
        in1    : in  STD_LOGIC_VECTOR(63 downto 0);
        output : out STD_LOGIC_VECTOR(63 downto 0)
    );
    end component;

    signal in_sig0 : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
    signal in_sig1 : std_logic_vector(63 downto 0) := "1111111111111111111111111111111111111111111111111111111111111111";
    signal output_sig : std_logic_vector(63 downto 0);

begin
    add_inst: ADD
    port map(
        in0 => in_sig0,
        in1 => in_sig1,
        output => output_sig
    );

    process is
    begin

        in_sig0 <= "0000000000000000000000000000000000000000000000000000000000000000";
        wait for 25 ns;

        in_sig1 <= "0000000000000000000000000000000000000000000000000000000000000000";
        wait for 25 ns;


        in_sig0 <= "0000000000000000000000000000000000000000000000000000000000000001";
        wait for 25 ns;

        in_sig1 <= "0000000000000000000000000000000000000000000000000000000000000001";
        wait for 25 ns;

        
        in_sig0 <= "0000000000000000000000000000000000000000000000000000000011111111";
        wait for 25 ns;
        
        in_sig0 <= "1111111111111111111111111111111111111111111111111111111111111111";
        wait for 25 ns;

        wait;
    end process;

end behave;
-- end architecture;


-- vcom -quiet -2008 add.vhd add_tb.vhd
-- vsim -quiet -c work.add_tb -do "log -r /*; run 500ns; exit" -wlf add.wlf
-- wlf2vcd add.wlf -o add.vcd