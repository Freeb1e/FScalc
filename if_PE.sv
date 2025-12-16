interface PE_data_if #(    
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 4,
    parameter RESULT_WIDTH = 16
    );

    logic [3:0][DATA_WIDTH-1:0] data_in;
    logic [WEIGHT_WIDTH-1:0]weight_in;
    logic [RESULT_WIDTH-1:0] result_out;

    // modport for PE module
    modport pe_slave (
        input data_in,
        input weight_in,
        output result_out
    );

    modport pe_master (
        output data_in,
        output weight_in,
        input result_out
    );
endinterface


