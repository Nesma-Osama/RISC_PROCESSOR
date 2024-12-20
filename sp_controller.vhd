library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sp_controller is
    port (
        clk     : in  std_logic;  
        sp      : in  std_logic_vector(15 downto 0); 
        pop     : in  std_logic;
        push    : in  std_logic; 
        so      : out std_logic_vector(15 downto 0) 
    );
end entity sp_controller;

architecture behavioral of sp_controller is
    signal sp_unsigned : unsigned(15 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            sp_unsigned <= unsigned(sp);
            if push = '1' then
                sp_unsigned <= sp_unsigned + 2;
            elsif pop = '1' then
                sp_unsigned <= sp_unsigned - 2;
            end if;
            
            so <= std_logic_vector(sp_unsigned);
        end if;
    end process;
end architecture behavioral;