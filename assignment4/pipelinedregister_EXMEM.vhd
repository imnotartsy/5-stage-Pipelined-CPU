
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PipelinedRegister_EXMEM is
    port(
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        en  : in STD_LOGIC;

        in_CBranch  : in STD_LOGIC; -- conditional
        in_UBranch  : in STD_LOGIC; -- unconditional

        in_MemRead  : in STD_LOGIC;
        in_MemtoReg : in STD_LOGIC;
        in_MemWrite : in STD_LOGIC;
        in_RegWrite : in STD_LOGIC;
        

        in_ADDres   : in STD_LOGIC_VECTOR(63 downto 0); --addressBranch
        in_z        : in STD_LOGIC;
        in_ALUres   : in STD_LOGIC_VECTOR(63 downto 0);
        in_readdata2 : in STD_LOGIC_VECTOR(63 downto 0);
        in_endinst  : in STD_LOGIC_VECTOR(4 downto 0);
    

    
        out_CBranch  : out STD_LOGIC; -- conditional
        out_UBranch  : out STD_LOGIC; -- unconditional
        out_MemRead  : out STD_LOGIC;
        out_MemtoReg : out STD_LOGIC;
        out_MemWrite : out STD_LOGIC;
        out_RegWrite : out STD_LOGIC;

        out_ADDres   : out STD_LOGIC_VECTOR(63 downto 0); --addressBranch
        out_z        : out STD_LOGIC;
        out_ALUres   : out STD_LOGIC_VECTOR(63 downto 0);
        out_readdata2 : out STD_LOGIC_VECTOR(63 downto 0);
        out_endinst  : out STD_LOGIC_VECTOR(4 downto 0)

    );
end PipelinedRegister_EXMEM;


architecture rtl of PipelinedRegister_EXMEM is
begin
    process (clk, rst)
    begin
        if rst = '1' then        
            out_CBranch   <= '0'; -- conditional
            out_UBranch   <= '0'; -- unconditional

            out_MemRead   <= '0';
            out_MemtoReg  <= '0';
            out_MemWrite  <= '0';
            out_RegWrite  <= '0';

            out_ADDres    <= x"0000000000000000";  -- addressBranch
            out_z         <= '0';
            out_ALUres    <= x"0000000000000000";
            out_readdata2 <= x"0000000000000000";
            out_endinst   <= "00000";
            
        elsif rising_edge(clk) and en = '1' then

            out_CBranch  <= in_CBranch;
            out_UBranch  <= in_UBranch;

            out_MemRead  <= in_MemRead;
            out_MemtoReg <= in_MemtoReg;
            out_MemWrite <= in_MemWrite;
            out_RegWrite <= in_RegWrite;
            
            out_ADDres    <= in_ADDres;  -- addressBranch
            out_z         <= in_z;
            out_ALUres    <= in_ALUres;
            out_readdata2 <= in_readdata2;
            out_endinst   <= in_endinst;

        end if;

    end process;

end rtl;