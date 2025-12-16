module calc_top(
        input logic clk,
        input logic rst_n,
        input logic start,
        input logic [159:0] weight_in,//S
        input logic [7:0][3:0][63:0] data_in,//A
        output logic [31:0] addr_B,
        output logic [31:0] addr_S,
        output logic [31:0] addr_A,
        output logic [7:0][16:0] final_result//最终结果输出
    );
    adder_if adder_bus[8](clk,rst_n);
    logic init;
    logic [7:0][3:0][16:0] result_engine;//Y
    logic [7:0][2:0] shift_out;
    calc_unit u_calc_unit(
                  .clk        	(clk         ),
                  .rst_n      	(rst_n       ),
                  .start      	(start       ),
                  .weight_in  	(weight_in   ),
                  .data_in    	(data_in     ),
                  .result_engine 	(result_engine),
                  .shift_out    (shift_out   )
              );
    genvar i;
    generate
        for(i=0;i<8;i=i+1) begin : ADDER_ARRAY
            Engine_Adder u_engine_adder(
                             .adder_data(adder_bus[i])
                         );
            assign adder_bus[i].data_in = result_engine[i];
            assign adder_bus[i].shift_amount = shift_out[i];
            assign adder_bus[i].init = init;
            assign final_result[i] = adder_bus[i].sum_out;
        end
    endgenerate
endmodule
