library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sixteen_bit_register is
    Port ( 
        clk     : in STD_LOGIC;                     
        reset   : in STD_LOGIC;                     
        enable  : in STD_LOGIC;                     
        data_in : in STD_LOGIC_VECTOR(15 downto 0); 
        data_out: out STD_LOGIC_VECTOR(15 downto 0) 
    );
end sixteen_bit_register;

architecture Behavioral of sixteen_bit_register is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                data_out <= (others => '0');
            elsif enable = '1' then
                data_out <= data_in;
            end if;
        end if;
    end process;
end Behavioral;