library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sp_controller is
    port ( 
        sp      : in  std_logic_vector(15 downto 0); 
        pop     : in  std_logic;
        push    : in  std_logic; 
        so      : out std_logic_vector(15 downto 0) 
    );
end entity sp_controller;

architecture behavioral of sp_controller is
    signal sp_unsigned : unsigned(15 downto 0);
begin

sp_unsigned <= unsigned(sp)when (push='0' and pop ='0')or (push='1' and pop ='1')else
 sp_unsigned - 1 when push = '1' and pop='0' else 
sp_unsigned + 1 when   pop = '1' and push ='0'  ;           

so <= std_logic_vector(sp_unsigned);
 
end architecture behavioral;