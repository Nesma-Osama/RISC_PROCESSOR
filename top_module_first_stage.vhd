
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
entity top_module_first_stage is
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
end top_module_first_stage;

architecture arch_top_module_first_stage of top_module_first_stage is
	
	SIGNAL int0,int1,int2,int3,int4,pc_plus : STD_LOGIC_VECTOR(15 downto 0);
	SIGNAL pc : STD_LOGIC_VECTOR(15 downto 0);
	SIGNAL next_pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL enable_signal : STD_LOGIC;
	SIGNAL pc_stop : STD_LOGIC;
	COMPONENT sixteen_bit_register IS 
	PORT( clk     : in STD_LOGIC;                     
        reset   : in STD_LOGIC;                     
        enable  : in STD_LOGIC;                     
        data_in : in STD_LOGIC_VECTOR(15 downto 0); 
        data_out: out STD_LOGIC_VECTOR(15 downto 0) 
	);
	END COMPONENT;


	COMPONENT instruction_memory IS 
	PORT(
	clk : in std_logic;
	we : in std_logic;
	write_instruction: in std_logic_vector(15 downto 0);
	PC : in std_logic_vector(15 downto 0);
	instruction : out std_logic_vector(15 downto 0);
	im0:out std_logic_vector(15 downto 0);
	im1:out std_logic_vector(15 downto 0);
	im2:out std_logic_vector(15 downto 0);
	im3:out std_logic_vector(15 downto 0);
	im4:out std_logic_vector(15 downto 0)
	);
	END COMPONENT;

	COMPONENT pc_control_unit IS PORT(
	RS,DM_DATA,IM_0,IM_1,IM_2,IM_3,IM_4,PC_PLUS:IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	RESET,EXCEP,MEM_SRC,HLT,INT,JUMP_RS,JUMP_DMEM,INDEX:IN STD_LOGIC;
	NEW_PC:OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	pc_stp:out std_logic
);
END COMPONENT ;



begin
   u0 : instruction_memory PORT MAP(clk,we,write_instruction,pc,instruction,int0,int1,int2,int3,int4);
   u1 : sixteen_bit_register PORT MAP (clk, '0' , enable_signal , next_pc , pc); 
   u2 : pc_control_unit PORT MAP (Rs,data_memory,int0,int1,int2,int3,int4,pc_plus
,reset,exception,memory_src,
hlt,interrupt,jump_rs,jump_dmem,index,next_pc,pc_stop );
	next_pc_out <= next_pc;
	pc_plus <= std_logic_vector(unsigned(pc) + 1);
	enable_signal <= NOT pc_stop OR pc_write;
end arch_top_module_first_stage;