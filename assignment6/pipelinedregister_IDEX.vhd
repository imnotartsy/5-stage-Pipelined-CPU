library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PipelinedRegister_IDEX is
    port(
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        en  : in STD_LOGIC;
        -- fl  : in STD_LOGIC;

        in_inst : in STD_LOGIC_VECTOR(31 downto 0);
        in_pc   : in STD_LOGIC_VECTOR(63 downto 0);
        in_CBranch  : in STD_LOGIC;  -- conditional
        in_UBranch  : in STD_LOGIC;  -- unconditional
        in_MemRead  : in STD_LOGIC;
        in_MemtoReg : in STD_LOGIC;
        in_MemWrite : in STD_LOGIC;
        in_RegWrite : in STD_LOGIC;
        in_ALUSrc   : in STD_LOGIC;
        in_ALUOp    : in STD_LOGIC_VECTOR(1 downto 0);
        in_readdata1   : in STD_LOGIC_VECTOR(63 downto 0);
        in_readdata2   : in STD_LOGIC_VECTOR(63 downto 0);
        in_signextend  : in STD_LOGIC_VECTOR(63 downto 0);

        in_rm : in STD_LOGIC_VECTOR(4 downto 0);
        in_rn : in STD_LOGIC_VECTOR(4 downto 0);


        out_inst : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
        out_pc   : out STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
        out_CBranch  : out STD_LOGIC := '0'; -- conditional
        out_UBranch  : out STD_LOGIC := '0'; -- unconditional
        out_MemRead  : out STD_LOGIC := '0';
        out_MemtoReg : out STD_LOGIC := '0';
        out_MemWrite : out STD_LOGIC := '0';
        out_RegWrite : out STD_LOGIC := '0';
        out_ALUSrc   : out STD_LOGIC := '0';
        out_ALUOp    : out STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
        out_readdata1 : out STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
        out_readdata2 : out STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
        out_signextend : out STD_LOGIC_VECTOR(63 downto 0) := (others => '0');

        out_rm : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
        out_rn : out STD_LOGIC_VECTOR(4 downto 0) := (others => '0')
        
    );
end PipelinedRegister_IDEX;


architecture rtl of PipelinedRegister_IDEX is
begin
    process (clk, rst)
    begin
        if rst = '1' then
            out_inst <= x"00000000";
            out_pc   <= x"0000000000000000";

            out_CBranch  <= '0';
            out_UBranch  <= '0';

            out_MemRead  <= '0';
            out_MemtoReg <= '0';
            out_MemWrite <= '0';
            out_RegWrite <= '0';
            
            out_ALUSrc   <= '0';
            out_ALUOp    <= "00";
 
            out_readdata1  <= x"0000000000000000";
            out_readdata2  <= x"0000000000000000";
            out_signextend <= x"0000000000000000";

            out_rn <= "00000";
            out_rm <= "00000";

        elsif rising_edge(clk) and en = '1' then
            out_inst <= in_inst;
            out_pc   <= in_pc;

            out_CBranch  <= in_CBranch;
            out_UBranch  <= in_UBranch;
            out_MemRead  <= in_MemRead;
            out_MemtoReg <= in_MemtoReg;
            out_MemWrite <= in_MemWrite;
            out_RegWrite <= in_RegWrite;
            out_ALUSrc   <= in_ALUSrc;
            out_ALUOp    <= in_ALUOp;
            
            out_readdata1  <= in_readdata1;
            out_readdata2  <= in_readdata2;
            out_signextend <= in_signextend;

            out_rn <= in_rn;
            out_rm <= in_rm;
        -- elsif rising_edge(clk) and fl = '1' then
        --     out_inst <= x"00000000";
        --     out_pc   <= x"0000000000000000";

        --     out_CBranch  <= '0';
        --     out_UBranch  <= '0';

        --     out_MemRead  <= '0';
        --     out_MemtoReg <= '0';
        --     out_MemWrite <= '0';
        --     out_RegWrite <= '0';
            
        --     out_ALUSrc   <= '0';
        --     out_ALUOp    <= "00";
 
        --     out_readdata1  <= x"0000000000000000";
        --     out_readdata2  <= x"0000000000000000";
        --     out_signextend <= x"0000000000000000";

        --     out_rn <= "00000";
        --     out_rm <= "00000";
        end if;

    end process;

end rtl;