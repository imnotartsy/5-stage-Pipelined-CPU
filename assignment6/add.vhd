library ieee;
use ieee.std_logic_1164.all;
-- use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ADD is
-- Adds two signed 64-bit inputs
-- output = in1 + in2
port(
     in0    : in  STD_LOGIC_VECTOR(63 downto 0);
     in1    : in  STD_LOGIC_VECTOR(63 downto 0);
     output : out STD_LOGIC_VECTOR(63 downto 0)
);
end ADD;

architecture rtl of ADD is
begin
     output <= std_logic_vector(unsigned(in0) + unsigned(in1));
end rtl;