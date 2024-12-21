library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_8_3 is
    generic (
        DATA_WIDTH : positive := 8
    );
    port (
        input_0   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_1   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_2   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_3   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_4   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_5   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_6   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_7   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        selector  : in  std_logic_vector(2 downto 0);
        output    : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity mux_8_3;

architecture rtl of mux_8_3 is
begin
    with selector select
    output <= input_0 when "000",
              input_1 when "001",
              input_2 when "010",
              input_3 when "011",
              input_4 when "100",
              input_5 when "101",
              input_6 when "110",
              input_7 when "111",
              (others => 'X') when others;
end architecture rtl;