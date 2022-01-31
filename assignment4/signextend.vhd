library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExtend is
port(
     x  : in  STD_LOGIC_VECTOR(31 downto 0);
     opcode : in  STD_LOGIC_VECTOR(10 downto 0);
     -- b  : in  STD_LOGIC;
     -- cb : in STD_LOGIC;
     -- alusrc : in STD_LOGIC;
     y  : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
);
end SignExtend;

architecture rtl of SignExtend is
begin
     process (x, opcode)
     begin
          if opcode(10 downto 5) = "000101" then --b
               -- signed extend
               y <= STD_LOGIC_VECTOR(resize(signed(x(25 downto 0)), y'length));

          elsif opcode(10 downto 3) = "10110100" then -- cbz
               -- signed extend
               y <= STD_LOGIC_VECTOR(resize(signed(x(23 downto 5)), y'length));

          elsif opcode(6 downto 3) = "1000" and opcode(0) = '0' then -- D Type; signed extends
               -- signed extend
               y <= STD_LOGIC_VECTOR(resize(signed(x(20 downto 12)), y'length));
               
          elsif (opcode(10) = '1') and (opcode(7 downto 5) = "100") and (opcode(2 downto 1) = "00") then -- I type
               -- signed extend
               y <= STD_LOGIC_VECTOR(resize(signed(x(21 downto 10)), y'length));
          else
               y(63 downto 32) <= "00000000000000000000000000000000";
               y(31 downto 0) <= x(31 downto 0);
          end if;

     end process;
end architecture;

