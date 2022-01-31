library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IMEM is
-- The instruction memory is a byte addressable, big-endian, read-only memory
-- Reads occur continuously
generic(NUM_BYTES : integer := 64);
-- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
port(
     Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
     ReadData : out STD_LOGIC_VECTOR(31 downto 0)
);
end IMEM;

architecture behavioral of IMEM is
type ByteArray is array (0 to NUM_BYTES) of STD_LOGIC_VECTOR(7 downto 0); 
signal imemBytes:ByteArray;
-- add and load has been updated
begin
process(Address)
variable addr:integer;
variable first:boolean:=true;
begin
   if(first) then
      --1st cycle SUB X23, X20, X19
      imemBytes(3) <= "11001011";
      imemBytes(2) <= "00010011";
      imemBytes(1) <= "00000010";
      imemBytes(0) <= "10010111"; 

      -- 2nd cycle CBZ X23, 5
      imemBytes(7) <= "10110100";
      imemBytes(6) <= "00000000";
      imemBytes(5) <= "00000000";
      imemBytes(4) <= "10110111";

      --3rd cycle  ADD X9,  X9, X9
      imemBytes(11) <= "10001011";
      imemBytes(10) <= "00001001";
      imemBytes(9)  <= "00000001";
      imemBytes(8)  <= "00101001";
      
      --4th Cycle SUB X24, X22, X21

      imemBytes(15) <= "11001011";
      imemBytes(14) <= "00010101";
      imemBytes(13) <= "00000010";
      imemBytes(12) <= "11011000";

      --5h cycle CBZ X24, 3

      imemBytes(19) <= "10110100";
      imemBytes(18) <= "00000000";
      imemBytes(17) <= "00000000";
      imemBytes(16) <= "01111000";
      --6th ADD X10, X10, X10
      imemBytes(23) <= "10001011";
      imemBytes(22) <= "00001010";
      imemBytes(21) <= "00000001";
      imemBytes(20) <= "01001010";
       --7th cycle ADD X11, X11, X11

      imemBytes(27) <= "10001011";
      imemBytes(26) <= "00001011";
      imemBytes(25) <= "00000001";
      imemBytes(24) <= "01101011";
 

     -- 8th cycle ADD X12, X12, X12
      imemBytes(31) <= "10001011";
      imemBytes(30) <= "00001100";
      imemBytes(29) <= "00000001";
      imemBytes(28) <= "10001100";
       -- 9th B 2
      imemBytes(35) <= "00010100";
      imemBytes(34) <= "00000000";
      imemBytes(33) <= "00000000";
      imemBytes(32) <= "00000010";

      --10th DD X19, X19, X19

      imemBytes(39) <= "10001011";
      imemBytes(38) <= "00010011";
      imemBytes(37) <= "00000010";
      imemBytes(36) <= "01110011";
     -- 11 ADD X20, X20, X20
      imemBytes(43) <= "10001011";
      imemBytes(42) <= "00010100";
      imemBytes(41) <= "00000010";
      imemBytes(40) <= "10010100";
      -- 12 nop
      imemBytes(47) <= "10001011";
      imemBytes(46) <= "00010100";
      imemBytes(45) <= "00000010";
      imemBytes(44) <= "10010100";
      -- 13 nop
      imemBytes(51) <= "10001011";
      imemBytes(50) <= "00010100";
      imemBytes(49) <= "00000010";
      imemBytes(48) <= "10010100";
      -- 14 nop
      imemBytes(55) <= "10001011";
      imemBytes(54) <= "00010100";
      imemBytes(53) <= "00000010";
      imemBytes(52) <= "10010100";

      -- 15 nop
      imemBytes(59) <= "10001011";
      imemBytes(58) <= "00010100";
      imemBytes(57) <= "00000010";
      imemBytes(56) <= "10010100";


      first:=false;
   end if;
   addr:=to_integer(unsigned(Address));
   if (addr+3 < NUM_BYTES) then -- Check that the address is within the bounds of the memory
      ReadData<=imemBytes(addr+3) & imemBytes(addr+2) & imemBytes(addr+1) & imemBytes(addr+0);
   else report "Invalid IMEM addr. Attempted to read 4-bytes starting at address " &
      integer'image(addr) & " but only " & integer'image(NUM_BYTES) & " bytes are available"
      severity error;
   end if;

end process;

end behavioral;


