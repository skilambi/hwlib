module tb_counter ();


    logic clk;
    logic rst_n;

    logic [15:0] cntr;

    initial begin 
        clk = 0;

        forever begin
            #5 clk = ~clk;
        end
    end


    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, tb_counter); 
        rst_n = 1;

        repeat (5)
            @(posedge clk) ;
        
        rst_n = 0;

        repeat (5)
            @(posedge clk);

        repeat ( 100 )
            @(posedge clk);
        

        $finish;
    end  


    counter DUT
        (
            .clk,
            .rst_n,
            .cntr 
        );

endmodule
