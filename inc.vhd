LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.all;
ENTITY inc IS
PORT(
src1:IN std_logic_vector(15 DOWNTO 0);
dest: OUT std_logic_vector(15 DOWNTO 0);
carry_flag,zero_flag,negative_flag: OUT std_logic
);
END inc;

ARCHITECTURE arch_inc OF inc IS
SIGNAL temp_result : unsigned(16 DOWNTO 0); --akbar be bit 3shan ashof el carry
BEGIN
temp_result <= unsigned('0' & src1) +1;

dest <= std_logic_vector(temp_result(15 DOWNTO 0));
carry_flag <= temp_result(16);
zero_flag <= '1' WHEN temp_result(15 DOWNTO 0) = 0 ELSE '0';
negative_flag <= temp_result(15);
END arch_inc;