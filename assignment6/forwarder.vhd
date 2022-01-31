library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity Forwarder is
    port(
        IDEX_rn : in STD_LOGIC_VECTOR(4 downto 0);
        IDEX_rm : in STD_LOGIC_VECTOR(4 downto 0);

        EXMEM_WB_rw : in STD_LOGIC;
        -- EXMEM_WB_mt : in STD_LOGIC;
        EXMEM_rd : in STD_LOGIC_VECTOR(4 downto 0);

        MEMWB_WB_rw : in STD_LOGIC;
        -- MEMWB_WB_mt : in STD_LOGIC;
        MEMWB_rd : in STD_LOGIC_VECTOR(4 downto 0);

        ForwardA : out STD_LOGIC_VECTOR(1 downto 0);
        ForwardB : out STD_LOGIC_VECTOR(1 downto 0)
    );
end Forwarder;

architecture rtl of Forwarder is

begin
    process(all)
    begin
    
    -- ForwardA: 10 -- forwarded from alu 
        if EXMEM_WB_rw = '1'
        and EXMEM_rd /= "11111"
        and EXMEM_rd = IDEX_rn
        then
            ForwardA <= "10";
    -- ForwardA: 01 -- forwarded from dmem or earlier alu
        elsif MEMWB_WB_rw = '1'
        and MEMWB_rd /= "11111"
        -- and not(
        --     EXMEM_WB_rw = '1'
        --     and (EXMEM_rd /= "11111")
        --     and (EXMEM_rd /= IDEX_rn))
        and MEMWB_rd = IDEX_rn then
            ForwardA <= "01";
    -- ForwardA: 00 -- normal case
        else
            ForwardA <= "00";
        end if;
    
    
    -- ForwardB: 10 -- forwarded from alu 
        if EXMEM_WB_rw = '1'
        and EXMEM_rd /= "11111"
        and EXMEM_rd = IDEX_rm
        then
            ForwardB <= "10";
    -- ForwardB: 01 -- orwarded from dmem or earlier alu
        elsif MEMWB_WB_rw = '1'
        and MEMWB_rd /= "11111"
        -- and not(EXMEM_WB_rw = '1'
        --   and (EXMEM_rd /="11111")
        --   and (EXMEM_rd /= IDEX_rm))
        and MEMWB_rd = IDEX_rm then
            ForwardB <= "01";
    -- ForwardB: 00 -- normal case
        else
            ForwardB <= "00";
        end if;

    end process;
end rtl;