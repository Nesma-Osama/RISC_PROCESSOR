LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--selectors 00 no branch 
-- 01 zero branch
--10 negative
--11 carry
--jump 1 if will jump 0 else
-- FLAGES (0) ZERO FLAGE
-- FLAGES (1) NEAGTIVE FLAGES
--FLAGES (2) CARRY
ENTITY branch_unit 
IS PORT (
flages:in std_logic_vector(2 downto 0);
jump_sel :in std_logic_vector(1 downto 0);
jump:out std_logic
);
END ENTITY branch_unit;
ARCHITECTURE branch_unit OF branch_unit IS
BEGIN
jump<='0' WHEN jump_sel="00"
ELSE flages(0) WHEN jump_sel="01"
ELSE flages(1) WHEN jump_sel="10"
ELSE flages(2);
END branch_unit;