library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity mux_2_1 is
    generic (
        DATA_WIDTH : positive := 8
    );
    port (
        input_0   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_1   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        selector  : in  std_logic;
        output    : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity mux_2_1;

architecture rtl of mux_2_1 is
begin
    output <= input_0 when selector = '0' else input_1;
end architecture rtl;