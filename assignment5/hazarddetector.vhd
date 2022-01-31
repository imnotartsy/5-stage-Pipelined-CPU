library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity HazardDetector is
    port(    
        IDEX_rd : in std_logic_vector(4 downto 0);
        IFID_rn : in std_logic_vector(4 downto 0);
        IFID_rm : in std_logic_vector(4 downto 0);
        IDEX_mr : in std_logic;
        
        IFID_rst : out std_logic;
        IFID_en : out std_logic;
        PC_en   : out std_logic;
        control_en : out std_logic
    );
end HazardDetector;

architecture rtl of HazardDetector is

begin
    process(all)
    begin
    
        if IDEX_mr = '1'
        and (IDEX_rd = IFID_rn or 
             IDEX_rd = IFID_rm) then
            -- stall
            IFID_rst <= '1';
            IFID_en <= '0';
            PC_en   <= '0';
            control_en <= '0';
        else
            IFID_rst <= '0';
            IFID_en <= '1';
            PC_en   <= '1';
            control_en <= '1';
        end if;
        
    end process;
end rtl;