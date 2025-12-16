module Engine_Adder(
        adder_if.adder_slave adder_data
    );
    logic [15:0] complement;
    logic [15:0] pipeline_reg1,pipeline_reg2;
    logic [15:0] pipeline_reg3;
    always_ff@(posedge adder_data.clk or negedge adder_data.rst_n) begin
        if(!adder_data.rst_n) begin
            pipeline_reg1 <= 'b0;
            pipeline_reg2 <= 'b0;
        end
        else begin
            if(adder_data.init) begin
                pipeline_reg1 <= 'b0;
                pipeline_reg2 <= 'b0;
            end
            else begin
                pipeline_reg1 <= adder_data.data_in[1]+ adder_data.data_in[0];
                pipeline_reg2 <= adder_data.data_in[2]+ adder_data.data_in[3];
            end
        end
    end
    //注意符号位为1的时候需要做补码运算确保乘法结果的正确性
    assign pipeline_reg3 = (pipeline_reg1 + pipeline_reg2)<< adder_data.shift_amount;
    assign complement = ~pipeline_reg3 + 1;
    always_ff@(posedge adder_data.clk or negedge adder_data.rst_n) begin
        if(!adder_data.rst_n) begin
            adder_data.sum_out <= 'b0;
        end
        else begin
            if(adder_data.init) begin
                adder_data.sum_out <= 'b0;
            end
            else begin
                adder_data.sum_out <= adder_data.sum_out + (adder_data.shift_amount == 'd4 ? complement : pipeline_reg3);
            end
        end
    end
endmodule
