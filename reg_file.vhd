library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is
port(
clk : in std_logic;
we : std_logic; 
rd_address : in std_logic_vector(2 downto 0);
rs_address : in std_logic_vector(2 downto 0);
rt_address : in std_logic_vector(2 downto 0);
write_data : in std_logic_vector(15 downto 0);
rs: out std_logic_vector(15 downto 0);
rt: out std_logic_vector(15 downto 0)

);
end entity;

architecture reg_file_arch of reg_file is
TYPE ram_type IS ARRAY(0 TO 7) of std_logic_vector(15 DOWNTO 0);
SIGNAL ram : ram_type ;
begin
process(clk)begin
if we ='1' then
ram(to_integer(unsigned((rd_address)))) <= write_data;
end if ;
end process;
rs <= ram(to_integer(unsigned((rs_address))));
rt <= ram(to_integer(unsigned((rt_address))));
end reg_file_arch;
