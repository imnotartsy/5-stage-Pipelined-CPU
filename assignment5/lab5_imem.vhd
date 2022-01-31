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
signal imemBytes:ByteArray := (others => x"00");
-- add and load has been updated
begin
process(Address)
variable addr:integer;
variable first:boolean:=true;
begin
   if(first) then
      --1st cycle LDUR  X9, [XZR, 0]
      imemBytes(3) <= "11111000";
      imemBytes(2) <= "01000000";
      imemBytes(1) <= "00000011";
      imemBytes(0) <= "11101001"; 

      -- 2nd cycle ADD X9, X9, X9
      imemBytes(7) <= "10001011";
      imemBytes(6) <= "00001001";
      imemBytes(5) <= "00000001";
      imemBytes(4) <= "00101001";

      --3rd cycle  ADD X10, X9, X9
      imemBytes(11) <= "10001011";
      imemBytes(10) <= "00001001";
      imemBytes(9)  <= "00000001";
      imemBytes(8)  <= "00101010";
      
      --4th Cycle SUB X11, X10, X9

      imemBytes(15) <= "11001011";
      imemBytes(14) <= "00001001";
      imemBytes(13) <= "00000001";
      imemBytes(12) <= "01001011";

      --5h cycle STUR  X11, [XZR, 8]

      imemBytes(19) <= "11111000";
      imemBytes(18) <= "00000000";
      imemBytes(17) <= "10000011";
      imemBytes(16) <= "11101011";
      --6th cycle STUR  X11, [XZR, 12]

      imemBytes(23) <= "11111000";
      imemBytes(22) <= "00000000";
      imemBytes(21) <= "11000011";
      imemBytes(20) <= "11101011";
 

      --7th NOP
      imemBytes(27) <= "00000000";
      imemBytes(26) <= "00000000";
      imemBytes(25) <= "00000000";
      imemBytes(24) <= "00000000";
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


      --10th nop

      imemBytes(39) <= "00000000";
      imemBytes(38) <= "00000000";
      imemBytes(37) <= "00000000";
      imemBytes(36) <= "00000000";


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


