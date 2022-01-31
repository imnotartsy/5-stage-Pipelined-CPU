-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;

-- entity IMEM is
-- -- The instruction memory is a byte addressable, big-endian, read-only memory
-- -- Reads occur continuously
-- -- HINT: Use the provided dmem.vhd as a starting point
-- generic(NUM_BYTES : integer := 128);
-- -- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
-- port(
--      Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
--      ReadData : out STD_LOGIC_VECTOR(31 downto 0)
-- );
-- end IMEM;



-- architecture rtl of IMEM is
--      type memArray is array (NUM_BYTES downto 0) of std_logic_vector(7 downto 0);
--      signal mem : memArray := (0 => "00000000",
--                                1 => "11111111",
--                                2 => "10101010",
--                                3 => "01010101",
--                                others => "00000000");
-- begin

--      -- big endian
--      ReadData(31 downto 24) <= mem(to_integer(unsigned(Address)));
--      ReadData(23 downto 16) <= mem(to_integer(unsigned(Address)) + 1);
--      ReadData(15 downto 8) <= mem(to_integer(unsigned(Address)) + 2);
--      ReadData(7 downto 0) <= mem(to_integer(unsigned(Address)) + 3);
     
-- end rtl;