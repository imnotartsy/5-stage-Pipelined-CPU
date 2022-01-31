library ieee;
use ieee.std_logic_1164.all;

entity cpucontrol_tb is
end cpucontrol_tb;

architecture behave of cpucontrol_tb is
    component CPUCONTROL
    port(
        Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
        RegDst   : out STD_LOGIC;
        CBranch  : out STD_LOGIC;  --conditional
        MemRead  : out STD_LOGIC;
        MemtoReg : out STD_LOGIC;
        MemWrite : out STD_LOGIC;
        ALUSrc   : out STD_LOGIC;
        RegWrite : out STD_LOGIC;
        UBranch  : out STD_LOGIC; -- This is unconditional
        ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
    );
    end component;

    -- Add signals
    signal in_sig0 : std_logic_vector(10 downto 0) := "00000000000";
    signal rd : std_logic;
    signal cb : std_logic;
    signal mr : std_logic;
    signal mt : std_logic;
    signal mw : std_logic;
    signal as : std_logic;
    signal rw : std_logic;
    signal ub : std_logic;
    signal ao : std_logic_vector(1 downto 0);

begin
    cpucontrol_inst: CPUCONTROL
    -- Update Port map
    port map(
        Opcode => in_sig0,
        RegDst => rd,
        Cbranch => cb,
        MemRead => mr,
        MemtoReg => mt,
        MemWrite => mw,
        ALUSrc => as,
        RegWrite => rw,
        UBranch => ub,
        ALUOp => ao
    );

    process is
    begin

        -- R-format
        in_sig0 <= "10001010000";
        wait for 50 ns;

        -- LDUR
        in_sig0 <= "11111000010";
        wait for 50 ns;

        -- STUR
        in_sig0 <= "11111000000";
        wait for 50 ns;

        -- CBZ
        in_sig0 <= "10110100000";
        wait for 50 ns;

        -- R-format alt
        in_sig0 <= "11101011000";
        wait for 50 ns;

        -- CBZ alt
        in_sig0 <= "10110100000";
        wait for 50 ns;

        -- LDUR
        in_sig0 <= "11111000010";
        wait for 50 ns;
        
        wait;
    end process;

end behave;
-- end architecture;

-- vcom -quiet -2008 cpucontrol.vhd cpucontrol_tb.vhd
-- vsim -quiet -c work.cpucontrol_tb -do "log -r /*; run 500ns; exit" -wlf cpucontrol.wlf
-- wlf2vcd cpucontrol.wlf -o cpucontrol.vcd