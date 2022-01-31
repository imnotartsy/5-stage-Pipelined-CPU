library ieee;
use ieee.std_logic_1164.all;

entity ShiftLeft2 is -- Shifts the input by 2 bits
port(
     x : in  STD_LOGIC_VECTOR(63 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- x << 2
);
end ShiftLeft2;

architecture rtl of ShiftLeft2 is
begin
     y(63 downto 2) <= x(61 downto 0);
     y(1 downto 0) <= "00";  

end architecture;

-- vcom -quiet -2008 shiftleft2.vhd shiftleft2_tb.vhd
-- vsim -quiet -c work.shiftleft2_tb -do "log -r /*; run 500ns; exit" -wlf shiftleft2.wlf &&  wlf2vcd shiftleft2.wlf -o shiftleft2.vcd
