library ieee;
use ieee.std_logic_1164.all;

entity PipelinedCPU2_tb is
end PipelinedCPU2_tb;

architecture behave of PipelinedCPU2_tb is
    component PipelinedCPU2
    port(
        clk :in std_logic;
        rst :in std_logic;
        -- Probe ports used for testing
        DEBUG_IF_FLUSH : out std_logic; -- * NEW *
        DEBUG_REG_EQUAL : out std_logic; -- * NEW *
        -- Forwarding control signals
        DEBUG_FORWARDA : out std_logic_vector(1 downto 0);
        DEBUG_FORWARDB : out std_logic_vector(1 downto 0);
        --The current address (AddressOut from the PC)
        DEBUG_PC : out std_logic_vector(63 downto 0);
        --Value of PC.write_enable
        DEBUG_PC_WRITE_ENABLE : out STD_LOGIC;
        --The current instruction (Instruction output of IMEM)
        DEBUG_INSTRUCTION : out std_logic_vector(31 downto 0);
        --DEBUG ports from other components
        DEBUG_TMP_REGS : out std_logic_vector(64*4-1 downto 0);
        DEBUG_SAVED_REGS : out std_logic_vector(64*4-1 downto 0);
        DEBUG_MEM_CONTENTS : out std_logic_vector(64*4-1 downto 0)
    );
    end component;
    signal in_clk : STD_LOGIC := '0';
    signal in_rst : STD_LOGIC := '0';

    signal out_DEBUG_PC : STD_LOGIC_VECTOR(63 downto 0) := x"0000000000000000";
    signal out_DEBUG_INSTRUCTION : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
    signal out_DEBUG_TMP_REGS : STD_LOGIC_VECTOR(64*4 - 1 downto 0) := x"0000000000000000000000000000000000000000000000000000000000000000";
    signal out_DEBUG_SAVED_REGS : STD_LOGIC_VECTOR(64*4 - 1 downto 0) := x"0000000000000000000000000000000000000000000000000000000000000000";
    signal out_DEBUG_MEM_CONTENTS : STD_LOGIC_VECTOR(64*4 - 1 downto 0) := x"0000000000000000000000000000000000000000000000000000000000000000";
    signal out_DEBUG_PC_WRITE_ENABLE : STD_LOGIC := '0';

    signal out_DEBUG_IF_FLUSH : STD_LOGIC := '0';
    signal out_DEBUG_REG_EQUAL : STD_LOGIC := '0';

    signal out_DEBUG_FORWARDA : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal out_DEBUG_FORWARDB : STD_LOGIC_VECTOR(1 downto 0) := "00";


begin
    PipelinedCPU2_inst: PipelinedCPU2

    port map(
        clk => in_clk,
        rst => in_rst,
        DEBUG_IF_FLUSH => out_DEBUG_IF_FLUSH,
        DEBUG_REG_EQUAL => out_DEBUG_REG_EQUAL,
        DEBUG_FORWARDA => out_DEBUG_FORWARDA,
        DEBUG_FORWARDB => out_DEBUG_FORWARDB,
        DEBUG_PC => out_DEBUG_PC,
        DEBUG_PC_WRITE_ENABLE => out_DEBUG_PC_WRITE_ENABLE,
        DEBUG_INSTRUCTION => out_DEBUG_INSTRUCTION,
        DEBUG_TMP_REGS => out_DEBUG_TMP_REGS,
        DEBUG_SAVED_REGS => out_DEBUG_SAVED_REGS,
        DEBUG_MEM_CONTENTS => out_DEBUG_MEM_CONTENTS
    );

    -- tests go here
    process is
    begin

        -- in_rst <= '1';
        -- in_clk <= '1';
        -- wait for 10 ns;

        -- in_rst <= '0';
        -- in_clk <= '0';
        -- wait for 10 ns;

        -- -- in_rst <= '0';
        -- in_clk <= '1';
        -- wait for 10 ns;
        -- in_clk <= '0';
        -- wait for 10 ns;


        -- in_clk <= '1';
        -- wait for 10 ns;
        -- in_clk <= '0';
        -- wait for 10 ns;
        in_rst <= '0';

       for i in 0 to 2**5+1  loop
           in_clk <= not in_clk;
           wait for 10 ns;
       end loop; -- <name>

    wait;
    end process;

end behave;