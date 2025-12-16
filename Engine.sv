module engine (
    engine_if.engine_slave engine_if
);
    PE_data_if PE_bus [4]();
    
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : PE_BUS_ASSIGN
            assign PE_bus[j].data_in = engine_if.data_in[j];
            assign PE_bus[j].weight_in = engine_if.common_weight_in;
            assign engine_if.result_out[j] = PE_bus[j].result_out;
        end
    endgenerate

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : PE_ARRAY
            PE #(
                .DATA_WIDTH(16),
                .WEIGHT_WIDTH(4),
                .RESULT_WIDTH(16),
                .DATA_NUM(4)
            ) pe_inst (
                .data_if(PE_bus[i])
            );
        end
    endgenerate
endmodule 

module PE#(
    parameter DATA_WIDTH = 16,
    parameter WEIGHT_WIDTH = 4,
    parameter RESULT_WIDTH = 16,
    parameter DATA_NUM = 4
)(
    PE_data_if.pe_slave data_if
);
    assign data_if.result_out = data_if.data_in[0]*data_if.weight_in[0] +
                                data_if.data_in[1]*data_if.weight_in[1] +
                                data_if.data_in[2]*data_if.weight_in[2] +
                                data_if.data_in[3]*data_if.weight_in[3];
endmodule