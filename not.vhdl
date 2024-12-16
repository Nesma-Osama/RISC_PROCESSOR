LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.all;
ENTITY MY_NOT IS
PORT(
src1:IN std_logic_vector(15 DOWNTO 0);
dest: OUT std_logic_vector(15 DOWNTO 0);
carry_flag,zero_flag,negative_flag,overflow_flag: OUT std_logic
);
END MY_NOT;

ARCHITECTURE arch_MY_NOT OF MY_NOT IS
SIGNAL temp_result : std_logic_vector(15 DOWNTO 0); 
BEGIN
temp_result <= NOT src1;
dest <= std_logic_vector(temp_result(15 DOWNTO 0));
carry_flag <= '0';
zero_flag <= '1' WHEN to_unsigned(0, temp_result'length) = unsigned(temp_result) ELSE '0';
negative_flag <= temp_result(15);
overflow_flag <= '0';
END arch_MY_NOT;