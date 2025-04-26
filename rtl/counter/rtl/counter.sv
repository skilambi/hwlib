module counter #(
    parameter CNTR_WIDTH = 4
) (
    input   logic                       clk,
    input   logic                       rst_n,
    output  logic [CNTR_WIDTH - 1 : 0]  cntr 
);

    logic [CNTR_WIDTH - 1 : 0] cntr_nxt;

    always_ff@(posedge clk) begin 
        if(!rst_n)
            cntr <= '0;
        else
            cntr <= cntr_nxt;
    end 


    always_comb begin : CNTR_COMBO
        cntr_nxt = cntr + 1;
    end

    // Dump waves
    initial begin
        $dumpfile("counter_dump.vcd");
        $dumpvars(1, counter);
    end

endmodule
