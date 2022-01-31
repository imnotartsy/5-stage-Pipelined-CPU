library ieee;
use ieee.std_logic_1164.all;

entity alucontrol_tb is
end alucontrol_tb;

architecture behave of alucontrol_tb is
    component ALUCONTROL
    port(
        ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
        Opcode    : in  STD_LOGIC_VECTOR(10 downto 0);
        Operation : out STD_LOGIC_VECTOR(3 downto 0)
    );
    end component;

    -- Add signals
    signal in_sig0 : std_logic_vector(1 downto 0) := "00";
    signal in_sig1 : std_logic_vector(10 downto 0) := "11111111111";
    signal output_sig : std_logic_vector(3 downto 0);

begin
    alucontrol_inst: ALUCONTROL
    -- Update Port map
    port map(
        ALUOp => in_sig0,
        OpCode => in_sig1,
        Operation => output_sig
    );

    process is
    begin

        in_sig0 <= "00";
        wait for 20 ns;

        in_sig0 <= "01";
        wait for 20 ns;

        in_sig0 <= "10";
        in_sig1 <= "10001011000";
        wait for 20 ns;

        in_sig0 <= "01";
        wait for 20 ns;
        
        in_sig0 <= "10";
        in_sig1 <= "11001011000";
        wait for 20 ns;

        in_sig0 <= "01";
        wait for 20 ns;
        
        in_sig0 <= "10";
        in_sig1 <= "10001010000";
        wait for 20 ns;

        in_sig0 <= "01";
        wait for 20 ns;
        
        in_sig0 <= "10";
        in_sig1 <= "10101010000";
        wait for 20 ns;

        in_sig0 <= "01";
        wait for 20 ns;
        
        wait;
    end process;

end behave;
-- end architecture;

-- vcom -quiet -2008 alucontrol.vhd alucontrol_tb.vhd
-- vsim -quiet -c work.alucontrol_tb -do "log -r /*; run 500ns; exit" -wlf alucontrol.wlf
-- wlf2vcd alucontrol.wlf -o alucontrol.vcd