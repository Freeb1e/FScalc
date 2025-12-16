interface engine_if #(    
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 4,
    parameter RESULT_WIDTH = 16,
    parameter PE_NUM = 4
    );
    logic [WEIGHT_WIDTH-1:0] common_weight_in;
    logic [PE_NUM-1:0][3:0][DATA_WIDTH-1:0] data_in;
    logic [PE_NUM-1:0][RESULT_WIDTH-1:0] result_out;

    modport engine_slave (
        input common_weight_in,
        input data_in,
        output result_out
    );
    modport engine_master (
        output common_weight_in,
        output data_in,
        input result_out
    );
endinterface

interface adder_if #(
    parameter DATA_WIDTH = 16,
    parameter SHIFT_WIDTH = 3,
    parameter PE_NUM = 4
    )(input logic clk,input logic rst_n);
    logic [PE_NUM-1:0][DATA_WIDTH-1:0] data_in;
    logic [SHIFT_WIDTH-1:0] shift_amount;
    logic [DATA_WIDTH-1:0] sum_out;
    logic init;
    modport adder_slave (
        input clk,
        input rst_n,
        input data_in,
        input shift_amount,
        input init,
        output sum_out
    );
    modport adder_master (
        input clk,
        input rst_n,
        output data_in,
        output shift_amount,
        output init,
        input sum_out
    );
    
endinterface