module rb_tb();

    typedef logic [7:0] data_t;

    rb_if #(.data_t(data_t)) i_bus();
    rb_if #(.data_t(data_t)) o_bus();

    logic empty, full;
    logic clk, rst_n;


    initial begin 
        clk = 0;

        forever 
            #5 clk = ~clk;
    end 

    initial begin 

        rst_n = 1;

        repeat( 5 )
            @(posedge clk);
        
        rst_n = 0;
        
        repeat( 2 )
            @(posedge clk);
        

        rst_n = 1;
    end

    ring_buffer #(
        .data_t(data_t)
    )
    DUT(
        .clk,
        .rst_n,
        .full,
        .empty,
        .i_bus,
        .o_bus


    );

    initial begin
        i_bus.data = 0;
        i_bus.valid = 0;

        @(posedge clk);
        @(posedge clk);

        i_bus.data = 8'hAA;
        i_bus.valid = 1;

        @(posedge clk);
        i_bus.data = 8'hBB;

        @(posedge clk);
        i_bus.valid = 0;

        repeat ( 5 )
            @(posedge clk);
        
        $display("empty: %d, full %d", empty, full);
        
        $finish();
    end

    initial begin 
        $dumpfile("rb.vcd");
        $dumpvars(0, rb_tb);
    end 


endmodule : rb_tb;
