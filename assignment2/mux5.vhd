library ieee;
use ieee.std_logic_1164.all;


entity MUX5 is -- Two by one mux with 5 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(4 downto 0)
);
end MUX5;

architecture rtl of MUX5 is
begin
    output <= in0 when sel = '0' else in1;
end rtl;