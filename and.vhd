LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.all;
ENTITY MY_AND IS
PORT(
src1,src2:IN std_logic_vector(15 DOWNTO 0);
dest: OUT std_logic_vector(15 DOWNTO 0);
carry_flag,zero_flag,negative_flag: OUT std_logic
);
END MY_AND;

ARCHITECTURE arch_MY_AND OF MY_AND IS
SIGNAL temp_result : std_logic_vector(15 DOWNTO 0); 
BEGIN
temp_result <= src1 AND src2;
dest <= std_logic_vector(temp_result(15 DOWNTO 0));
carry_flag <= '0';
zero_flag <= '1' WHEN to_unsigned(0, temp_result'length) = unsigned(temp_result) ELSE '0';
negative_flag <= temp_result(15);

END arch_MY_AND;