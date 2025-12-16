module calc_unit(
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic [159:0] weight_in,//S
    input logic [7:0][3:0][63:0] data_in,//A
    output logic [7:0][3:0][16:0] result_out//Y
);
    engine_if engine_bus[8]();
    logic [2:0] bit_counter;

    always_ff@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            bit_counter <= 'b0;
        end
        else if(start)begin
            bit_counter <= 'b0;
        end else begin
            bit_counter <= bit_counter + 2'b1;
        end
    end

    logic [31:0] current_weights;
    assign current_weights = weight_in[bit_counter*32 +: 32];

    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin : ENGINE_ARRAY
            assign engine_bus[j].common_weight_in = current_weights[j*4 +: 4];
            assign engine_bus[j].data_in = data_in[j];
            assign result_out[j] = engine_bus[j].result_out;

            engine engine_inst (
                .engine_if(engine_bus[j])
            );
        end
    endgenerate
    
endmodule 