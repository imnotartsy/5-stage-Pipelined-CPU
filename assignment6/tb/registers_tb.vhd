library ieee;
use ieee.std_logic_1164.all;

entity registers_tb is
end registers_tb;

architecture behave of registers_tb is
    component registers
    port(
        RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
        RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
        WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
        WD       : in  STD_LOGIC_VECTOR (63 downto 0);
        RegWrite : in  STD_LOGIC;
        Clock    : in  STD_LOGIC;
        RD1      : out STD_LOGIC_VECTOR (63 downto 0);
        RD2      : out STD_LOGIC_VECTOR (63 downto 0);
        DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
        DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
   );
    end component;

    -- Add signals
    signal in_rr1 : std_logic_vector(4 downto 0) := "00000";
    signal in_rr2 : std_logic_vector(4 downto 0) := "00000";
    signal in_wr : std_logic_vector(4 downto 0) := "00000";
    signal in_wd : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
    signal in_rw : std_logic := '0';
    signal clk : std_logic := '0';
    signal out_rd1 : std_logic_vector(63 downto 0);
    signal out_rd2 : std_logic_vector(63 downto 0);

    signal dtr : STD_LOGIC_VECTOR(64*4 - 1 downto 0);
    signal dsr : STD_LOGIC_VECTOR(64*4 - 1 downto 0);

begin
    registers_inst: registers
    -- Update Port map
    port map(
        RR1 => in_rr1,
        RR2 => in_rr2,
        WR => in_wr,
        WD => in_wd,
        RegWrite => in_rw,
        Clock => clk,
        RD1 => out_rd1,
        RD2 => out_rd2,
        DEBUG_TMP_REGS => dtr,
        DEBUG_SAVED_REGS => dsr
    );

    process is
    begin


        clk <= '0';
        wait for 10 ns;


        clk <= '1';
        wait for 10 ns;

        in_rr1 <= "00001";
        clk <= '0';
        wait for 10 ns;


        clk <= '1';
        wait for 10 ns;

        in_wr <= "00001";
        in_wd <= "0000000000000000000000000000000000000000000000000000000000000001";
        clk <= '0';
        wait for 10 ns;


        clk <= '1';
        wait for 10 ns;


        in_rw <= '1';
        clk <= '0';
        wait for 10 ns;


        clk <= '1';
        wait for 10 ns;


        in_rr2 <= "00001";
        clk <= '0';
        wait for 10 ns;


        clk <= '1';
        wait for 10 ns;

        wait;
    end process;

end behave;
-- end architecture;



-- vcom -quiet -2008 registers.vhd registers_tb.vhd
-- vsim -quiet -c work.registers_tb -do "log -r /*; run 500ns; exit" -wlf registerswlf
-- wlf2vcd registers.wlf -o registers.vcd