library ieee;
use ieee.std_logic_1164.all;

entity PipelinedCPU1_tb is
end PipelinedCPU1_tb;

architecture behave of PipelinedCPU1_tb is
    component PipelinedCPU1
    port(
        clk :in std_logic;
        rst :in std_logic;
        -- Probe ports used for testing
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

    signal out_DEBUG_FORWARDA : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal out_DEBUG_FORWARDB : STD_LOGIC_VECTOR(1 downto 0) := "00";
    

begin
    PipelinedCPU1_inst: PipelinedCPU1

    port map(
        clk => in_clk,
        rst => in_rst,
        DEBUG_PC => out_DEBUG_PC,
        DEBUG_PC_WRITE_ENABLE => out_DEBUG_PC_WRITE_ENABLE,
        DEBUG_INSTRUCTION => out_DEBUG_INSTRUCTION,
        DEBUG_TMP_REGS => out_DEBUG_TMP_REGS,
        DEBUG_SAVED_REGS => out_DEBUG_SAVED_REGS,
        DEBUG_MEM_CONTENTS => out_DEBUG_MEM_CONTENTS,
        DEBUG_FORWARDA => out_DEBUG_FORWARDA,
        DEBUG_FORWARDB => out_DEBUG_FORWARDB
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

       for i in 0 to 2**4+5 loop
           in_clk <= not in_clk;
           wait for 10 ns;
       end loop; -- <name>

    wait;
    end process;

end behave;