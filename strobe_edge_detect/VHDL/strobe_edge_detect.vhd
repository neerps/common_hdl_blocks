--====================================================================================
-- Target language: VHDL-2008

-- This block uses base clock to detect rising and falling edges of the strobe

--====================================================================================
--   Copyright 2020 Igor Fomin

--   Licensed under the Apache License, Version 2.0 (the "License");
--   you may not use this file except in compliance with the License.
--   You may obtain a copy of the License at

--       http://www.apache.org/licenses/LICENSE-2.0

--   Unless required by applicable law or agreed to in writing, software
--   distributed under the License is distributed on an "AS IS" BASIS,
--   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--   See the License for the specific language governing permissions and
--   limitations under the License.
--====================================================================================
library IEEE;
    use IEEE.STD_LOGIC_1164.all;
    use IEEE.NUMERIC_STD.all;
--====================================================================================
entity strobe_edge_detect is
--------------------------------------------------------------------------------------
    generic (
        NUM_OF_SYNC_STAGES  : natural:= 2
    );
--------------------------------------------------------------------------------------
    port (
--------------------------------------------------------------------------------------
        -- Clocks and resets
        sys_clk_i       : in    std_logic;
        rstn_i          : in    std_logic;
--------------------------------------------------------------------------------------
        -- Interfaces
        strobe_i        : in    std_logic;
        strobe_rise_o   : out	std_logic;
        strobe_fall_o   : out	std_logic
--------------------------------------------------------------------------------------
    );
end strobe_edge_detect;
--====================================================================================
architecture two_process of strobe_edge_detect is
--------------------------------------------------------------------------------------
    type t_sys_regs is record
    
        -- to sample a strobe with system clock
        strobe_sync             : std_logic_vector(NUM_OF_SYNC_STAGES-1 downto 0);
    
        -- to detect rising edge of the CLK_DIV
        strobe_rise             : std_logic;
        
        -- to detect falling edge of the CLK_DIV
        strobe_fall             : std_logic;
        
    end record;
    
    constant c_sys_regs_def     : t_sys_regs:= (
    
        strobe_sync             => (others => '0'),
    
        strobe_rise             => '0',
        strobe_fall             => '0'
    
    );
    
    -- Output of a sequental process
    signal s_sys_r              : t_sys_regs;
    
    -- Input of a sequental process
    signal s_sys_rin            : t_sys_regs;
--------------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------------
    MODULE_COMB: process(all)
--------------------------------------------------------------------------------------
        variable v_sys  : t_sys_regs;
--------------------------------------------------------------------------------------
    begin
--------------------------------------------------------------------------------------
        -- Save current cycle data to variable and prevent latches
        v_sys   := s_sys_r;
--------------------------------------------------------------------------------------
        -- Synchronize strobe into the system clock domain
        for i in 0 to NUM_OF_SYNC_STAGES-1 loop
        
            if i = 0 then
                v_sys.strobe_sync(i)    := strobe_i;

            else
                v_sys.strobe_sync(i)    := s_sys_r.strobe_sync(i-1);

            end if;

        end loop;
--------------------------------------------------------------------------------------
        -- Detect rise of the strobe
        if (s_sys_r.strobe_sync(NUM_OF_SYNC_STAGES-1) = '0') and 
        (s_sys_r.strobe_sync(NUM_OF_SYNC_STAGES-2) = '1') then
            v_sys.strobe_rise   := '1';

        else
            v_sys.strobe_rise   := '0';

        end if;
--------------------------------------------------------------------------------------
        -- Detect fall of the strobe
        if (s_sys_r.strobe_sync(NUM_OF_SYNC_STAGES-1) = '1') and 
        (s_sys_r.strobe_sync(NUM_OF_SYNC_STAGES-2) = '0') then
            v_sys.strobe_fall   := '1';

        else
            v_sys.strobe_fall   := '0';

        end if;
--------------------------------------------------------------------------------------
        -- Load next cycle data to the registers input
        s_sys_rin   <= v_sys;
--------------------------------------------------------------------------------------
    end process;
--------------------------------------------------------------------------------------
    MODULE_REG: process(sys_clk_i, rstn_i)
    begin
    
        if rstn_i = '0' then
            s_sys_r <= c_sys_regs_def;
            
        elsif rising_edge(sys_clk_i) then
            s_sys_r <= s_sys_rin;
            
        end if;
    
    end process;
--------------------------------------------------------------------------------------
    -- Drive outputs
    strobe_rise_o	<= s_sys_r.strobe_rise;
    strobe_fall_o	<= s_sys_r.strobe_fall;
--------------------------------------------------------------------------------------
end two_process;