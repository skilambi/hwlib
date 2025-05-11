

`include "vunit_defines.svh"


module ring_buffer_tb;

    logic clk;
    logic rst_n;
    initial begin 
        clk = 0;
        forever
            #5 clk = ~clk;
    end 

    initial begin 
        rst_n = 1;
        repeat(5)
            @(posedge clk);
        
        rst_n = 0;
        repeat(5)
            @(posedge clk);
        
        rst_n = 1;
    end 

    /***********************
     * DUT INSTATIATION
     ***********************/
    typedef logic [31:0] data_t;

    rb_if i_bus();
    rb_if o_bus();

    assign o_bus.ready = 1'b1;

    ring_buffer #( 
        .data_t(data_t), 
        .DEPTH(16),
        .AW(4)
    ) dut (
        .clk,
        .rst_n,

        .full(),
        .empty(),
    
        .i_bus,
        .o_bus
    );


    `TEST_SUITE begin 

        `TEST_SUITE_SETUP begin 
            // Initialize the testbench environment
            $display("Test suite setup for ring_buffer_tb");
        end

        `TEST_SUITE_CLEANUP begin 
            // Cleanup after all tests
            $display("Test suite cleanup for ring_buffer_tb");
        end

        `TEST_CASE("basic") begin 
            $display("Starting Test 3");
            repeat(100)
                @(posedge clk);
            $display("Finishing Test 3");
        end 

    end // End of test suite

    `WATCHDOG(1000ns)
endmodule : ring_buffer_tb
// End of ring_buffer_tb.sv