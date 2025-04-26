// Author: Sai Kilambi
// Date: Sept 25 2023
// Description:
// This is an implementation of the skid buffer based on the description
// given in fpgacpu.ca website.
//


module skid_buf(
    input  logic     clk        ,
    input  logic     reset_n    ,

    input  data_t    i_data     ,
    input  logic     i_valid    ,
    output logic     i_ready    ,

    output data_t    o_data     ,
    output logic     o_valid    ,
    input  logic     o_ready

    );

    /**********************************
     *
     *      Variable Defitions
     * 
     **********************************/

    // Keeps track of buffer state 
    state_t state, state_nxt;

    // Internal Buffer
    data_t int_buf;

    
    /****************************************
     *
     *      i_ready LOGIC      
     * 
     ****************************************/
    
     // i_ready is high only when there is space
     // in the output buffer or the internal buffer
     // i_ready is also high whenever we are in the
     // circular buffer mode.
     assign i_ready = (state != FULL) || (CBM != 0);

     
    /****************************************
     *
     *      o_valid LOGIC      
     * 
     ****************************************/

     // o_valid high whenever there is state is not
     // in EMPTY state.

     assign o_valid = (state != EMPTY);

     /****************************************
     *
     *      State Machine & Control Signals
     * 
     ****************************************/
    
    always_ff@ ( posedge clk or negedge reset_n) begin : STATE
        if (~reset_n) begin
            state <= EMP;
        end else begin 
            state <= state_nxt;
        end 
    end    



    always_comb begin : STATE_LOGIC
        state_nxt = state;

        case ( state ) begin 

            EMP : begin 
            end

            LOADED : begin 
            end

            FULL : begin 
            end 

        endcase 
    end 





endmodule : skid_buf 
