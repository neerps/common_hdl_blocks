//====================================================================================
/*

Target language SystemVerilog

This block generates reset bridge with selectable active level (low or high) and 
active clock edge (rising or falling) for async resets with different polarities.

*/
//====================================================================================
/* Copyright 2020 Igor Fomin

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License. */
//====================================================================================
module conf_arst_bridge #(
//------------------------------------------------------------------------------------
    parameter IN_RES_POL    = "ACTIVE_LOW",
    parameter OUT_RES_POL   = "ACTIVE_HIGH",
    parameter CLK_EDGE      = "POS_EDGE"
//------------------------------------------------------------------------------------
) (
    input   wire    clk_i,
    input   wire    rst_i,
    output  wire    rst_o
);
//====================================================================================
    logic[1:0]  l_rst_int;
//====================================================================================
    generate
    if ((IN_RES_POL == "ACTIVE_HIGH") && (OUT_RES_POL == "ACTIVE_HIGH") && 
    (CLK_EDGE == "POS_EDGE")) begin: IN_POS_OUT_POS_CLK_POS

        always_ff@(posedge clk_i or posedge rst_i) begin : RES_RESYNC
            if (rst_i) begin

                l_rst_int[0]    <= 1'b1;
                l_rst_int[1]    <= 1'b1;

            end
            else begin
            
                l_rst_int[0]    <= 1'b0;
                l_rst_int[1]    <= l_rst_int[0];
            
            end
        end

    end
    endgenerate
//====================================================================================
    generate
    if ((IN_RES_POL == "ACTIVE_HIGH") && (OUT_RES_POL == "ACTIVE_HIGH") && 
    (CLK_EDGE == "NEG_EDGE")) begin: IN_POS_OUT_POS_CLK_NEG
        
        always_ff@(negedge clk_i or posedge rst_i) begin: RES_RESYNC
            if (rst_i) begin
                
                l_rst_int[0]    <= 1'b1;
                l_rst_int[1]    <= 1'b1;

            end
            else begin
            
                s_rst_int[0]    <= 1'b0;
                s_rst_int[1]    <= l_rst_int[0];
            
            end
        end

    end
    endgenerate
--------------------------------------------------------------------------------------		
    generate
    if ((IN_RES_POL == "ACTIVE_HIGH") && (OUT_RES_POL == "ACTIVE_LOW") &&
    (CLK_EDGE == "POS_EDGE")) begin: IN_POS_OUT_NEG_CLK_POS
        
        always_ff@(posedge clk_i or posedge rst_i) begin: RES_RESYNC
            if (rst_i) begin
                
                l_rst_int[0]    <= 1'b0;
                l_rst_int[1]    <= 1'b0;
                
            end
            else begin
                
                l_rst_int[0]    <= 1'b1;
                l_rst_int[1]    <= l_rst_int[0];
            
            end
        end

    end
    endgenerate
--------------------------------------------------------------------------------------	
    generate
    if ((IN_RES_POL == "ACTIVE_HIGH") && (OUT_RES_POL == "ACTIVE_LOW") && 
    (CLK_EDGE == "NEG_EDGE")) begin: IN_POS_OUT_NEG_CLK_NEG
        
        always_ff@(negedge clk_i or posedge rst_i) begin: RES_RESYNC
            if (rst_i) begin
                
                l_rst_int[0]    <= 1'b0;
                l_rst_int[1]    <= 1'b0;

            end
            else begin
            
                l_rst_int[0]    <= 1'b1;
                l_rst_int[1]    <= l_rst_int[0];
            
            end
        end
    
    end
    endgenerate
--------------------------------------------------------------------------------------
    generate
    if ((IN_RES_POL == "ACTIVE_LOW") && (OUT_RES_POL == "ACTIVE_HIGH") && 
    (CLK_EDGE == "POS_EDGE")) begin: IN_NEG_OUT_POS_CLK_POS
        
        always_ff@(posedge clk_i or negedge rst_i) begin: RES_RESYNC
        begin
            if (!rst_i) begin
                
                l_rst_int[0]    <= 1'b1;
                l_rst_int[1]    <= 1'b1;

            end
            else begin
            
                l_rst_int[0]    <= 1'b0;
                l_rst_int[1]    <= l_rst_in[[0];
            
            end
        end

    end
    endgenerate
--------------------------------------------------------------------------------------	
    generate
    if ((IN_RES_POL == "ACTIVE_LOW") && (OUT_RES_POL == "ACTIVE_HIGH") && 
    (CLK_EDGE == "NEG_EDGE")) begin: IN_NEG_OUT_POS_CLK_NEG
        
        always_ff@(negedge clk_i or negedge rst_i) begin: RES_RESYNC
            if (!rst_i) begin
                
                l_rst_int[0]    <= 1'b1;
                l_rst_int[1]    <= 1'b1;
            
            end
            else begin
            
                l_rst_int[0]    <= 1'b0;
                l_rst_int[1]    <= l_rst_int[0];
            
            end
        end
    
    end
    endgenerate
--------------------------------------------------------------------------------------
    generate
    if ((IN_RES_POL == "ACTIVE_LOW") && (OUT_RES_POL == "ACTIVE_LOW") && 
    (CLK_EDGE == "POS_EDGE")) begin: IN_NEG_OUT_NEG_CLK_POS
        
        always_ff@(posedge clk_i or negedge rst_i) begin: RES_RESYNC
            if (!rst_i) begin
                
                l_rst_int[0]    <= 1'b0;
                l_rst_int[1]    <= 1'b0;
            
            end
            else begin
            
                l_rst_int[0]    <= 1'b1;
                l_rst_int[1]    <= l_rst_int[0];
            
            end
        end
    
    end
    endgenerate
--------------------------------------------------------------------------------------
    generate
    if ((IN_RES_POL == "ACTIVE_LOW") && (OUT_RES_POL == "ACTIVE_LOW") && 
    (CLK_EDGE == "NEG_EDGE")) begin: IN_NEG_OUT_NEG_CLK_NEG
        
        always_ff@(negedge clk_i or negedge rst_i) begin: RES_RESYNC
            if (!rst_i) begin
                
                l_rst_int[0]    <= 1'b0;
                l_rst_int[1]    <= 1'b0;

            end 
            else begin
            
                l_rst_int[0]    <= 1'b1;
                l_rst_int[1]    <= l_rst_int[0];
            
            end
        end
    
    end
    endgenerate
//====================================================================================
    // Drive outputs
    assign rst_o = l_rst_int[1];
//====================================================================================
endmodule