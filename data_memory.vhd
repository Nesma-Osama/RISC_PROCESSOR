library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
port(
clk : in std_logic;
we : std_logic; 
re : std_logic;
write_address : in std_logic_vector(15 downto 0);
read_address : in std_logic_vector(15 downto 0);
write_data : in std_logic_vector(15 downto 0);
read_data: out std_logic_vector(15 downto 0)
);
end entity;

architecture data_memory_arch of data_memory is
TYPE ram_type IS ARRAY(0 TO 4095) of std_logic_vector(15 DOWNTO 0);
SIGNAL ram : ram_type ;
begin
process(clk)begin
if we ='1' then
ram(to_integer(unsigned((write_address)))) <= write_data;
end if ;
if re='1' then
read_data <= ram(to_integer(unsigned((read_address))));
end if;
end process;
end data_memory_arch;