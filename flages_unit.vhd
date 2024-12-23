library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
-- add sub inc 3flages
--not and --2 flages zero negative
--jc jn jz  stc any one of them

entity flages_unit is port(
alu_flages,ccr_flages:in std_logic_vector(2 downto 0);
selector:in std_logic_vector(1 downto 0);--00 no change , 01 
alu_operation:in std_logic;
branch_index:in std_logic_vector(1 downto 0);
flages_out:out std_logic_vector(2 downto 0)
);
end entity;

architecture flages_unit of flages_unit is 

begin
--------------zero flage
flages_out(0)<=ccr_flages(0) when selector="00"
else alu_flages(0) when selector ="10"
else  '0' when selector="11" and branch_index="01" and ccr_flages(0)='1'
else  ccr_flages(0) ;
---------------negative flage
flages_out(1)<=ccr_flages(1) when selector="00"
else alu_flages(1) when selector ="10"
else  '0' when selector="11" and branch_index="10"and ccr_flages(1)='1'
else  ccr_flages(1) ;

-----------------------------carry
flages_out(2)<=ccr_flages(2) when selector="00"
else '1' when selector="01"
else alu_flages(2) when selector ="10" and alu_operation='1'
else ccr_flages(2) when selector ="10" and alu_operation='0'
else  '0' when selector="11" and branch_index="11" and ccr_flages(2)='1'
else  ccr_flages(2) ;

end flages_unit;
