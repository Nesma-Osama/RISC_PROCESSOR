library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;


entity instruction_memory is
port(clk : in std_logic;
we : in std_logic;
write_instruction: in std_logic_vector(15 downto 0);
PC : in std_logic_vector(15 downto 0);
instruction : out std_logic_vector(15 downto 0);
im0:out std_logic_vector(15 downto 0);
im1:out std_logic_vector(15 downto 0);
im2:out std_logic_vector(15 downto 0);
im3:out std_logic_vector(15 downto 0);
im4:out std_logic_vector(15 downto 0));
end entity;

architecture instruction_arch of instruction_memory is
    type ram_type is array(0 to 4095) of std_logic_vector(15 downto 0);
    signal ram : ram_type;
begin
process(clk)
begin
     if we='1' AND rising_edge(clk)
        then
           ram(to_integer(unsigned((pc)))) <= write_instruction; 
        end if;
end process;
instruction <= ram(to_integer(unsigned(pc))); 
im0 <= ram(0);  
im1 <= ram(1);  
im2 <= ram(2);  
im3 <= ram(3);  
im4 <= ram(4);
end instruction_arch;