
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PipelinedRegister_MEMWB is
    port(
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        en  : in STD_LOGIC;

        in_MemtoReg : in STD_LOGIC;
        in_RegWrite : in STD_LOGIC;

        in_daddress : in STD_LOGIC_VECTOR(63 downto 0);
        in_rdata    : in STD_LOGIC_VECTOR(63 downto 0);
        in_endinst  : in STD_LOGIC_VECTOR(4 downto 0);
    

        out_MemtoReg : out STD_LOGIC;
        out_RegWrite : out STD_LOGIC;
        
        out_daddress : out STD_LOGIC_VECTOR(63 downto 0);
        out_rdata    : out STD_LOGIC_VECTOR(63 downto 0);
        out_endinst  : out STD_LOGIC_VECTOR(4 downto 0)

    );
end PipelinedRegister_MEMWB;


architecture rtl of PipelinedRegister_MEMWB is
begin
    process (clk, rst)
    begin
        if rst = '1' then        
            out_MemtoReg  <= '0';
            out_RegWrite  <= '0';
            
            out_daddress   <= x"0000000000000000";
            out_rdata     <= x"0000000000000000";
            out_endinst   <= "00000";
            
        elsif rising_edge(clk) and en = '1' then

            out_MemtoReg <= in_MemtoReg;
            out_RegWrite <= in_RegWrite;

            out_daddress <= in_daddress;
            out_rdata    <= in_rdata;
            out_endinst  <= in_endinst;

        end if;

    end process;

end rtl;