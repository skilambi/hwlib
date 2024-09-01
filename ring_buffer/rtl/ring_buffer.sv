
/*

*/
module ring_buffer #( 
    parameter type  data_t  = logic, 
    parameter       DW      = $size(data_t),
    parameter       DEPTH   = 16,
    parameter       AW      = $clog2(DEPTH) 
) (
    input logic     clk,
    input logic     rst_n,

    output  logic    full,
    output  logic    empty,
    
    rb_if.slave     i_bus,
    rb_if.master    o_bus
);


    /************************
    *   VARIABLES & TYPES
    *************************/

    typedef logic[ AW-1 : 0 ] addr_t;
    typedef logic[ AW : 0 ] cntr_t; 

    addr_t wr_ptr, wr_ptr_nxt;  // Write address - points to where the next value will be written.
    addr_t rd_ptr, rd_ptr_nxt;  // Read address - points to where next value will be read from.
    cntr_t cnt, cnt_nxt;        // Number of elements in the ring buffer

    logic wr    ;   //Write valid
    logic rd    ;   //Read valid
    logic wrto  ;   //Write transaction only
    logic rdto  ;   //Read transaction only

    // Ring Buffer
    data_t rng_buf[DEPTH];

    /************************
    * Write transactions
    *************************/
    always_ff @(posedge clk or negedge rst_n) begin 
        if ( !rst_n ) begin 
            wr_ptr <= '0;
        end else begin
            if ( wr ) begin
                wr_ptr              <= wr_ptr + 1;
                rng_buf[wr_ptr]     <= i_bus.data; 
            end
        end 
    end

    /************************
    * Read transactions
    *************************/
    always_ff @(posedge clk or negedge rst_n) begin 
        if ( !rst_n ) begin 
            rd_ptr <= '0;
        end else begin
            if ( rd ) begin
                rd_ptr              <= rd_ptr + 1;
            end
        end 
    end

    // Internal Count Logic
    always_ff @(posedge clk or negedge rst_n) begin
        if ( !rst_n ) begin
            cnt <= '0 ; 
        end else begin
            cnt <= cnt_nxt; 
        end 
    end 

    assign cnt_nxt =    wrto ?  cnt + 1 : 
                        rdto ?  cnt - 1 :
                                cnt;


    // Control signals
    assign i_bus.ready  =   !full ;  // Ready is high if there is room in the buffer
    assign wr           =   i_bus.ready & i_bus.valid;
    assign rd           =   o_bus.valid & o_bus.ready;

    assign wrto         =    wr  & !rd ;
    assign rdto         =   !wr  &  rd ;


    /************************
    *   OUTPUT SIGNALS 
    *************************/
    assign full         =   cnt == DEPTH;
    assign empty        =   cnt == 0    ;

    assign o_bus.valid  =   !empty;
    assign o_bus.data   =   rng_buf[rd_ptr];

endmodule : ring_buffer