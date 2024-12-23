LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.all;

entity top_module_fifth_stage is 
port(
clk: in std_logic;
Rs,alu_result,mem_res : in std_logic_vector(15 downto 0);
Rd : in std_logic_vector(2 downto 0);
write_back,memory_to_reg,io_write,memory_read,mem_src,ret :in std_logic;
write_back_out :out std_logic;
rd_Address : out std_logic_vector(2 downto 0);
output_port,write_back_data :out std_logic_vector(15 downto 0)

);
end entity ;

architecture top_module_fifth_stage_arch of top_module_fifth_stage is
component mux_2_1 is
    generic (
        DATA_WIDTH : positive := 16
    );
    port (
        input_0   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_1   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        selector  : in  std_logic;
        output    : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end component mux_2_1;
begin
rd_Address<=rd;
write_back_out<=write_back;
u0:mux_2_1 port map(alu_result,mem_res,memory_to_reg,write_back_data);
output_port<=rs when io_write='1';
end top_module_fifth_stage_arch;