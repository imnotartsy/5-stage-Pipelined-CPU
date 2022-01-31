-- library ieee;
-- use ieee.std_logic_1164.all;

-- entity imem_tb is
-- end imem_tb;

-- architecture behave of imem_tb is
--     component IMEM
--     port(
--         Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
--         ReadData : out STD_LOGIC_VECTOR(31 downto 0));
--     end component;

--     -- Add signals
--     signal in_sig : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
--     signal out_sig : std_logic_vector(31 downto 0);

-- begin
--     imem_inst: IMEM
--     -- Update Port map
--     port map(
--         Address => in_sig,
--         ReadData => out_sig
--     );

--     process is
--     begin

--         in_sig <= "0000000000000000000000000000000000000000000000000000000000000000";
--         wait for 25 ns;

--         in_sig <= "0000000000000000000000000000000000000000000000000000000000000001";
--         wait for 25 ns;
        
--         in_sig <= "0000000000000000000000000000000000000000000000000000000000000010";
--         wait for 25 ns;

--         in_sig <= "0000000000000000000000000000000000000000000000000000000000000011";
--         wait for 25 ns;

--         in_sig <= "0000000000000000000000000000000000000000000000000000000000000100";
--         wait for 25 ns;

--         in_sig <= "0000000000000000000000000000000000000000000000000000000000000001";
--         wait for 25 ns;

--         in_sig <= "0000000000000000000000000000000000000000000000000000000000000000";
--         wait for 25 ns;

--         wait;
--     end process;

-- end behave;
-- -- end architecture;



-- -- vcom -quiet -2008 imem.vhd imem_tb.vhd
-- -- vsim -quiet -c work.imem_tb -do "log -r /*; run 500ns; exit" -wlf imem.wlf
-- -- wlf2vcd imem.wlf -o imem.vcd