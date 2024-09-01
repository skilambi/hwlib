interface rb_if # ( 
    parameter type data_t = logic

);

    data_t  data;
    logic   valid;
    logic   ready;


    modport slave ( 
        input data,
        input valid, 
        output ready
    );

    modport master(
        output data,
        output valid,
        input ready
    )


endinterface : rb_if