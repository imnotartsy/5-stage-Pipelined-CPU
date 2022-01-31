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
      -- 1st cycle ADD X11, X9, X10 -- this we changed after the OH tongiht
      imemBytes(3) <= "10001011";
      imemBytes(2) <= "00001010";
      imemBytes(1) <= "00000001";
      imemBytes(0) <= "00101011";
       --2st cycle STUR X11 XZR,0
 
      imemBytes(7) <= "11111000";
      imemBytes(6) <= "00000000";
      imemBytes(5) <= "00000011";
      imemBytes(4) <= "11101011";

      --3rd cycle  SUB X12, X9, X10
      imemBytes(11) <= "11001011";
      imemBytes(10) <= "00001010";
      imemBytes(9)  <= "00000001";
      imemBytes(8)  <= "00101100";
      
      --4th Cycle STUR  X11, [XZR,0]

      imemBytes(15) <= "11111000";
      imemBytes(14) <= "00000000";
      imemBytes(13) <= "00000011";
      imemBytes(12) <= "11101011";

      --5h cycle STUR  X12, [X12,8] incorrect value will be loaded 

      imemBytes(19) <= "11111000";
      imemBytes(18) <= "00000000";
      imemBytes(17) <= "10000001";
      imemBytes(16) <= "10001100";
      --6th cycle STUR  X12, [X12,8] correct value will be loaded


      imemBytes(23) <= "11111000";
      imemBytes(22) <= "00000000";
      imemBytes(21) <= "10000001";
      imemBytes(20) <= "10001100";
 

      --7th ORR X21, X19, X20
      imemBytes(27) <= "10101010";
      imemBytes(26) <= "00010100";
      imemBytes(25) <= "00000010";
      imemBytes(24) <= "01110101";
      -- 8th nop
      imemBytes(31) <= "00000000";
      imemBytes(30) <= "00000000";
      imemBytes(29) <= "00000000";
      imemBytes(28) <= "00000000";

      -- 9th nop
      imemBytes(35) <= "00000000";
      imemBytes(34) <= "00000000";
      imemBytes(33) <= "00000000";
      imemBytes(32) <= "00000000";


      --10th  STUR X21, [XZR,0] correct value will be loaded 
      imemBytes(39) <= "11111000";
      imemBytes(38) <= "00000000";
      imemBytes(37) <= "00000011";
      imemBytes(36) <= "11110101";  
  
       --11th nop
      imemBytes(43) <= "00000000";
      imemBytes(42) <= "00000000";
      imemBytes(41) <= "00000000";
      imemBytes(40) <= "00000000";
      --12th nop
      imemBytes(47) <= "00000000";
      imemBytes(46) <= "00000000";
      imemBytes(45) <= "00000000";
      imemBytes(44) <= "00000000";
      --13th nop
      imemBytes(51) <= "00000000";
      imemBytes(50) <= "00000000";
      imemBytes(49) <= "00000000";
      imemBytes(48) <= "00000000";
      -- nop
      imemBytes(55) <= "00000000";
      imemBytes(54) <= "00000000";
      imemBytes(53) <= "00000000";
      imemBytes(52) <= "00000000";




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


