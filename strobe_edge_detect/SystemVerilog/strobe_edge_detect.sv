//====================================================================================
/*

Target language SystemVerilog

This block uses base clock to detect rising and falling edges of the strobe

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
module strobe_edge_detect # (
//------------------------------------------------------------------------------------
    parameter NUM_OF_SYNC_STAGES = 2
//------------------------------------------------------------------------------------
) (
    // Clocks and resets
    input   logic       sys_clk_i,
    input   logic       rstn_i,
//------------------------------------------------------------------------------------
    // Interfaces
    input   logic       strobe_i,
    output  logic	    strobe_rise_o,
    output  logic	    strobe_fall_o
//------------------------------------------------------------------------------------
);
//====================================================================================
    typedef struct {

        // to sample a strobe with a system clock
        logic[NUM_OF_SYNC_STAGES-1:0]   strobe_sync;

        // to detect rising edge of the strobe
        logic                           strobe_rise;
            
        // to detect falling edge of the strobe
        logic                           strobe_fall;

    } t_sys_regs;
//------------------------------------------------------------------------------------
    localparam t_sys_regs p_sys_regs_def = '{

        strobe_sync                     : '0,

        strobe_rise                     : 1'b0,
        strobe_fall                     : 1'b0

    };
//------------------------------------------------------------------------------------
    // Output of a sequental process
    t_sys_regs s_sys_r;
        
    // Input of a sequental process
    t_sys_regs s_sys_rin;
//====================================================================================
    always_comb begin
//------------------------------------------------------------------------------------
        // Set default values
        s_sys_rin   = s_sys_r;
//------------------------------------------------------------------------------------
        // Synchronize strobe into the system clock domain
        for (int i = 0; i < NUM_OF_SYNC_STAGES; i++) begin
        
            if (i == 0)
                s_sys_rin.strobe_sync[i]   = strobe_i;
            
            else 
                s_sys_rin.strobe_sync[i]   = s_sys_r.strobe_sync[i-1];

        end
//------------------------------------------------------------------------------------
        // Detect rise of the strobe
        if ((s_sys_r.strobe_sync[NUM_OF_SYNC_STAGES-1] == 1'b0) && 
        (s_sys_r.strobe_sync[NUM_OF_SYNC_STAGES-2] == 1'b1))
            s_sys_rin.strobe_rise	= 1'b1;
    
        else
            s_sys_rin.strobe_rise	= 1'b0;
//------------------------------------------------------------------------------------
        // Detect fall of the strobe
        if ((s_sys_r.strobe_sync[NUM_OF_SYNC_STAGES-1] == 1'b1) && 
        (s_sys_r.strobe_sync[NUM_OF_SYNC_STAGES-2] == 1'b0))
            s_sys_rin.strobe_fall	= 1'b1;

        else
            s_sys_rin.strobe_fall	= 1'b0;
//------------------------------------------------------------------------------------
    end
//====================================================================================
    always_ff@(posedge sys_clk_i or posedge rstn_i) begin
    
        if (!rstn_i)
            s_sys_r	<= p_sys_regs_def;
        
        else
            s_sys_r	<= s_sys_rin;
        
    end
//====================================================================================
    // Drive outputs
    assign strobe_rise_o = s_sys_r.strobe_rise;
    assign strobe_fall_o = s_sys_r.strobe_fall;
//====================================================================================
endmodule