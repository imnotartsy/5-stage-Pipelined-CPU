-- library IEEE;
-- use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.NUMERIC_STD.ALL;

-- entity IMEM is
-- -- The instruction memory is a byte addressable, little-endian, read-only memory
-- -- Reads occur continuously
-- generic(NUM_BYTES : integer := 64);
-- -- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
-- port(
--      Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
--      ReadData : out STD_LOGIC_VECTOR(31 downto 0)
-- );
-- end IMEM;

-- architecture behavioral of IMEM is
-- type ByteArray is array (0 to NUM_BYTES) of STD_LOGIC_VECTOR(7 downto 0); 
-- signal imemBytes:ByteArray;
-- -- add and load has been updated
-- begin
-- process(Address)
-- variable addr:integer;
-- variable first:boolean:=true;
-- begin
--    if(first) then
--       --ADDI X10, X11, 1
--       imemBytes(3) <= "10010001";
--       imemBytes(2) <= "00000000";
--       imemBytes(1) <= "00000101";
--       imemBytes(0) <= "01101010";
--        --ADDI X10, X11, 2
 
--       imemBytes(7) <= "10010001";
--       imemBytes(6) <= "00000000";
--       imemBytes(5) <= "00001001";
--       imemBytes(4) <= "01101010";

--       -- ADDI X9, X9, 1  
--       imemBytes(11) <= "10010001";
--       imemBytes(10) <= "00000000";
--       imemBytes(9)  <= "00000100"; 
--       imemBytes(8)  <= "00101001"; 
      
--       -- SUBI X9, X9, 1

--       imemBytes(15) <= "11010001";
--       imemBytes(14) <= "00000000";
--       imemBytes(13) <= "00000101";
--       imemBytes(12) <= "00101001";

--       -- ADD  X10, X9, X11
--       imemBytes(19) <= "10001011";
--       imemBytes(18) <= "00001011";
--       imemBytes(17) <= "00000001";
--       imemBytes(16) <= "00101010";
        
      





--       first:=false;
--    end if;
--    addr:=to_integer(unsigned(Address));
--    if (addr+3 < NUM_BYTES) then -- Check that the address is within the bounds of the memory
--       ReadData<=imemBytes(addr+3) & imemBytes(addr+2) & imemBytes(addr+1) & imemBytes(addr+0);
--    else report "Invalid IMEM addr. Attempted to read 4-bytes starting at address " &
--       integer'image(addr) & " but only " & integer'image(NUM_BYTES) & " bytes are available"
--       severity error;
--    end if;

-- end process;

-- end behavioral;

