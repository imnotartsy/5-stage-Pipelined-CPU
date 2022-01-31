library ieee;
use ieee.std_logic_1164.all;

entity ALUControl is
-- Functionality should match truth table shown in Figure 4.13 in the textbook.
-- Check table on page2 of ISA.pdf on canvas. Pay attention to opcode of operations and type of operations. 
-- If an operation doesn't use ALU, you don't need to check for its case in the ALU control implemenetation.	
--  To ensure proper functionality, you must implement the "don't-care" values in the funct field,
-- for example when ALUOp = '00", Operation must be "0010" regardless of what Funct is.
port(
     ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
     Opcode    : in  STD_LOGIC_VECTOR(10 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
    );
end ALUControl;

architecture rtl of ALUControl is
begin
    process(ALUOp, Opcode)
    begin
        if ALUOp(1 downto 0)="00" then
            operation <= "0010";
        elsif ALUOp(0)='1' then
            operation <= "0111";
        elsif ALUOp(1) = '1' then
            if Opcode(10 downto 0) = "10001011000" then
                operation <= "0010";
            elsif Opcode(10 downto 0) = "11001011000" or Opcode(10 downto 1) = "1101000100" then -- sub/sub
                operation <= "0110";
            elsif Opcode(10 downto 0) = "10001010000" then
                operation <= "0000";
            elsif Opcode(10 downto 0) = "10101010000" then
                operation <= "0001";
            end if;
        else
            operation <= "0000";
        end if;
    end process;
    
end rtl;