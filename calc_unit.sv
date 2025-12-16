module calc_unit(
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic [159:0] weight_in,//S
    input logic [7:0][3:0][63:0] data_in,//A
    output logic [7:0][3:0][16:0] result_engine,//Y
    output logic [7:0][2:0] shift_out
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
            if(bit_counter == 3'd4) begin
                bit_counter <= 'b0;
            end else begin
                bit_counter <= bit_counter + 2'b1;
            end
        end
    end


    //==========================================================
    // 每次访存取出S的一个位切片，按照bit_counter索引取出S的第i位
    //==========================================================
    logic [31:0] current_weights;
    always_comb begin
        case(bit_counter)
            3'd0: current_weights = weight_in[31:0];
            3'd1: current_weights = weight_in[63:32];
            3'd2: current_weights = weight_in[95:64];
            3'd3: current_weights = weight_in[127:96];
            3'd4: current_weights = weight_in[159:128];
            default: current_weights = '0;
        endcase
    end
    // assign current_weights = weight_in[bit_counter*32 +: 32];
    //==========================================================
    // 所有的Engine共用S的一列进行计算，打包取走A的4个数据共64位
    //==========================================================
    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin : ENGINE_ARRAY
            assign engine_bus[j].common_weight_in = current_weights[j*4 +: 4];
            assign engine_bus[j].data_in = data_in[j];
            assign result_engine[j] = engine_bus[j].result_out;

            engine engine_inst (
                .engine_if(engine_bus[j])
            );
            assign shift_out[j] = bit_counter;//目前暂不考虑稀疏性跳转，所有的engine公用一个移位数据
        end
    endgenerate

    
    
endmodule 