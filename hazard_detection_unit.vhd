LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY hazard_detection_unit IS
    PORT (
        rs, rt, rd : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Register source and destination
        mem_read   : IN STD_LOGIC;                    -- ID/EX.MEMREAD
        enable     : IN STD_LOGIC;                    -- Enable (0: no hazard check)
        one_two    : IN STD_LOGIC;                    -- 0: check `rs` only, 1: check both `rs` and `rt`
        stall      : OUT STD_LOGIC                    -- Stall output (1: stall, 0: no stall)
    );
END ENTITY hazard_detection_unit;

ARCHITECTURE hazard_detection_unit OF hazard_detection_unit IS
BEGIN
    PROCESS (rs, rt, rd, mem_read, enable, one_two)
    BEGIN
        IF enable = '0' THEN -- No operand for this instruction
            stall <= '0';
        ELSIF mem_read = '1' THEN -- Memory read instruction
            IF (one_two = '0' AND rs = rd) OR (one_two = '1' AND (rs = rd OR rt = rd)) THEN
                stall <= '1'; -- Stall if dependency detected
            ELSE
                stall <= '0'; -- No stall
            END IF;
        ELSE
            stall <= '0'; -- No hazard
        END IF;
    END PROCESS;
END ARCHITECTURE hazard_detection_unit;

