
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity top_module_second_stage is
port(
clk:in std_logic ;
next_pc : in std_logic_vector(15 downto 0);
input_port : in std_logic_vector(15 downto 0);
instruction : in std_logic_vector(15 downto 0);
RD_data:in std_logic_vector(15 downto 0) ;
Rd_address_write_back : in std_logic_vector(2 downto 0);
write_back : in std_logic;
memory_read:in std_logic;
decode_memory_flush:in std_logic;
next_pc_out,input_port_out,RS,RT:out std_logic_vector(15 downto 0);---
RS_address,Rt_address,Rd_address: out std_logic_vector(2 downto 0);---
control_unit_signals : out std_logic_vector(25 downto 0);
pc_write : out std_logic 
);
end entity ;

architecture top_module_second_stage_arch of top_module_second_stage is 
COMPONENT reg_file is
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
end COMPONENT;

COMPONENT control_unit is 
port(
opcode :in std_logic_vector(4 downto 0);
output_signals: out std_logic_vector(27 downto 0)
);
end component ;

component hazard_detection_unit IS
    PORT (
        rs, rt, rd : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Register source and destination
        mem_read   : IN STD_LOGIC;                    -- ID/EX.MEMREAD
        enable     : IN STD_LOGIC;                    -- Enable (0: no hazard check)
        one_two    : IN STD_LOGIC;                    -- 0: check `rs` only, 1: check both `rs` and `rt`
        stall      : OUT STD_LOGIC                    -- Stall output (1: stall, 0: no stall)
    );
END component hazard_detection_unit;
signal control_unit_output : std_logic_vector(27 downto 0);
signal stall :std_logic ;
begin
u0 : reg_file PORT MAP(clk,write_back,Rd_address_write_back,instruction(10 downto 8),instruction(7 downto 5),RD_data,RS,RT);
u1 : control_unit port map(instruction(15 downto 11),control_unit_output);
u2: hazard_detection_unit port map (instruction(10 downto 8),instruction(7 downto 5), Rd_address_write_back,memory_read,control_unit_output(18),control_unit_output(19),stall);
control_unit_signals<=(others=>'0') when decode_memory_flush='1' else control_unit_output(27 downto 20)& control_unit_output(17 downto 0);
control_unit_signals(5)<=control_unit_output(5);
input_port_out<=input_port;
next_pc_out<=next_pc;
pc_write<=not stall;
RS_address<=instruction(10 downto 8);
Rt_address<=instruction(7 downto 5);
Rd_address<=instruction(4 downto 2);

end top_module_second_stage_arch;