library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PipelinedRegister_IFID is
    port(
         clk : in STD_LOGIC;
         rst : in STD_LOGIC;
         en  : in STD_LOGIC;

         in_inst : in STD_LOGIC_VECTOR(31 downto 0);
         in_pc   : in STD_LOGIC_VECTOR(63 downto 0);

         out_inst : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
         out_pc   : out STD_LOGIC_VECTOR(63 downto 0) := (others => '0')
    );
end PipelinedRegister_IFID;


architecture rtl of PipelinedRegister_IFID is
begin
    process (all)
    begin
        if rst = '1' then
            out_inst <= x"00000000";
            out_pc   <= x"0000000000000000";
        elsif rising_edge(clk) and en = '1' then
            out_inst <= in_inst;
            out_pc   <= in_pc;
        end if;

    end process;

end rtl;