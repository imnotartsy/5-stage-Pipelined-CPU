-- -- 
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
-- signal imemBytes:ByteArray := (others => "00000000");
-- -- add and load has been updated
-- begin
-- process(Address)
-- variable addr:integer;
-- variable first:boolean:=true;
-- begin
--    if(first) then
--       -- ADDI X9, X9, 1 -- this we changed after the OH tonight
--       imemBytes(3) <= "10010001";
--       imemBytes(2) <= "00000000";
--       imemBytes(1) <= "00000101";
--       imemBytes(0) <= "00101001";
--        --ADD  X10,X9,X11
 
--       imemBytes(7) <= "10001011";
--       imemBytes(6) <= "00001011";
--       imemBytes(5) <= "00000001";
--       imemBytes(4) <= "00101010";

--       -- STUR X10, [X11,0]  
--       imemBytes(11) <= "11111000";
--       imemBytes(10) <= "00000000";
--       imemBytes(9)  <= "00000001"; 
--       imemBytes(8)  <= "01101010"; 
      
--       -- LDUR X12, [X11, 0] 

--       imemBytes(15) <= "11111000";
--       imemBytes(14) <= "01000000";
--       imemBytes(13) <= "00000001";
--       imemBytes(12) <= "01101100";

--       -- CBZ X9, 2 --> 4  
--       imemBytes(19) <= "10110100";
--       imemBytes(18) <= "00000000";
--       imemBytes(17) <= "00000001";
--       imemBytes(16) <= "00001001";

--       -- B 3  
--       imemBytes(23) <= "00010100";
--       imemBytes(22) <= "00000000";
--       imemBytes(21) <= "00000000";
--       imemBytes(20) <= "00000011";

--       -- ADD X9, X10, X11
--       imemBytes(27) <= "10001011";
--       imemBytes(26) <= "00001011";
--       imemBytes(25) <= "00000001";
--       imemBytes(24) <= "01001001";

--       -- ADDI  X9, X9, 1                  
--       imemBytes(35) <= "10010001";   
--       imemBytes(34) <= "00000000";   
--       imemBytes(33) <= "00000101";   
--       imemBytes(32) <= "00101001";   
                                     
--       -- ADD   X21, X10, X9          
--       imemBytes(39) <= "10001011";   
--       imemBytes(38) <= "00001001";   
--       imemBytes(37) <= "00000001";   
--       imemBytes(36) <= "01010101";   







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

