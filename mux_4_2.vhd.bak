library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4_2 is
    generic (
        DATA_WIDTH : positive := 8
    );
    port (
        input_0   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_1   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_2   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_3   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        selector  : in  std_logic_vector(1 downto 0);
        output    : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity mux_4_2;

architecture rtl of mux_4_2 is
begin
    with selector select
    output <= input_0 when "00",
              input_1 when "01",
              input_2 when "10",
              input_3 when "11",
              (others => 'X') when others;
end architecture rtl;