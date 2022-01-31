library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers is
-- This component is described in the textbook, starting on section 4.3 
-- The indices of each of the registers can be found on the LEGv8 Green Card
-- Keep in mind that register 0(zero) has a constant value of 0 and cannot be overwritten

-- This should only write on the negative edge of Clock when RegWrite is asserted.
-- Reads should be purely combinatorial, i.e. they don't depend on Clock
-- HINT: Use the provided dmem.vhd as a starting point
port(RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
     RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
     WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
     WD       : in  STD_LOGIC_VECTOR (63 downto 0);
     RegWrite : in  STD_LOGIC;
     Clock    : in  STD_LOGIC;
     RD1      : out STD_LOGIC_VECTOR (63 downto 0);
     RD2      : out STD_LOGIC_VECTOR (63 downto 0);
     -- Probe ports used for testing.
     -- Notice the width of the port means that you are 
     --      reading only part of the register file. 
     -- This is only for debugging
     -- You are debugging a sebset of registers here
     -- Temp registers: $X9 & $X10 & X11 & X12 
     -- 4 refers to number of registers you are debugging
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     -- Saved Registers X19 & $X20 & X21 & X22 
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end registers;

architecture rtl of registers is
type regArray is array (0 to 32) of STD_LOGIC_VECTOR(63 downto 0); 
     -- signal reg : regArray := (0 => "0000000000000000000000000000000000000000000000000000000000000000",
     --                           9 => "0000000000000000000000000000000000000000000000000000000000000000",
     --                          10 => "0000000000000000000000000000000000000000000000000000000000000001",
     --                          11 => "0000000000000000000000000000000000000000000000000000000000000010",
     --                          12 => "0000000000000000000000000000000000000000000000000000000000000100",
     --                          13 => "0000000000000000000000000000000000000000000000000000000000001000",
     --                          14 => "0000000000000000000000000000000000000000000000000000000000010000",
     --                          15 => "0000000000000000000000000000000000000000000000000000000000100000",
     
     --                          -- saved registers
     --                          19 => "0000000000000000000000000000000000000000000000000000000000001000",
     --                          20 => "0000000000000000000000000000000000000000000000000000000000000000",
     --                          21 => "0000000000000000000000000000000000000000000000000000000000000010",
     --                          22 => "0000000000000000000000000000000000000000000000000000000000000100",
     --                          23 => "0000000000000000000000000000000000000000000000000000000000100000",
     --                          24 => "0000000000000000000000000000000000000000000000000000000001000000",
     --                          25 => "0000000000000000000000000000000000000000000000000000000010000000",
     --                          26 => "0000000000000000000000000000000000000000000000000000000100000000",
     --                          27 => "0000000000000000000000000000000000000000000000000000000100000000",
     --                          others => "0000000000000000000000000000000000000000000000000000000000000000");
     -- signal reg : regArray := (0 => "0000000000000000000000000000000000000000000000000000000000000000",
     --                          9 => "0000000000000000000000000000000000000000000000000000000000000000",
     --                          10 => x"0000000000000001",
     --                          11 => x"0000000000000004",
     --                          12 => x"0000000000000008",
     --                          13 => "0000000000000000000000000000000000000000000000000000000000001000",
     --                          14 => "0000000000000000000000000000000000000000000000000000000000010000",
     --                          15 => "0000000000000000000000000000000000000000000000000000000000100000",

     --                          -- saved registers
     --                          19 => x"0000000000000015",
     --                          20 => x"0000000000000007",
     --                          21 => x"0000000000000000",
     --                          22 => x"0000000000000016",
     --                          23 => "0000000000000000000000000000000000000000000000000000000000100000",
     --                          24 => "0000000000000000000000000000000000000000000000000000000001000000",
     --                          25 => "0000000000000000000000000000000000000000000000000000000010000000",
     --                          26 => "0000000000000000000000000000000000000000000000000000000100000000",
     --                          27 => "0000000000000000000000000000000000000000000000000000000100000000",
     --                          others => "0000000000000000000000000000000000000000000000000000000000000000");
     signal reg : regArray := (
                              9  => x"0000000000000010",
                              10 => x"0000000000000008",
                              11 => x"0000000000000002",
                              12 => x"0000000000000008",
                              
                              -- saved registers
                              19 => x"00000000CEA4126C",
                              20 => x"000000001009AC83",
                              21 => x"0000000000000000",
                              22 => x"0000000000000000",
                              others => "0000000000000000000000000000000000000000000000000000000000000000");


begin
     process(Clock, RR1, RR2, RegWrite, WD, WR)
     begin
          if (falling_edge(Clock)) and (RegWrite = '1') and (WR /= "11111") then
               reg(to_integer(unsigned(WR))) <= WD;
          end if;

          

          -- DEBUG_TMP_REGS(255 downto 192) <= reg(9);
          -- DEBUG_TMP_REGS(191 downto 128) <= reg(10);
          -- DEBUG_TMP_REGS(127 downto 64) <= reg(11);
          -- DEBUG_TMP_REGS(63 downto 0) <= reg(12);

          DEBUG_TMP_REGS <= reg(9) & reg(10) & reg(11) & reg(12);
          DEBUG_SAVED_REGS <= reg(19) & reg(20) & reg(21) & reg(22);
     end process;

     RD1 <= reg(to_integer(unsigned(RR1)));
     RD2 <= reg(to_integer(unsigned(RR2)));

end architecture;