library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity top_module_forth_stage is
port(
clk: in std_logic;
next_pc,Rs,RT,ex_result,SP : in std_logic_vector(15 downto 0);
Rd : in std_logic_vector(2 downto 0);
control_unit_signals:in std_logic_vector(15 downto 0);
mem_res,rs_out,alu_result :out std_logic_vector(15 downto 0);
rd_address_out :out std_logic_vector(2 downto 0);
write_back,memory_to_reg,io_write,memory_read,mem_src,ret :out std_logic
);
end entity ;

architecture top_module_forth_stage_arch of top_module_forth_stage is 
component data_memory is
port(
clk : in std_logic;
we : std_logic; 
re : std_logic;
write_address : in std_logic_vector(15 downto 0);
read_address : in std_logic_vector(15 downto 0);
write_data : in std_logic_vector(15 downto 0);
read_data: out std_logic_vector(15 downto 0)
);
end component;
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
signal memory_address ,memory_data:std_logic_vector(15 downto 0);

begin 
rs_out<=rs;
rd_address_out<=rd;
alu_result<=ex_result;
write_back<=control_unit_signals(9);
memory_to_reg<=control_unit_signals(0);
io_write<=control_unit_signals(8);
memory_read<=control_unit_signals(10);
mem_src<=control_unit_signals(12);
ret<=control_unit_signals(6);
u0:mux_2_1 port map(ex_result,sp,control_unit_signals(12),memory_address);
u1:mux_2_1 port map(rt,next_pc,control_unit_signals(13),memory_data);
u2:data_memory port map(clk,control_unit_signals(11),control_unit_signals(10),memory_Address,memory_Address,memory_Data,mem_res);
end top_module_forth_stage_arch;