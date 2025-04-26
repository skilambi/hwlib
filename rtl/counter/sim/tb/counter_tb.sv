module counter_tb#(
            parameter CNTR_WIDTH = 4
    )();



    logic clk;
    logic rst_n;
    logic [CNTR_WIDTH - 1 : 0] cntr_o;
    initial begin 
        clk = 0;

        forever 
            #5 clk = ~clk;
    end

    initial begin 
        rst_n = 1;

        repeat(10)
            @(posedge clk);
        
        rst_n = 0;
        repeat(2)
            @(posedge clk);
        
        rst_n = 1;
        repeat(100)
            @(posedge clk);
        
        $finish;

    end


    counter #(.CNTR_WIDTH(CNTR_WIDTH)) DUT
        (
            .clk(clk),
            .rst_n(rst_n),
            .cntr(cntr_o)
        );

endmodule: counter_tb