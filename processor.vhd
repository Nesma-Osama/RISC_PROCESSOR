LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.all;
entity processor is port (
input_port :in std_logic_vector (15 downto 0);
reset_signal:in std_logic;
clk :in std_logic;
out_port:out std_logic_vector(15 downto 0)
);
end processor;
architecture processor of processor is 
--////first stage 
component top_module_first_stage is
    Port ( 
        clk     : in STD_LOGIC;                                
        pc_write  : in STD_LOGIC;                     
	exception, memory_src,index, interrupt , we: in STD_LOGIC;
	hlt : in STD_LOGIC;
	reset : in STD_LOGIC;
	jump_rs, jump_dmem : in STD_LOGIC;
	data_memory,Rs,write_instruction: in STD_LOGIC_VECTOR(15 downto 0) ;
        next_pc_out,instruction: out STD_LOGIC_VECTOR(15 downto 0) 
    );
end component;
----------------------------------------
component top_module_second_stage is
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
pc_write : out std_logic ;
index:out std_logic
);
end component ;
--------------------------------------------------
component top_module_third_stage is
port(
clk:in std_logic;
next_pc_input,input_port,RS,RT,immediate,ex_mem_result,mem_wb_reslut,sp_in:in std_logic_vector(15 downto 0);---
ex_mem_write_back,mem_write_back,ex_mem_push: in std_logic;
RS_address,Rt_address,Rd_address_in,ex_mem_Rd,mem_wb_rd: in std_logic_vector(2 downto 0);---
control_unit_signals_in : in std_logic_vector(25 downto 0);--- without el flush
sp,next_pc_out,ex_result,Rs_out,Rt_out:out std_logic_vector(15 downto 0);
control_unit_signals_out:out std_logic_vector(15 downto 0);
Rd_address_out : out std_logic_vector(2 downto 0);
exception : out std_logic
);
end component ;

-------------------------------------------------
component top_module_forth_stage is
port(
clk: in std_logic;
next_pc,Rs,RT,ex_result,SP : in std_logic_vector(15 downto 0);
Rd : in std_logic_vector(2 downto 0);
control_unit_signals:in std_logic_vector(15 downto 0);
mem_res,rs_out,alu_result :out std_logic_vector(15 downto 0);
rd_address_out :out std_logic_vector(2 downto 0);
write_back,memory_to_reg,io_write,memory_read,mem_src,ret :out std_logic
);
end component ;
---------------------------------------------
component top_module_fifth_stage is 
port(
clk: in std_logic;
Rs,alu_result,mem_res : in std_logic_vector(15 downto 0);
Rd : in std_logic_vector(2 downto 0);
write_back,memory_to_reg,io_write,memory_read,mem_src,ret :in std_logic;
write_back_out :out std_logic;
rd_Address : out std_logic_vector(2 downto 0);
output_port,write_back_data :out std_logic_vector(15 downto 0)

);
end component ;
--------------------------------------------------
component sixteen_bit_register is
generic(n:integer :=16);
    Port ( 
        clk     : in STD_LOGIC;                     
        reset   : in STD_LOGIC;                     
        enable  : in STD_LOGIC;                     
        data_in : in STD_LOGIC_VECTOR(n-1 downto 0); 
        data_out: out STD_LOGIC_VECTOR(n-1 downto 0) 
    );
end component;
------------------------------------
signal pc_write ,exception,memory_src,index,hlt,interrupt,jump_rs,jump_dmem,flash_fd:std_logic;
signal data_memory,Rs,write_instruction, next_pc_out,instruction,decode_instruction_input,decode_input_port,decode_rd_data_in,decode_nextpc_in:std_logic_vector(15 downto 0);
signal decode_Rd_address_write_back,decode_Rd_address_out,decode_rt_address_out,decode_rs_address_out:std_logic_vector(2 downto 0);
signal decode_write_back_in,decode_memory_read_in,decode_memory_flush:std_logic;
signal fd_input,fd_output:std_logic_vector(47 downto 0);
signal decode_next_pc_out,decode_input_port_out,decode_rs_out,decode_rt_out:std_logic_vector(15 downto 0);
signal decode_control_unit_signals_out:std_logic_vector(25 downto 0);
signal de_input,de_out:std_logic_vector(114 downto 0);
begin
-- first stage
--//hlt,int interrupt pc_write done 
-- flash fd done
m1:top_module_first_stage port map(clk,pc_write,exception,memory_src,index,interrupt,'0',hlt,reset_signal,jump_rs,jump_dmem,data_memory,Rs,(others=>'0'), next_pc_out,instruction);
-- input to fetch decode
fd_input<=(input_port & next_pc_out& instruction);-- input pc instruction
-- fetch decode
fd:sixteen_bit_register generic map(48) port map(clk,flash_fd,'1',fd_input,fd_output);
--------------------------------------------------
decode_nextpc_in<=fd_output(31 downto 16);
decode_instruction_input<=fd_output(15 downto 0);
decode_input_port<=fd_output(47 downto 32);
--decode_rd_data_in =>from wb stage, decode_Rd_address_out=> wb stage,decode_write_back_in=>wb stage
--decode_memory_read_in from execution
--decode_memory_flush  => oring 
hlt<=decode_control_unit_signals_out(2);
interrupt<=decode_control_unit_signals_out(1);
flash_fd<=decode_control_unit_signals_out(5);
m2:top_module_second_stage port map(clk,decode_nextpc_in,decode_input_port,decode_instruction_input,decode_rd_data_in,decode_Rd_address_out,decode_write_back_in,decode_memory_read_in,decode_memory_flush,decode_next_pc_out,decode_input_port_out,decode_rs_out,decode_rt_out,decode_rs_address_out,decode_rt_address_out,decode_Rd_address_out,decode_control_unit_signals_out,pc_write,index);
de_input<=(decode_rs_address_out(2 downto 0)&decode_rt_address_out(2 downto 0)&decode_Rd_address_out(2 downto 0)& decode_rs_out(15 downto 0) & decode_rt_out(15 downto 0)& decode_instruction_input(15 downto 0)& decode_input_port_out(15 downto 0)& decode_next_pc_out(15 downto 0) & decode_control_unit_signals_out(25 downto 0));
de:sixteen_bit_register generic map(115) port map(clk,'0','1',de_input,de_out);
end processor;

