library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity DMEM is
-- The data memory is a byte addressble, little-endian, read/write memory with a single address port
-- It may not read and write at the same time
generic(NUM_BYTES : integer := 64);
-- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
port(
     WriteData          : in  STD_LOGIC_VECTOR(63 downto 0); -- Input data
     Address            : in  STD_LOGIC_VECTOR(63 downto 0); -- Read/Write address
     MemRead            : in  STD_LOGIC; -- Indicates a read operation
     MemWrite           : in  STD_LOGIC; -- Indicates a write operation
     Clock              : in  STD_LOGIC; -- Writes are triggered by a rising edge
     ReadData           : out STD_LOGIC_VECTOR(63 downto 0); -- Output data
     --Probe ports used for testing
     -- Four 64-bit words: DMEM(0) & DMEM(4) & DMEM(8) & DMEM(12)
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end DMEM;

architecture behavioral of DMEM is
type ByteArray is array (0 to NUM_BYTES) of STD_LOGIC_VECTOR(7 downto 0); 
signal dmemBytes:ByteArray;
begin
   process(Clock,MemRead,MemWrite,WriteData,Address) -- Run when any of these inputs change
   variable addr:integer;
   variable first:boolean := true; -- Used for initialization
   begin
      -- This part of the process initializes the memory and is only here for simulation purposes
      -- It does not correspond with actual hardware!
      if(first) then
         -- Example: MEM(0x0) = 0x1100000000000000 (Hex) 
         --  17(decimal)
         dmemBytes(7)  <= "00000001";
         dmemBytes(6)  <= "00000000";  
         dmemBytes(5)  <= "00000000";  
         dmemBytes(4)  <= "00000000";  
         dmemBytes(3)  <= "00000000";
         dmemBytes(2)  <= "00000000";  
         dmemBytes(1)  <= "00000000";  
         dmemBytes(0)  <= "00000000";  

         dmemBytes(15)   <= "00000000";
         dmemBytes(14)   <= "00000000";  
         dmemBytes(13)  <= "00000000";  
         dmemBytes(12)  <= "00000000";  
         dmemBytes(11)  <= "00000000";
         dmemBytes(10)  <= "00000000";  
         dmemBytes(9)  <= "00000000";  
         dmemBytes(8)  <= "00000000";  

         dmemBytes(23)  <= "00000000";
         dmemBytes(22)  <= "00000000";  
         dmemBytes(21)  <= "00000000";  
         dmemBytes(20)  <= "00000000";  
         dmemBytes(19)  <= "00000000";
         dmemBytes(18)  <= "00000000";  
         dmemBytes(17)  <= "00000000";  
         dmemBytes(16)  <= "00000000";  

         dmemBytes(31)  <= "00000000";
         dmemBytes(30)  <= "00000000";  
         dmemBytes(29)  <= "00000000";  
         dmemBytes(28)  <= "00000000";  
         dmemBytes(27)  <= "00000000";
         dmemBytes(26)  <= "00000000";  
         dmemBytes(25)  <= "00000000";  
         dmemBytes(24)  <= "00000000";  
         
         dmemBytes(32)  <= "00000000";
         dmemBytes(33)  <= "00000000";  
         dmemBytes(34)  <= "00000000";  
         dmemBytes(35)  <= "00000000";
         dmemBytes(36)  <= "00000000";
         dmemBytes(37)  <= "00000000";  
         dmemBytes(38)  <= "00000000";  
         dmemBytes(39)  <= "00000000";  
--         # this is updated
         dmemBytes(40)  <= "00000000";
         dmemBytes(41)  <= "00000000";  
         dmemBytes(42)  <= "00000000";  
         dmemBytes(43)  <= "00000000";         
         dmemBytes(44)  <= "00000000";
         dmemBytes(45)  <= "00000000";  
         dmemBytes(46)  <= "00000001";  
         dmemBytes(47)  <= "00000000";  

         dmemBytes(48)  <= "00000000";
         dmemBytes(49)  <= "00000000";  
         dmemBytes(50)  <= "00000000";  
         dmemBytes(51)  <= "00000000";           
         dmemBytes(52)  <= "00000000";
         dmemBytes(53)  <= "00000000";  
         dmemBytes(54)  <= "00000000";  
         dmemBytes(55)  <= "00000000";

         dmemBytes(56)  <= "00000000";
         dmemBytes(57)  <= "00000000";  
         dmemBytes(58)  <= "00000000";  
         dmemBytes(59)  <= "00000000";           
         dmemBytes(60)  <= "00000000";
         dmemBytes(61)  <= "00000000";  
         dmemBytes(62)  <= "00000000";  
         dmemBytes(63)  <= "00000000";

         dmemBytes(64)  <= "00000000";
         dmemBytes(65)  <= "00000000";  
         dmemBytes(66)  <= "00000000";  
         dmemBytes(67)  <= "00000000";  
         dmemBytes(68)  <= "00000000";
         dmemBytes(69)  <= "00000000";  
         dmemBytes(70)  <= "00000000";  
         dmemBytes(71)  <= "00000000";  

         dmemBytes(72)  <= "00000000";
         dmemBytes(73)  <= "00000000";  
         dmemBytes(74)  <= "00000000";  
         dmemBytes(75)  <= "00000000";  
         dmemBytes(76)  <= "00000000";
         dmemBytes(77)  <= "00000000";  
         dmemBytes(78)  <= "00000000";  
         dmemBytes(79)  <= "00000000";  

         dmemBytes(80)  <= "00000000";
         dmemBytes(81)  <= "00000000";  
         dmemBytes(82)  <= "00000000";  
         dmemBytes(83)  <= "00000000";  
         dmemBytes(84)  <= "00000000";
         dmemBytes(85)  <= "00000000";  
         dmemBytes(86)  <= "00000000";  
         dmemBytes(87)  <= "00000000";  

         dmemBytes(88)  <= "00000000";
         dmemBytes(89)  <= "00000000";  
         dmemBytes(90)  <= "00000000";  
         dmemBytes(91)  <= "00000000";  
         dmemBytes(92)  <= "00000000";
         dmemBytes(93)  <= "00000000";  
         dmemBytes(94)  <= "00000000";  
         dmemBytes(95)  <= "00000000";  

         dmemBytes(96)  <= "00000000";
         dmemBytes(97)  <= "00000000";  
         dmemBytes(98)  <= "00000000";  
         dmemBytes(99)  <= "00000000";  
         dmemBytes(100)  <= "00000000";
         dmemBytes(101)  <= "00000000";  
         dmemBytes(102)  <= "00000000";  
         dmemBytes(103)  <= "00000000";  

         dmemBytes(104)  <= "00000000";
         dmemBytes(105)  <= "00000000";  
         dmemBytes(106)  <= "00000000";  
         dmemBytes(107)  <= "00000000";  
         dmemBytes(108)  <= "00000000";
         dmemBytes(109)  <= "00000000";  
         dmemBytes(110)  <= "00000000";  
         dmemBytes(111)  <= "00000000";  

         dmemBytes(112)  <= "00000000";
         dmemBytes(113)  <= "00000000";  
         dmemBytes(114)  <= "00000000";  
         dmemBytes(115)  <= "00000000";  
         dmemBytes(116)  <= "00000000";
         dmemBytes(117)  <= "00000000";  
         dmemBytes(118)  <= "00000000";  
         dmemBytes(119)  <= "00000000";  

         dmemBytes(120)  <= "00000000";
         dmemBytes(121)  <= "00000000";  
         dmemBytes(122)  <= "00000000";  
         dmemBytes(123)  <= "00000000";  
         dmemBytes(124)  <= "00000000";
         dmemBytes(125)  <= "00000000";  
         dmemBytes(126)  <= "00000000";  
         dmemBytes(127)  <= "00000000";  

         dmemBytes(128)  <= "00000000";
         dmemBytes(129)  <= "00000000";  
         dmemBytes(130)  <= "00000000";  
         dmemBytes(131)  <= "00000000";  
         dmemBytes(132)  <= "00000000";
         dmemBytes(133)  <= "00000000";  
         dmemBytes(134)  <= "00000000";  
         dmemBytes(135)  <= "00000000";  

         dmemBytes(136)  <= "00000000";
         dmemBytes(137)  <= "00000000";  
         dmemBytes(138)  <= "00000000";  
         dmemBytes(139)  <= "00000000";  
         dmemBytes(140)  <= "00000000";
         dmemBytes(141)  <= "00000000";  
         dmemBytes(142)  <= "00000000";  
         dmemBytes(143)  <= "00000000";  



         first := false; -- Don't initialize the next time this process runs
      end if;

      -- The 'proper' HDL starts here!
      if Clock = '1' and Clock'event and MemWrite='1' and MemRead='0' then 
         -- Write on the rising edge of the clock
         addr:=to_integer(unsigned(Address)); -- Convert the address to an integer
         -- Splice the input data into bytes and assign to the byte array
         dmemBytes(addr+7)   <= WriteData(63 downto 56);
         dmemBytes(addr+6) <= WriteData(55 downto 48);
         dmemBytes(addr+5) <= WriteData(47 downto 40);
         dmemBytes(addr+4) <= WriteData(39 downto 32);
         dmemBytes(addr+3) <= WriteData(31 downto 24);
         dmemBytes(addr+2) <= WriteData(23 downto 16);
         dmemBytes(addr+1) <= WriteData(15 downto 8);
         dmemBytes(addr) <= WriteData(7 downto 0);
      elsif MemRead='1' and MemWrite='0' then -- Reads don't need to be edge triggered
         addr:=to_integer(unsigned(Address)); -- Convert the address
         if (addr+7 < NUM_BYTES) then -- Check that the address is within the bounds of the memory
           ReadData <= dmemBytes(addr+7) & dmemBytes(addr+6) &
               dmemBytes(addr+5) & dmemBytes(addr+4)&
	       dmemBytes(addr+3) & dmemBytes(addr+2) &
               dmemBytes(addr+1) & dmemBytes(addr+0);
         else report "Invalid DMEM addr. Attempted to read 4-bytes starting at address " &
            integer'image(addr) & " but only " & integer'image(NUM_BYTES) & " bytes are available"
            severity error;
         end if;
      end if;
   end process;
   -- Conntect the signals that will be used for testing
   --PM: double check how this need to change. 64 bit
   DEBUG_MEM_CONTENTS <= 
      dmemBytes( 0) & dmemBytes( 1) & dmemBytes( 2) & dmemBytes( 3) & --DMEM(0)
      dmemBytes( 4) & dmemBytes( 5) & dmemBytes( 6) & dmemBytes( 7) & --DMEM(4)
      dmemBytes( 8) & dmemBytes( 9) & dmemBytes(10) & dmemBytes(11) & --DMEM(8)
      dmemBytes(12) & dmemBytes(13) & dmemBytes(14) & dmemBytes(15)&  --DMEM(12)
    dmemBytes( 16) & dmemBytes( 17) & dmemBytes( 18) & dmemBytes( 19) & --DMEM(16)
      dmemBytes( 20) & dmemBytes( 21) & dmemBytes( 22) & dmemBytes( 23) & --DMEM(20)
      dmemBytes( 24) & dmemBytes( 25) & dmemBytes(26) & dmemBytes(27) & --DMEM(24)
      dmemBytes(28) & dmemBytes(29) & dmemBytes(30) & dmemBytes(31);  --DMEM(28)


end behavioral;

