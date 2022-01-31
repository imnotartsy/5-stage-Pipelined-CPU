library ieee;
use ieee.std_logic_1164.all;

entity SingleCycleCPU is
end SingleCycleCPU;

architecture behave of SingleCycleCPU_tb is
    component SingleCycleCPU
    port(
        clk :in STD_LOGIC;
        rst :in STD_LOGIC;
        --Probe ports used for testing
        --The current address (AddressOut from the PC)
        DEBUG_PC : out STD_LOGIC_VECTOR(63 downto 0);
        --The current instruction (Instruction output of IMEM)
        DEBUG_INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0);
        --DEBUG ports from other components
        DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
        DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
        DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
    );
    end component;

    signal in_clk :in STD_LOGIC;
    signal in_rst :in STD_LOGIC;

    signal out_DEBUG_PC : out STD_LOGIC_VECTOR(63 downto 0);
    signal out_DEBUG_INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0);
    signal out_DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
    signal out_DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
    signal out_DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);

begin
    SingleCycleCPU_inst: SingleCycleCPU

    port map(
        clk => in_clk,
        rst => in_rst,
        DEBUG_PC => out_DEBUG_PC,
        DEBUG_INSTRUCTION => out_DEBUG_INSTRUCTION,
        DEBUG_TMP_REGS => out_DEBUG_TMP_REGS,
        DEBUG_SAVED_REGS => out_DEBUG_SAVED_REGS,
        DEBUG_MEM_CONTENTS => out_DEBUG_MEM_CONTENTS
    );

    -- tests go here
    process is
    begin

        wait for 200 ns;

    wait;
    end process;

end behave;

-- vcom -quiet -2008 singlecyclecpu.vhd singlecyclecpu_tb.vhd
-- vsim -quiet -c work.singlecyclecpu_tb -do "log -r /*; run 500ns; exit" -wlf singlecyclecpu.wlf
-- wlf2vcd singlecyclecpu.wlf -o singlecyclecpu.vcd