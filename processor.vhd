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
signal ex_mem_result,mem_wb_result,sp_in: std_logic_vector(15 downto 0); -- input to third stage
signal ex_mem_write_back,mem_write_back,ex_mem_push: std_logic;-- input to third stage
signal ex_mem_Rd,mem_wb_rd:  std_logic_vector(2 downto 0);-- input to third stage
signal sp_ex,next_pc_out_ex,ex_result_ex,Rs_out_ex,Rt_out_ex: std_logic_vector(15 downto 0);-- output of third stage
signal control_unit_signals_out_ex: std_logic_vector(15 downto 0);-- output of third stage
signal Rd_address_out_ex :  std_logic_vector(2 downto 0);-- output of third stage
signal exception_ex :  std_logic;-- output of third stage
signal ex_m_out : std_logic_vector(98 downto 0); -- out ex_mem_register
signal e_m_input :std_logic_Vector(98 downto 0);
signal mem_res_me,rs_out_me,alu_result_me : std_logic_vector(15 downto 0);-- output of forth stage
signal rd_address_out_me : std_logic_vector(2 downto 0);-- output of forth stage
signal write_back_me,memory_to_reg_me,io_write_me,memory_read_me,mem_src_me,ret_me : std_logic;-- output of forth stage
signal mem_w_input,mem_w_output :std_logic_Vector(56 downto 0); --- signals to memory_write back register
signal write_back_out_wb : std_logic;-- output of fifth stage
signal rd_Address_wb :  std_logic_vector(2 downto 0);-- output of fifth stage
signal output_port,write_back_data_wb : std_logic_vector(15 downto 0);-- output of fifth stage
begin
-- first stage
--//hlt,int interrupt pc_write,exception , index done 
-- flash fd done
--memory_src done =>execute
-- index done from 
--ret_me ,data_memory from memory
--
m1:top_module_first_stage port map(clk,pc_write,exception_ex,memory_src,index,interrupt,'0',hlt,reset_signal,control_unit_signals_out_ex(4),jump_dmem,data_memory,Rs_out_ex,(others=>'0'), next_pc_out,instruction);
-- input to fetch decode
fd_input<=(input_port & next_pc_out& instruction);-- input pc instruction
-- fetch decode
fd:sixteen_bit_register generic map(48) port map(clk,flash_fd,'1',fd_input,fd_output);
--------------------------------------------------
--decode_rd_data_in,rd_Address_wb,write_back_out_wb from memory done
--decode_memory_read_in=> from decode execute reg
decode_nextpc_in<=fd_output(31 downto 16);
decode_instruction_input<=fd_output(15 downto 0);
decode_input_port<=fd_output(47 downto 32);
--decode_rd_data_in =>from wb stage, decode_Rd_address_out=> wb stage,decode_write_back_in=>wb stage
--decode_memory_read_in from execution
--decode_memory_flush  => oring 
hlt<=decode_control_unit_signals_out(2);
interrupt<=decode_control_unit_signals_out(1);
m2:top_module_second_stage port map(clk,decode_nextpc_in,decode_input_port,decode_instruction_input,decode_rd_data_in,rd_Address_wb,decode_write_back_in,decode_memory_read_in,decode_memory_flush,decode_next_pc_out,decode_input_port_out,decode_rs_out,decode_rt_out,decode_rs_address_out,decode_rt_address_out,decode_Rd_address_out,decode_control_unit_signals_out,pc_write,index);
de_input<=(decode_rs_address_out(2 downto 0)&decode_rt_address_out(2 downto 0)&decode_Rd_address_out(2 downto 0)& decode_rs_out(15 downto 0) & decode_rt_out(15 downto 0)& decode_instruction_input(15 downto 0)& decode_input_port_out(15 downto 0)& decode_next_pc_out(15 downto 0) & decode_control_unit_signals_out(25 downto 0));
de:sixteen_bit_register generic map(115) port map(clk,'0','1',de_input,de_out);
---------------------------------------------------------
decode_memory_read_in<=de_out(10);
ex:top_module_third_stage port map(clk , de_out(41 downto 26),de_out(57 downto 42),de_out(105 downto 90),de_out(89 downto 74),de_out(73 downto 58),ex_mem_result,mem_wb_result,sp_in,ex_mem_write_back,mem_write_back,ex_mem_push,de_out(114 downto 112),de_out(111 downto 109),de_out(108 downto 106),ex_mem_Rd,mem_wb_rd,de_out(25 downto 0),
sp_ex,next_pc_out_ex,ex_result_ex,Rs_out_ex,Rt_out_ex,control_unit_signals_out_ex,Rd_address_out_ex,exception_ex);

---25:0 control unit ,26:41 next_pc,42:57 input_port,58:73 immediate,rt 74:89 ,rs 90:105,rd 106:108,rt 109:111 ,rs 112:114
e_m_input<=(next_pc_out_ex(15 downto 0)&Rs_out_ex(15 downto 0)&Rt_out_ex(15 downto 0)& ex_result_ex(15 downto 0) & sp_ex(15 downto 0)& Rd_address_out_ex(2 downto 0)& control_unit_signals_out_ex(15 downto 0));
e_m:sixteen_bit_register generic map(99) port map(clk,'0','1',e_m_input,ex_m_out);
memory_src<=control_unit_signals_out_ex(12);
ex_mem_result<=ex_m_out(50 downto 35);-- alu res
ex_mem_write_back<=ex_m_out(9);-- execution memory write back
ex_mem_push<=ex_m_out(14);
sp_in<=ex_m_out(34 downto 19);
----------------------------------------------------------------------
me:top_module_forth_stage port map(clk,ex_m_out(98 downto 83),ex_m_out(82 downto 67),ex_m_out(66 downto 51),ex_m_out(50 downto 35),ex_m_out(34 downto 19), ex_m_out(18 downto 16),ex_m_out(15 downto 0),
mem_res_me,rs_out_me,alu_result_me,rd_address_out_me,write_back_me,memory_to_reg_me,io_write_me,memory_read_me,mem_src_me,ret_me );
mem_w_input<=(rs_out_me(15 downto 0)&alu_result_me(15 downto 0)&mem_res_me(15 downto 0)& rd_address_out_me(2 downto 0) & write_back_me& memory_to_reg_me& io_write_me&memory_read_me&mem_src_me&ret_me);
mem_w:sixteen_bit_register generic map(57) port map(clk,'0','1',mem_w_input,mem_w_output);
jump_dmem<= '1' when ret_me='1' else '0';
data_memory<=mem_res_me;
------------------------------------------------------------------------
wb:top_module_fifth_stage port map(clk,mem_w_output(56 downto 41) ,mem_w_output(40 downto 25),mem_w_output(24 downto 9),mem_w_output(8 downto 6),mem_w_output(5),mem_w_output(4),mem_w_output(3),mem_w_output(2),mem_w_output(1),mem_w_output(0),
write_back_out_wb,rd_Address_wb,output_port,write_back_data_wb);
decode_rd_data_in<=write_back_data_wb;
decode_write_back_in<=write_back_out_wb;
mem_wb_result<=write_back_data_wb;
mem_write_back<=decode_write_back_in;
-------------flush decode 
decode_memory_flush<= '1' when ((decode_control_unit_signals_out(5)='1')or control_unit_signals_out_ex(4)='1' or exception_ex='1' or ex_m_out(6)='1'or mem_w_output(0)='1') else '0';-- when jump and ret from ex or mem and also for execption
flash_fd<='1' when (hlt='1' or decode_memory_flush='1' )else '0' ;

end processor;