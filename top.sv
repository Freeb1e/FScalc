module top(
        input logic clk,
        input logic rst_n,
        input logic access_mode,//1:dma 0:cpu
        input logic [2:0] field_select,//0:S 1:A 2:B
        input logic [31:0] addr_cpu,
        input logic wen_cpu,
        input logic [63:0] data_in_cpu,
        output logic [63:0] data_out_cpu
    );
    A_buffer A_buffer_for4rows (
                 .clka(clka),    // input wire clka
                 .wea(wea),      // input wire [0 : 0] wea
                 .addra(addra),  // input wire [10 : 0] addra
                 .dina(dina),    // input wire [63 : 0] dina
                 .douta(douta),  // output wire [63 : 0] douta
                 .clkb(clkb),    // input wire clkb
                 .enb(enb),      // input wire enb
                 .web(web),      // input wire [0 : 0] web
                 .addrb(addrb),  // input wire [10 : 0] addrb
                 .dinb(dinb),    // input wire [63 : 0] dinb
                 .doutb(doutb)  // output wire [63 : 0] doutb
             );
    // S RAM signals
    logic [4:0] S_ena;
    logic [4:0][0:0] S_wea;
    logic [4:0][8:0] S_addra;
    logic [4:0][31:0] S_dina;
    logic [4:0][31:0] S_douta;
    
    logic [4:0] S_enb;
    logic [4:0][0:0] S_web;
    logic [4:0][8:0] S_addrb;
    logic [4:0][31:0] S_dinb;
    logic [4:0][31:0] S_doutb;

    genvar k;
    generate
        for(k=0; k<5; k=k+1) begin : S_RAM_ARRAY
            bitram u_S_ram (
               .clka(clk),           // input wire clka
               .ena(S_ena[k]),       // input wire ena
               .wea(S_wea[k]),       // input wire [0 : 0] wea
               .addra(S_addra[k]),   // input wire [8 : 0] addra
               .dina(S_dina[k]),     // input wire [31 : 0] dina
               .douta(S_douta[k]),   // output wire [31 : 0] douta
               .clkb(clk),           // input wire clkb
               .enb(S_enb[k]),       // input wire enb
               .web(S_web[k]),       // input wire [0 : 0] web
               .addrb(S_addrb[k]),   // input wire [8 : 0] addrb
               .dinb(S_dinb[k]),     // input wire [31 : 0] dinb
               .doutb(S_doutb[k])    // output wire [31 : 0] doutb
           );
        end
    endgenerate
endmodule
