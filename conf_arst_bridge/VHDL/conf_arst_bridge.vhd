--====================================================================================

-- Target language: VHDL-93 and above.

-- This block generates reset bridge with selectable active level (low or high) and 
-- active clock edge (rising or falling) for async resets with different polarities.

--====================================================================================
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numberic_std.all;
--====================================================================================
entity conf_arst_bridge is
--------------------------------------------------------------------------------------
    generic (
        IN_RES_POL      : string:= "ACTIVE_LOW";
        OUT_RES_POL     : string:= "ACTIVE_HIGH";
        CLK_EDGE        : string:= "POS_EDGE"
    );
--------------------------------------------------------------------------------------
    port (
        clk_i           : in	std_logic;
        rst_i           : in	std_logic;
        rst_o           : out	std_logic
    );
--------------------------------------------------------------------------------------
end conf_arst_bridge;
--====================================================================================
architecture arst_bridge of conf_arst_bridge is
--------------------------------------------------------------------------------------
    signal rst_int_s    : std_logic_vector(1 downto 0);
--------------------------------------------------------------------------------------
begin
--------------------------------------------------------------------------------------
    IN_POS_OUT_POS_CLK_POS: 
    if ((IN_RES_POL = "ACTIVE_HIGH") and (OUT_RES_POL = "ACTIVE_HIGH") and 
    (CLK_EDGE = "POS_EDGE")) generate
        
        RES_RESYNC: process(clk_i, rst_i)
        begin
            if rst_i = '1' then

                rst_int_s(0)    <= '1';
                rst_int_s(1)    <= '1';
                
            elsif rising_edge(clk_i) then
            
                rst_int_s(0)    <= '0';
                rst_int_s(1)    <= rst_int_s(0);
            
            end if;
        end process;
    
    end generate;
--------------------------------------------------------------------------------------
    IN_POS_OUT_POS_CLK_NEG: 
    if ((IN_RES_POL = "ACTIVE_HIGH") and (OUT_RES_POL = "ACTIVE_HIGH") and 
    (CLK_EDGE = "NEG_EDGE")) generate
        
        RES_RESYNC: process(clk_i, rst_i)
        begin
            if rst_i = '1' then
                
                rst_int_s(0)    <= '1';
                rst_int_s(1)    <= '1';
                
            elsif falling_edge(clk_i) then
            
                rst_int_s(0)    <= '0';
                rst_int_s(1)    <= rst_int_s(0);
            
            end if;
        end process;
    
    end generate;
--------------------------------------------------------------------------------------		
    IN_POS_OUT_NEG_CLK_POS:
    if ((IN_RES_POL = "ACTIVE_HIGH") and (OUT_RES_POL = "ACTIVE_LOW") and 
    (CLK_EDGE = "POS_EDGE")) generate
        
        RES_RESYNC: process(clk_i, rst_i)
        begin
            if rst_i = '1' then
                
                rst_int_s(0)    <= '0';
                rst_int_s(1)    <= '0';
                
            elsif rising_edge(clk_i) then
            
                rst_int_s(0)    <= '1';
                rst_int_s(1)    <= rst_int_s(0);
            
            end if;
        end process;
    
    end generate;
--------------------------------------------------------------------------------------	
    IN_POS_OUT_NEG_CLK_NEG:
    if ((IN_RES_POL = "ACTIVE_HIGH") and (OUT_RES_POL = "ACTIVE_LOW") and 
    (CLK_EDGE = "NEG_EDGE")) generate
        
        RES_RESYNC: process(clk_i, rst_i)
        begin
            if rst_i = '1' then
                
                rst_int_s(0)    <= '0';
                rst_int_s(1)    <= '0';
                
            elsif falling_edge(clk_i) then
            
                rst_int_s(0)    <= '1';
                rst_int_s(1)    <= rst_int_s(0);
            
            end if;
        end process;
    
    end generate;
--------------------------------------------------------------------------------------
    IN_NEG_OUT_POS_CLK_POS:
    if ((IN_RES_POL = "ACTIVE_LOW") and (OUT_RES_POL = "ACTIVE_HIGH") and 
    (CLK_EDGE = "POS_EDGE")) generate
        
        RES_RESYNC: process(clk_i, rst_i)
        begin
            if rst_i = '0' then
                
                rst_int_s(0)    <= '1';
                rst_int_s(1)    <= '1';
                
            elsif rising_edge(clk_i) then
            
                rst_int_s(0)    <= '0';
                rst_int_s(1)    <= rst_int_s(0);
            
            end if;
        end process;
    
    end generate;
--------------------------------------------------------------------------------------	
    IN_NEG_OUT_POS_CLK_NEG:
    if ((IN_RES_POL = "ACTIVE_LOW") and (OUT_RES_POL = "ACTIVE_HIGH") and 
    (CLK_EDGE = "NEG_EDGE")) generate
        
        RES_RESYNC: process(clk_i, rst_i)
        begin
            if rst_i = '0' then
                
                rst_int_s(0)    <= '1';
                rst_int_s(1)    <= '1';
                
            elsif falling_edge(clk_i) then
            
                rst_int_s(0)    <= '0';
                rst_int_s(1)    <= rst_int_s(0);
            
            end if;
        end process;
    
    end generate;
--------------------------------------------------------------------------------------
    IN_NEG_OUT_NEG_CLK_POS:
    if ((IN_RES_POL = "ACTIVE_LOW") and (OUT_RES_POL = "ACTIVE_LOW") and 
    (CLK_EDGE = "POS_EDGE")) generate
        
        RES_RESYNC: process(clk_i, rst_i)
        begin
            if rst_i = '0' then
                
                rst_int_s(0)    <= '0';
                rst_int_s(1)    <= '0';
                
            elsif rising_edge(clk_i) then
            
                rst_int_s(0)    <= '1';
                rst_int_s(1)    <= rst_int_s(0);
            
            end if;
        end process;
    
    end generate;
--------------------------------------------------------------------------------------
    IN_NEG_OUT_NEG_CLK_NEG:
    if ((IN_RES_POL = "ACTIVE_LOW") and (OUT_RES_POL = "ACTIVE_LOW") and 
    (CLK_EDGE = "NEG_EDGE")) generate
        
        RES_RESYNC: process(clk_i, rst_i)
        begin
            if rst_i = '0' then
                
                rst_int_s(0)    <= '0';
                rst_int_s(1)    <= '0';
                
            elsif falling_edge(clk_i) then
            
                rst_int_s(0)    <= '1';
                rst_int_s(1)    <= rst_int_s(0);
            
            end if;
        end process;
    
    end generate;
--------------------------------------------------------------------------------------
    rst_o   <= rst_int_s(1);
--------------------------------------------------------------------------------------
end arst_bridge;