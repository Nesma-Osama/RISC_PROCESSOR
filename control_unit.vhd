library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---memory_to_reg 0,int 1, hlt 2,call 3,unconditional_branch 4,fetch_decode_flush 5, ret 6,io_read 7,io_write 8,write_back 9
---,memory_read  10,memory_write   11,
---memory_src  12,memory_datasrc 13,conditional_branch 14: 15;
---flags_control   16:17,enable   18:19;
---alu_control 20:23
---mov 24
---push 25
---pop 26
--rti  27

entity control_unit is 
port(
opcode :in std_logic_vector(4 downto 0);
output_signals: out std_logic_vector(27 downto 0)
);
end entity ;

architecture control_unit_architecture of control_unit is 
begin
process(opcode)
begin
    if opcode = "00000" then
        output_signals <= (others => '0');

        --- NOP 
    elsif opcode = "00001" then
        output_signals <= (others => '0');
        output_signals(2) <= '1';   ---hlt
        -- HLT 
    elsif opcode = "00010" then
       -- SETC
        output_signals <= (others => '0');
        output_signals(16) <= '1';  ---flag control        
        
    elsif opcode = "00011" then
        --NOT Rdst, Rsrc1
        output_signals <= (others => '0');
        output_signals(22) <= '1'; ---right bit alu_control
        output_signals(9)  <='1';  --- write back         
        output_signals(17)<='1';   --- flag conrol
    elsif opcode = "00100" then
        -- INC Rdst, Rsrc1
        output_signals <= (others => '0');
        output_signals(22) <= '1'; ---right bit alu_control
        output_signals(23) <='1';  --- alu_control
        output_signals(9)  <='1';  --- write_back         
        output_signals(17)<='1';   --- flag_conrol
        
    elsif opcode = "00101" then
        -- OUT Rsrc1
        output_signals <= (others => '0');
        output_signals(8)<='1'; ---io_write     
    elsif opcode = "00110" then
        -- IN Rdst
        output_signals <= (others => '0');
        output_signals(7)<='1';  --- io_read
        output_signals(9)  <='1';  --- write_back 

    elsif opcode = "00111" then
        -- MOV Rdst, Rsrc1
        output_signals <= (others => '0');
        output_signals(24)<='1';   ---mov
        output_signals(9)  <='1';  --- write_back 
    elsif opcode = "01000" then
        -- ADD Rdst,Rsrc1, Rsrc2
        output_signals <= (others => '0');
        output_signals(9)  <='1';  --- write_back 
        output_signals(17)<='1';   --- flag conrol
        
    elsif opcode = "01001" then
        -- SUB Rdst, Rsrc1,Rsrc2
        output_signals <= (others => '0');
        output_signals(20)<='1';   --- alu_control second mux
        output_signals(9)  <='1';  --- write_back 
        output_signals(17)<='1';   --- flag conrol
    elsif opcode = "01010" then
        -- AND Rdst,Rsrc1, Rsrc2
        output_signals <= (others => '0');
        output_signals(23)<='1'; --- alu_control
        output_signals(9)  <='1';  --- write_back 
        output_signals(17)<='1';   --- flag conrol
    elsif opcode = "01011" then
        -- IADD Rdst,Rsrc1, Imm
        output_signals <= (others => '0');
        output_signals(21)<='1'; --- alu_control
        output_signals(9)  <='1';  --- write_back 
        output_signals(17)<='1';   --- flag conrol
        output_signals(5) <= '1';  ---fetch_decode_flush
    elsif opcode = "01100" then
        -- PUSH Rsrc1
        output_signals <= (others => '0');
        output_signals(12)<='1';   ---memory src
        output_signals(25)<='1';   --- push
        output_signals(11)<='1';   --- memroy_write
        
    elsif opcode = "01101" then
        -- POP Rdst
        output_signals <= (others => '0');
        output_signals(12)<='1';   ---memory src
 	output_signals(10)<='1';   --- memroy_read   
        output_signals(9)  <='1';  --- write_back 
	output_signals(0)  <='1';  --mem_to_reg
        output_signals(26)  <='1'; --pop 
    elsif opcode = "01110" then
        -- LDM Rdst, Imm
        output_signals <= (others => '0');
	output_signals(24)<='1';   ---mov
        output_signals(23) <='1';  --- alu_control  mov =>RT alu RT,IMM
        output_signals(9)  <='1';  --- write_back 
 	output_signals(5) <= '1';  ---fetch_decode_flush
    elsif opcode = "01111" then
       --LDD Rdst,offset(Rsrc1)
        output_signals <= (others => '0');
	output_signals(9)  <='1';  --- write_back 
        output_signals(10) <='1';   --- memroy_read  
	output_signals(0)  <='1';  --mem_to_reg
	output_signals(23) <='1';  --- alu_control  mov =>RT alu RT,IMM
	output_signals(5)  <= '1';  ---fetch_decode_flush
    elsif opcode = "10000" then
        -- STD Rsrc1,offset(Rsrc2)
        output_signals <= (others => '0');
        output_signals(11)<='1';   --- memroy_write
	output_signals(23) <='1';  --- alu_control  mov =>RT alu RT,IMM
	output_signals(5)  <= '1';  ---fetch_decode_flush

    elsif opcode = "10001" then
        -- JZ Rsrc1
        output_signals <= (others => '0');
        output_signals(14)<='1';-- conditional_branch left side 
    elsif opcode = "10010" then
        -- JN Rsrc1
        output_signals <= (others => '0');
        output_signals(15)<='1';-- conditional_branch right side 
    elsif opcode = "10011" then
        -- JC Rsrc1
        output_signals <= (others => '0');
        output_signals(14)<='1';-- conditional_branch left side 
 	output_signals(15)<='1';-- conditional_branch right side 
    elsif opcode = "10100" then
        -- JMP Rsrc1
        output_signals <= (others => '0');
        output_signals(5) <= '1';  ---fetch_decode_flush
  	output_signals(4) <= '1';  ---conditional branch
    elsif opcode = "10101" then
        -- CALL Rsrc1
        output_signals <= (others => '0');
     	output_signals(3)<='1';   ---call
	output_signals(4) <= '1';  ---conditional branch
        output_signals(5) <= '1';  ---fetch_decode_flush
        output_signals(25)<='1';   --- push
  	output_signals(11)<='1';   --- memroy_write
     	output_signals(12)<='1';   ---memory src
        output_signals(13)<='1';   ---memory datasrc
    elsif opcode = "10110" then
        -- RET
        output_signals <= (others => '0');
        output_signals(26)  <='1'; --pop 
     	output_signals(12)  <='1';   ---memory src
     	output_signals(6)   <='1';   ---ret
        output_signals(5)   <= '1';  ---fetch_decode_flush
        output_signals(10)  <='1';   --- memroy_read 
    elsif opcode = "10111" then
        -- Condition for opcode 10111
        output_signals <= (others => '0');
        
    elsif opcode = "11000" then
        -- Condition for opcode 11000
        output_signals <= (others => '0');
        
    elsif opcode = "11001" then
        -- Condition for opcode 11001
        output_signals <= (others => '0');
        
    elsif opcode = "11010" then
        -- Condition for opcode 11010
        output_signals <= (others => '0');
        
    elsif opcode = "11011" then
        -- Condition for opcode 11011
        output_signals <= (others => '0');
        
    elsif opcode = "11100" then
        -- Condition for opcode 11100
        output_signals <= (others => '0');
        
    elsif opcode = "11101" then
        -- Condition for opcode 11101
        output_signals <= (others => '0');
        
    elsif opcode = "11110" then
        -- Condition for opcode 11110
        output_signals <= (others => '0');
        
    elsif opcode = "11111" then
        -- Condition for opcode 11111
        output_signals <= (others => '0');
        
    end if;
end process;


end control_unit_architecture;

