library ieee;
use ieee.std_logic_1164.all;

entity dmem_tb is
end dmem_tb;

architecture behave of dmem_tb is
    component DMEM
    port(
        WriteData          : in  STD_LOGIC_VECTOR(63 downto 0); -- Input data
        Address            : in  STD_LOGIC_VECTOR(63 downto 0); -- Read/Write address
        MemRead            : in  STD_LOGIC; -- Indicates a read operation
        MemWrite           : in  STD_LOGIC; -- Indicates a write operation
        Clock              : in  STD_LOGIC; -- Writes are triggered by a rising edge
        ReadData           : out STD_LOGIC_VECTOR(63 downto 0); -- Output data
        --Probe ports used for testing
        -- Four 64-bit words: DMEM(0) & DMEM(4) & DMEM(8) & DMEM(12) 
        DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
    );
    end component;

    -- Add signals
    signal wd : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
    signal ad : std_logic_vector(63 downto 0) := "1111111111111111111111111111111111111111111111111111111111111111";
    signal mr : std_logic := '0';
    signal mw : std_logic := '0';
    signal clk : std_logic := '0';
    signal rd : std_logic_vector(63 downto 0);
    signal debug : std_logic_vector(64*4 - 1 downto 0);


    
begin
    dmem_inst: dmem
    -- Update Port map
    port map(
        WriteData => wd,
        Address => ad,
        MemRead => mr,
        MemWrite => mw,
        Clock => clk,
        ReadData => rd,
        DEBUG_MEM_CONTENTS => debug
    );

    process is
    begin

        -- read 0x00000000
        ad <= "0000000000000000000000000000000000000000000000000000000000000000";
        mr <= '1';
        clk <= '1';
        wait for 10 ns;

        clk <= '0';
        wait for 10 ns;

        -- disable read 0x00000000
        mr <= '0';
        clk <= '1';
        wait for 10 ns;

        clk <= '0';
        wait for 10 ns;


        mr <= '1';
        clk <= '1';
        wait for 10 ns;

        clk <= '0';
        wait for 10 ns;

        -- write to 0x0000000
        wd <= "0000000000000000000000000000000000000000000000000000000000000000";
        mr <= '0';
        mw <= '1';
        clk <= '1';
        wait for 10 ns;

        clk <= '0';
        wait for 10 ns;
        

        -- disable read for 0x00000000
        mr <= '1';
        mw <= '0';
        clk <= '1';
        wait for 10 ns;

        clk <= '0';
        wait for 10 ns;

        mr <= '1';
        clk <= '1';
        wait for 10 ns;

        clk <= '0';
        wait for 10 ns;


        mr <= '1';
        clk <= '1';
        wait for 10 ns;

        clk <= '0';
        wait for 10 ns;
        
        

        wait for 50 ns;

        
        -- -- wait for 25ns;
        -- in_sig1 <= "0000000000000000000000000000000000000000000000000000000000000000";
        -- wait for 50ns;
        
        -- -- wait for 25ns;

        wait;
    end process;

end behave;
-- end architecture;



-- vcom -quiet -2008 dmem.vhd dmem_tb.vhd
-- vsim -quiet -c work.dmem_tb -do "log -r /*; run 500ns; exit" -wlf dmem.wlf
-- wlf2vcd dmem.wlf -o dmem.vcd