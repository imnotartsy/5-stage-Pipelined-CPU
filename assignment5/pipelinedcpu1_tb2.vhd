library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity pipelinedcpu1_tb2 is
end pipelinedcpu1_tb2;

architecture tb of pipelinedcpu1_tb2 is

    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal DEBUG_FORWARDA : std_logic_vector(1 downto 0) := (others => '0');
    signal DEBUG_FORWARDB : std_logic_vector(1 downto 0) := (others => '0');
    signal DEBUG_PC : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal DEBUG_PC_WRITE_ENABLE : STD_LOGIC := '0';
    signal DEBUG_INSTRUCTION : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal DEBUG_TMP_REGS : STD_LOGIC_VECTOR(64*4 - 1 downto 0) := (others => '0');
    signal DEBUG_SAVED_REGS : STD_LOGIC_VECTOR(64*4 - 1 downto 0) := (others => '0');
    signal DEBUG_MEM_CONTENTS : STD_LOGIC_VECTOR(64*4 - 1 downto 0) := (others => '0');

    component pipelinedcpu1 is
        port (
            clk :in STD_LOGIC;
            rst :in STD_LOGIC;
            --Probe ports used for testing
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

begin

    dut : component pipelinedcpu1
        port map (
            clk,
            rst,
            DEBUG_FORWARDA,
            DEBUG_FORWARDB,
            DEBUG_PC,
            DEBUG_PC_WRITE_ENABLE,
            DEBUG_INSTRUCTION,
            DEBUG_TMP_REGS,
            DEBUG_SAVED_REGS,
            DEBUG_MEM_CONTENTS
        );

    process begin
        clk <= '1';
        rst <= '1';
        wait for 5 ns;
        rst <= '0';
        clk <= '0';
        for i in 0 to 2**4+5 loop
            clk <= not clk;
            wait for 5 ns;
        end loop;
    end process;

    process
        type pattern_type is record
            DEBUG_PC : STD_LOGIC_VECTOR(63 downto 0);
            DEBUG_PC_WRITE_ENABLE : STD_LOGIC;
            DEBUG_INSTRUCTION : STD_LOGIC_VECTOR(31 downto 0);
            DEBUG_TMP_REGS : STD_LOGIC_VECTOR(64*4 - 1 downto 0);
            DEBUG_SAVED_REGS : STD_LOGIC_VECTOR(64*4 - 1 downto 0);
            DEBUG_MEM_CONTENTS : STD_LOGIC_VECTOR(64*4 - 1 downto 0);
            DEBUG_FORWARDA : std_logic_vector(1 downto 0);
            DEBUG_FORWARDB : std_logic_vector(1 downto 0);
        end record;
        --  The patterns to apply.
        type pattern_array is array (natural range <>) of pattern_type;
        constant patterns : pattern_array :=
           (
            (   -- 0
                64x"0", '1', 32x"F84003E9", 
                256x"00000000_00000001_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"01000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000",
                "00", "00"
            ),
            (   -- 1
                64x"4", '1', 32x"8B090129", 
                256x"00000000_00000001_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"01000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000",
                "00", "00"
            ),
            (   -- 2
                64x"8", '0', 32x"8B09012A", 
                256x"00000000_00000001_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"01000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000",
                "00", "00"
            ),
            (   -- 3
                64x"8", '1', 32x"8B09012A", 
                256x"00000000_00000001_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"01000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000",
                "10", "10"
            ),
            (   -- 4
                64x"C", '1', 32x"CB09014B", 
                256x"00000000_00000001_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"01000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000",
                "01", "01"
            ),
            (   -- 5
                64x"10", '1', 32x"F80083EB", 
                256x"00000000_00000001_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"01000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000",
                "10", "10"
            ),
            (   -- 6
                64x"14", '1', 32x"F800C3EB", 
                256x"00000000_00000002_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"01000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000",
                "10", "01"
            ),
            (   -- 7
                64x"18", '1', 32x"00000000", 
                256x"00000000_00000002_00000000_00000004_00000000_00000000_00000000_00000000", 
                256x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"01000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000",
                "00", "10"
            ),
            (   -- 8
                64x"1C", '1', 32x"00000000", 
                256x"00000000_00000002_00000000_00000004_00000000_00000002_00000000_00000000", 
                256x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"01000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000",
                "00", "01"
            ),
            (   -- 9
                64x"20", '1', 32x"00000000", 
                256x"00000000_00000002_00000000_00000004_00000000_00000002_00000000_00000000", 
                256x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"01000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000",
                "00", "00"
            ),
            (   -- 10
                64x"24", '1', 32x"00000000", 
                256x"00000000_00000002_00000000_00000004_00000000_00000002_00000000_00000000", 
                256x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"01000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000",
                "00", "00"
            ),
            (   -- 11
                64x"28", '1', 32x"00000000", 
                256x"00000000_00000002_00000000_00000004_00000000_00000002_00000000_00000000", 
                256x"00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000", 
                256x"01000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000",
                "00", "00"
            )
           );
    begin

        --  Check each pattern.
        for i in patterns'range loop

            --  Wait for the results.
            wait for 10 ns;

            assert DEBUG_PC   = patterns(i).DEBUG_PC   
                report "Test " & to_string(i) & " didn't work: DEBUG_PC should be " 
                    & to_hstring(patterns(i).DEBUG_PC) & ", is " & to_hstring(DEBUG_PC);
            assert DEBUG_PC_WRITE_ENABLE = patterns(i).DEBUG_PC_WRITE_ENABLE   
                report "Test " & to_string(i) & " didn't work: DEBUG_PC_WRITE_ENABLE should be " 
                    & to_string(patterns(i).DEBUG_PC_WRITE_ENABLE) 
                    & ", is " & to_string(DEBUG_PC_WRITE_ENABLE);
            assert DEBUG_INSTRUCTION   = patterns(i).DEBUG_INSTRUCTION   
                report "Test " & to_string(i) & " didn't work: DEBUG_INSTRUCTION should be " 
                    & to_hstring(patterns(i).DEBUG_INSTRUCTION) & ", is " & to_hstring(DEBUG_INSTRUCTION);
            assert DEBUG_TMP_REGS   = patterns(i).DEBUG_TMP_REGS   
                report "Test " & to_string(i) & " didn't work: DEBUG_TMP_REGS should be " 
                    & to_hstring(patterns(i).DEBUG_TMP_REGS) & ", is " & to_hstring(DEBUG_TMP_REGS);
            assert DEBUG_SAVED_REGS   = patterns(i).DEBUG_SAVED_REGS   
                report "Test " & to_string(i) & " didn't work: DEBUG_SAVED_REGS should be " 
                    & to_hstring(patterns(i).DEBUG_SAVED_REGS) & ", is " & to_hstring(DEBUG_SAVED_REGS);
            assert DEBUG_MEM_CONTENTS   = patterns(i).DEBUG_MEM_CONTENTS   
                report "Test " & to_string(i) & " didn't work: DEBUG_MEM_CONTENTS should be " 
                    & to_hstring(patterns(i).DEBUG_MEM_CONTENTS) & ", is " & to_hstring(DEBUG_MEM_CONTENTS);
            assert DEBUG_FORWARDA   = patterns(i).DEBUG_FORWARDA   
                report "Test " & to_string(i) & " didn't work: DEBUG_FORWARDA should be " 
                    & to_hstring(patterns(i).DEBUG_FORWARDA) & ", is " & to_hstring(DEBUG_FORWARDA);
            assert DEBUG_FORWARDB   = patterns(i).DEBUG_FORWARDB   
                report "Test " & to_string(i) & " didn't work: DEBUG_FORWARDB should be " 
                    & to_hstring(patterns(i).DEBUG_FORWARDB) & ", is " & to_hstring(DEBUG_FORWARDB);
        end loop;        
        wait for 1 ms;
    end process;
    

end architecture;