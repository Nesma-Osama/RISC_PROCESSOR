LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ALU IS
PORT(
src1,src2:IN std_logic_vector(15 DOWNTO 0);
dest: OUT std_logic_vector(15 DOWNTO 0);
sel: IN std_logic_vector(2 DOWNTO 0); 
--msh m7tag gher 2 selector lines, 3shan Add we IAdd we SUB kda kda hystkhdmo el adder, bs simply hhot muxat
--abl el alu tkhtar maben el register wel immediate wel complement bta3 el register
-- 00 : addition
-- 01 : not
-- 10 : and
-- 11 : inc // mmkn tt7at gowa el addition, bs bema en kda kda hhtag 2 selector lines, fa awafar el mux ely hytzwd bara 3shan akhtar 1
carry_flag,zero_flag,negative_flag: OUT std_logic
);
END ALU;


ARCHITECTURE arch_ALU OF ALU IS
	COMPONENT ADDER IS
	PORT(
	src1,src2:IN std_logic_vector(15 DOWNTO 0);
	dest: OUT std_logic_vector(15 DOWNTO 0);
	carry_flag,zero_flag,negative_flag: OUT std_logic
	);
	END COMPONENT;

	COMPONENT SUBTRACT IS
	PORT(
	src1,src2:IN std_logic_vector(15 DOWNTO 0);
	dest: OUT std_logic_vector(15 DOWNTO 0);
	carry_flag,zero_flag,negative_flag: OUT std_logic
	);
	END COMPONENT;

	COMPONENT MY_NOT IS 
	PORT(
	src1:IN std_logic_vector(15 DOWNTO 0);
	dest: OUT std_logic_vector(15 DOWNTO 0);
	carry_flag,zero_flag,negative_flag: OUT std_logic
	);
	END COMPONENT;



	COMPONENT MY_AND IS 
	PORT(
	src1,src2:IN std_logic_vector(15 DOWNTO 0);
	dest: OUT std_logic_vector(15 DOWNTO 0);
	carry_flag,zero_flag,negative_flag: OUT std_logic
	);
	END COMPONENT;

	COMPONENT inc IS 
	PORT(
	src1:IN std_logic_vector(15 DOWNTO 0);
	dest: OUT std_logic_vector(15 DOWNTO 0);
	carry_flag,zero_flag,negative_flag: OUT std_logic);
	END COMPONENT;
	SIGNAL addition,not_result,and_result,inc_result,subtract_result: std_logic_vector(15 DOWNTO 0);
SIGNAL addition_flags,not_flags,and_flags,inc_flags,subtract_flags: std_logic_vector(2 DOWNTO 0);

BEGIN

u0:  ADDER PORT MAP(src1,src2, addition , addition_flags(0), addition_flags(1),addition_flags(2));
u1:  MY_NOT PORT MAP(src1,not_result,not_flags(0),not_flags(1),not_flags(2));
u2:  MY_AND PORT MAP(src1,src2, and_result , and_flags(0), and_flags(1),and_flags(2));
u3:  inc PORT MAP(src1,inc_result,inc_flags(0),inc_flags(1),inc_flags(2));	
u4: SUBTRACT PORT MAP(src1,src2, subtract_result , subtract_flags(0), subtract_flags(1),subtract_flags(2));
dest<=addition WHEN sel="000"
      ELSE not_result WHEN sel="001"
	ELSE and_result WHEN sel="010"
	ELSE inc_result WHEN sel="011"
ELSE subtract_result WHEN sel = "100";



carry_flag<=addition_flags(0) WHEN sel="000"
		ELSE inc_flags(0) WHEN sel="011"
ELSE subtract_flags(0) WHEN sel="100";



zero_flag<=addition_flags(1) WHEN sel="000"
		ELSE not_flags(1) WHEN sel="001"
		ELSE and_flags(1)WHEN sel="010"
		ELSE inc_flags(1) WHEN sel="011"
 ELSE subtract_flags(1) WHEN sel="100";

negative_flag<=addition_flags(2) WHEN sel="000"
		ELSE not_flags(2) WHEN sel="001"
		ELSE and_flags(2)WHEN sel="010"
		ELSE inc_flags(2) WHEN sel="011"
ELSE subtract_flags(2) WHEN sel="100";


END arch_ALU;