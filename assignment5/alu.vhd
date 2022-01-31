library ieee;
use ieee.std_logic_1164.all;
-- use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

entity ALU is
-- Implement: AND, OR, ADD (signed), SUBTRACT (signed)
--    as described in Section 4.4 in the textbook.
-- The functionality of each instruction can be found on the 'ARM Reference Data' sheet at the
--    front of the textbook (or the ISA pdf on Canvas).
port(
     in0       : in     STD_LOGIC_VECTOR(63 downto 0);
     in1       : in     STD_LOGIC_VECTOR(63 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(63 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC
    );
end ALU;

architecture rtl of ALU is
begin
    
    process (operation, in0, in1)
    begin
        -- AND
        if operation = "0000" then
            result <= in0 and in1;
            if result = x"0000000000000000" then
                zero <= '1';
            else
                zero <= '0';
            end if;
            overflow <= '0';
        -- OR
        elsif operation = "0001" then
            result <= in0 or in1;
            if result = x"0000000000000000" then
                zero <= '1';
            else
                zero <= '0';
            end if;
            overflow <= '0';
        -- ADD
        elsif operation = "0010" then
            result <= std_logic_vector(unsigned(in0) + unsigned(in1));
            if result <= x"0000000000000000" then
                zero <= '1';
            else
                zero <= '0';
            end if;
            if result < in0 or result < in1 then
                overflow <= '1';
            else
                overflow <= '0';
            end if;

         -- SUB
        elsif operation = "0110" then
            result <= std_logic_vector(unsigned(in0) - unsigned(in1));
            if result = x"0000000000000000" then
                zero <= '1';
            else
                zero <= '0';
            end if;
            if result > in0 or result > in1 then
                overflow <= '1';
            else
                overflow <= '0';
            end if;

        -- Pass b
        elsif operation = "0111" then
            result <= in1;
            if result = x"0000000000000000" then
                zero <= '1';
            else
                zero <= '0';
            end if;
            overflow <= '0';

        -- NOR
        elsif operation = "1100" then
            result <= in0 nor in1;
            if result = x"0000000000000000" then
                zero <= '1';
            else
                zero <= '0';
            end if;
            overflow <= '0';

        else
            result <= "0000000000000000000000000000000000000000000000000000000000000000";
        
        end if;
    end process;
        
end rtl;