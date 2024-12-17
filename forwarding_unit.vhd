LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- FORWARD A 
-- 00: RS (default)
-- 01: EXECUTION RESULT (from EX/M)
-- 10: MEMORY RESULT (from M/WB)

-- FORWARD B 
-- 00: RT (default)
-- 01: EXECUTION RESULT (from EX/M)
-- 10: MEMORY RESULT (from M/WB)

-- Inputs:
-- RS, RT: Register addresses
-- EX/M_RD, M/WB_RD: Read signals from EX/M and M/WB stages
-- EX/M_WB, M/WB_WB: Write-back control signals for EX/M and M/WB
-- Outputs:
-- FA, FB: Forwarding signals for RS and RT respectively

ENTITY forwarding_unit IS 
PORT(
    RS, RT, EX_M_RD, M_WB_RD: IN STD_LOGIC_VECTOR(2 DOWNTO 0);  -- Register addresses
    EX_M_WB, M_WB_WB: IN STD_LOGIC;                              -- Control signals indicating write-back actions
    FA, FB: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)                       -- Forwarding signals for RS and RT
);
END ENTITY forwarding_unit;

ARCHITECTURE forwarding_unit OF forwarding_unit IS
BEGIN
    PROCESS(RS, RT, EX_M_RD, M_WB_RD, EX_M_WB, M_WB_WB)
    BEGIN
        -- Initialization (set forwarding to "00" by default)
        FA <= "00";  
        FB <= "00";  

        -- No write-back happening for both EX/M and M/WB stages
        IF (EX_M_WB = '0' AND M_WB_WB = '0') THEN
            FA <= "00";
            FB <= "00";
        ELSE 
            -- Forwarding logic for RS (FA signal)
            IF (EX_M_WB = '1' AND EX_M_RD = RS) THEN
                FA <= "01";  -- Forward A from EX/M stage
            ELSIF (M_WB_WB = '1' AND M_WB_RD = RS) THEN
                FA <= "10";  -- Forward A from M/WB stage
            END IF;

            -- Forwarding logic for RT (FB signal)
            IF (EX_M_WB = '1' AND EX_M_RD = RT) THEN
                FB <= "01";  -- Forward B from EX/M stage
            ELSIF (M_WB_WB = '1' AND M_WB_RD = RT) THEN
                FB <= "10";  -- Forward B from M/WB stage
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE forwarding_unit;

