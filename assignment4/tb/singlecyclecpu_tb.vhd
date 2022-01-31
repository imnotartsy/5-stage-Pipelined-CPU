library ieee;
use ieee.std_logic_1164.all;

entity SingleCycleCPU_tb is
end SingleCycleCPU_tb;

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

    signal in_clk : STD_LOGIC := '0';
    signal in_rst : STD_LOGIC := '0';

    signal out_DEBUG_PC : STD_LOGIC_VECTOR(63 downto 0) := x"0000000000000000";
    signal out_DEBUG_INSTRUCTION : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
    signal out_DEBUG_TMP_REGS : STD_LOGIC_VECTOR(64*4 - 1 downto 0) := x"0000000000000000000000000000000000000000000000000000000000000000";
    signal out_DEBUG_SAVED_REGS : STD_LOGIC_VECTOR(64*4 - 1 downto 0) := x"0000000000000000000000000000000000000000000000000000000000000000";
    signal out_DEBUG_MEM_CONTENTS : STD_LOGIC_VECTOR(64*4 - 1 downto 0) := x"0000000000000000000000000000000000000000000000000000000000000000";

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

        -- in_rst <= '0';
        -- in_clk <= '1';
        -- wait for 10 ns;

        -- in_rst <= '1';
        -- in_clk <= '0';
        -- wait for 10 ns;

        -- in_rst <= '0';
        -- in_clk <= '1';
        -- wait for 10 ns;
        -- in_clk <= '0';
        -- wait for 10 ns;


        in_clk <= '1';
        wait for 10 ns;
        in_clk <= '0';
        wait for 10 ns;


       for i in 0 to 2**4 loop
           in_clk <= not in_clk;
           wait for 10 ns;
       end loop; -- <name>

    wait;
    end process;

end behave;

-- vcom -quiet -2008 singlecyclecpu.vhd singlecyclecpu_tb.vhd
-- vsim -quiet -c work.singlecyclecpu_tb -do "log -r /*; run 500ns; exit" -wlf singlecyclecpu.wlf
-- wlf2vcd singlecyclecpu.wlf -o singlecyclecpu.vcd



-- vcom -quiet -2008 *.vhd imem/imem_ldstr.vhd
-- vsim -quiet -c work.singlecyclecpu_tb -do "log -r /*; run 500ns; exit" -wlf singlecyclecpu.wlf &&  wlf2vcd singlecyclecpu.wlf -o singlecyclecpu.vcd


-- PC
-- instructions --> parse
-- CPU control (3), registers (2), and sign extend (1)
-- branch and immediate


-- test without --2008



-- test one imem at a time
-- define clock periods(?) 600 ns clock period; 


-- branch, condional branch, i type (immediate)