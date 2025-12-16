module calc_top(
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic [159:0] weight_in,//S
    input logic [7:0][3:0][63:0] data_in,//A
    output logic [7:0][3:0][16:0] result_out//Y
    output logic [31:0][]
);

    calc_unit u_calc_unit(
        .clk        	(clk         ),
        .rst_n      	(rst_n       ),
        .start      	(start       ),
        .weight_in  	(weight_in   ),
        .data_in    	(data_in     ),
        .result_out 	(result_out  )
    );
    
endmodule 