
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- JUMP SIGNAL CONTAINS AND UNCONDITIONAL
--INPUTS RS,DM_DATA,IM_0,IM_1,IM_2,IM_3,IM_4,OLD_PC,PC_PLUS THEY ARE THE DISTINATION
ENTITY pc_control_unit IS PORT(
RS,DM_DATA,IM_0,IM_1,IM_2,IM_3,IM_4,PC_PLUS:IN STD_LOGIC_VECTOR(15 DOWNTO 0);
RESET,EXCEP,MEM_SRC,HLT,INT,JUMP_RS,JUMP_DMEM,INDEX:IN STD_LOGIC;
NEW_PC:OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
pc_stp:out std_logic
);
END ENTITY pc_control_unit;
ARCHITECTURE pc_control_unit OF pc_control_unit IS
BEGIN
PROCESS (RS,DM_DATA,IM_0,IM_1,IM_2,IM_3,IM_4,PC_PLUS,RESET,EXCEP,MEM_SRC,HLT,INT,JUMP_RS,JUMP_DMEM,INDEX) BEGIN
IF(RESET='1') THEN --higher priority
NEW_PC<=IM_0;
pc_stp<='0';
--------------------------------------------
ELSIF (EXCEP ='1' AND MEM_SRC='0')THEN-- Execption about memory 
NEW_PC<=IM_2;
pc_stp<='0';
-------------------------------------------
ELSIF (EXCEP ='1' AND MEM_SRC='1')THEN--Stack
NEW_PC<=IM_1;
pc_stp<='0';
----------------------------------------
ELSIF(HLT='1')THEN --hlt stop pc
pc_stp<='1';
NEW_PC<=PC_PLUS;
-----------------------------------------
ELSIF(INT ='1' AND INDEX='0')THEN
NEW_PC<=IM_3;
pc_stp<='0';
--------------------------------------------
ELSIF (INT ='1' AND INDEX='1')THEN
NEW_PC<=IM_4;
pc_stp<='0';
-------------------------------------------------
ELSIF (JUMP_RS='1')THEN--conditional and upconditional call in execution stage
pc_stp<='1';
NEW_PC<=RS;
---------------------------------------------------
ELSIF(JUMP_DMEM='1')THEN--RET RTI IN MEMORY STAGE
pc_stp<='1';
NEW_PC<=DM_DATA;
----------------------------
ELSE PC_STP<='0';
NEW_PC<=PC_PLUS;
END IF;
END PROCESS;



END pc_control_unit;