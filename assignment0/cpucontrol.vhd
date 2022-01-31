library ieee;
use ieee.std_logic_1164.all;

entity CPUControl is
-- Functionality should match the truth table shown in Figure 4.22 of the textbook, inlcuding the
--    output 'X' values.
-- The truth table in Figure 4.22 omits the unconditional branch instruction:
--    UBranch = '1'
--    MemWrite = RegWrite = '0'
--    all other outputs = 'X'	
port(Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
     RegDst   : out STD_LOGIC;
     CBranch  : out STD_LOGIC;  --conditional
     MemRead  : out STD_LOGIC;
     MemtoReg : out STD_LOGIC;
     MemWrite : out STD_LOGIC;
     ALUSrc   : out STD_LOGIC;
     RegWrite : out STD_LOGIC;
     UBranch  : out STD_LOGIC; -- This is unconditional
     ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
);
end CPUControl;

architecture rtl of CPUControl is
begin
     process(Opcode)
     begin

          if Opcode(10 downto 0) = "11111000010" then -- LDUR
               RegDst <= '1'; -- floating
               ALUSrc <= '1';
               MemtoReg <= '1';
               RegWrite <= '1';
               MemRead <= '1';
               MemWrite <= '0';
               CBranch <= '0';
               ALUOp(1) <= '0';
               ALUOp(0) <= '0';
               UBranch <= '0';
          elsif Opcode(10 downto 0) = "11111000000" then -- STUR
               RegDst <= '1'; 
               ALUSrc <= '1';
               MemtoReg <= '1'; -- floating
               RegWrite <= '0';
               MemRead <= '0';
               MemWrite <= '1';
               CBranch <= '0';
               ALUOp(1) <= '0';
               ALUOp(0) <= '0';
               UBranch <= '0';
          elsif Opcode(10 downto 3) = "10110100" then -- CBZ
               RegDst <= '1'; 
               ALUSrc <= '0';
               MemtoReg <= '1';
               RegWrite <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               CBranch <= '0';
               ALUOp(1) <= '0';
               ALUOp(0) <= '1';
               UBranch <= '0';
          elsif (Opcode(10) = '1') and (Opcode(7 downto 4) = "0101") and (Opcode(2 downto 0) = "000") then-- "1XX0101X000" (R)
               RegDst <= '0'; 
               ALUSrc <= '0';
               MemtoReg <= '0'; 
               RegWrite <= '1';
               MemRead <= '0';
               MemWrite <= '1';
               CBranch <= '0';
               ALUOp(1) <= '1';
               ALUOp(0) <= '0';
               UBranch <= '0';
          elsif Opcode(10 downto 5) = "000101" then
               UBranch <= '1'; -- when 'B' instruction 
               RegDst <= '0';
               CBranch <= '0';
               MemRead <= '0';
               MemWrite <= '1';
               MemtoReg <= '0';
               ALUSrc <= '0';
               ALUOp(1) <= '1';
               ALUOp(0) <= '0';
          elsif (Opcode(10) = '1') and (Opcode(7 downto 5) = "100") and (Opcode(2 downto 1) = "00") then -- "1XX100XX00X" (I)
               RegDst <= '0'; 
               ALUSrc <= '1';
               MemtoReg <= '0'; 
               RegWrite <= '1';
               MemRead <= '0';
               MemWrite <= '1';
               CBranch <= '0';
               ALUOp(1) <= '1';
               ALUOp(0) <= '0';
               UBranch <= '0';
          else
               RegDst <= '0';
               CBranch <= '0';
               MemRead <= '0';
               MemWrite <= '0'; -- ?
               RegWrite <= '0';
               MemtoReg <= '0';
               ALUSrc <= '0';
               ALUOp(1) <= '0';
               ALUOp(0) <= '0';
               UBranch <= '0';
          end if;

          --MemWrite <= '1';
          -- RegWrite <= '1';
     end process;

     
--     output <= in0 when sel = '0' else in1;
end rtl;
