library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity top_module_third_stage is
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
end entity ;

architecture top_module_third_stage_arch of top_module_third_stage is
component ALU IS
PORT(
src1,src2:IN std_logic_vector(15 DOWNTO 0);
dest: OUT std_logic_vector(15 DOWNTO 0);
sel: IN std_logic_vector(2 DOWNTO 0); 
carry_flag,zero_flag,negative_flag: OUT std_logic
);
END component;
component sp_controller is
    port (
        sp      : in  std_logic_vector(15 downto 0); 
        pop     : in  std_logic;
        push    : in  std_logic; 
        so      : out std_logic_vector(15 downto 0) 
    );
end component ;
component  forwarding_unit IS 
PORT(
    RS, RT, EX_M_RD, M_WB_RD: IN STD_LOGIC_VECTOR(2 DOWNTO 0);  -- Register addresses
    EX_M_WB, M_WB_WB: IN STD_LOGIC;                              -- Control signals indicating write-back actions
    FA, FB: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)                       -- Forwarding signals for RS and RT
);
END component forwarding_unit;

component  mux_4_2 is
    generic (
        DATA_WIDTH : positive := 16
    );
    port (
        input_0   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_1   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_2   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        input_3   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        selector  : in  std_logic_vector(1 downto 0);
        output    : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end component ;

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
end component ;

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
component flages_unit is port(
alu_flages,ccr_flages:in std_logic_vector(2 downto 0);
selector:in std_logic_vector(1 downto 0);--00 no change , 01 
alu_operation:in std_logic;
branch_index:in std_logic_vector(1 downto 0);
flages_out:out std_logic_vector(2 downto 0)
);
end component;
component branch_unit 
IS PORT (
flages:in std_logic_vector(2 downto 0);
jump_sel :in std_logic_vector(1 downto 0);
jump:out std_logic
);
END component;

signal fa ,fb: std_logic_vector(1 downto 0);
signal newrs:std_logic_vector(15 downto 0);
signal newrt,alu_or_newrt:std_logic_vector(15 downto 0);
signal second_alu_input,alu_output: std_logic_vector(15 downto 0);
signal flags,ccr_flages,new_flages,sel : std_logic_vector(2 downto 0);
signal new_sp :std_logic_vector(15 downto 0);
signal alu_operation:std_logic;
signal branch_ex:std_logic;
begin
rd_Address_out<=rd_address_in;
next_pc_out<=next_pc_input;
rs_out<=rs;
rt_out<=rt;
sel<=control_unit_signals_in(18)&control_unit_signals_in(21 downto 20);
u0:forwarding_unit port map(RS_address,Rt_address,ex_mem_Rd,mem_wb_rd,ex_mem_write_back,mem_write_back,fa,fb);
u1:mux_4_2 port map(rs,ex_mem_result,mem_wb_reslut,(others=>'0'),fa,newrs);
u2:mux_4_2 port map(rt,ex_mem_result,mem_wb_reslut,(others=>'0'),fb,newrt);
u3:mux_2_1 port map(newrt,immediate,control_unit_signals_in(19),second_alu_input);
u4:ALU port map(newrs,second_alu_input,alu_output,sel,flags(2),flags(0),flags(1));
u5:mux_2_1 port map (alu_output,second_alu_input,control_unit_signals_in(22),alu_or_newrt);
u6:mux_2_1 port map (alu_or_newrt,input_port,control_unit_signals_in(7),ex_result);
u7:sixteen_bit_register port map(clk,'0','1',new_sp,sp);
u8:sp_controller port map(sp_in,control_unit_signals_in(24),ex_mem_push,new_sp);
u9: sixteen_bit_register generic map(3) port map(clk,'0','1',new_flages,ccr_flages);
u10:flages_unit port map (flags,ccr_flages,control_unit_signals_in(17 downto 16 ),alu_operation,control_unit_signals_in(15 downto 14),new_flages);
u11:branch_unit port map(ccr_flages,control_unit_signals_in(15 downto 14),branch_ex);
exception <= '1' when( unsigned(alu_output) > to_unsigned(4095, alu_output'length) or unsigned(new_sp)>to_unsigned(4095, new_sp'length))and(control_unit_signals_in(10)='1'or control_unit_signals_in(11)='1') else '0';
control_unit_signals_out<=(others=>'0') when (unsigned(alu_output) > to_unsigned(4095, alu_output'length) or unsigned(new_sp)>to_unsigned(4095, new_sp'length))and(control_unit_signals_in(10)='1'or control_unit_signals_in(11)='1') else 
control_unit_signals_in(25)&control_unit_signals_in(23)&control_unit_signals_in(13 downto 0) ;
control_unit_signals_out(4)<= '1' when control_unit_signals_in(4)='1' or branch_ex='1' else '0';
alu_operation<='0' when sel="001" or sel="010" else '1';
end top_module_third_stage_arch;
