#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vcalc_top.h"
#include "Vcalc_top__Syms.h"
#include "ram_model.hpp"
#define MAX_SIM_TIME 20
using std::cout;
using std::endl;
vluint64_t sim_time = 0;
Vcalc_top *dut;
VerilatedVcdC *m_trace;
//uint32_t rdata_s[5] = {0};
uint64_t rdata_s_raw[5] = {0};
uint64_t rdata_A;
#define INIT_SBIT(NAME) Sbit##NAME.init_from_bin("./bin/Sbit" #NAME ".bin")

typedef uint64_t (*Sgetarray)(bool clk, uint64_t addr, bool wen, uint64_t wdata);
Sgetarray tasks[] = {
    Sbit0.eval,
    Sbit1.eval,
    Sbit2.eval,
    Sbit3.eval,
    Sbitsign.eval};

int main(int argc, char **argv, char **env)
{
    dut = new Vcalc_top;
    Verilated::traceEverOn(true);
    m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");
    RamModel Sbit0, Sbit1, Sbit2, Sbit3, Sbitsign;
    INIT_SBIT(0);
    INIT_SBIT(1);
    INIT_SBIT(2);
    INIT_SBIT(3);
    INIT_SBIT(sign);
    RamModel A_buffer;
    A_buffer.init_from_bin("./bin/A_buffer.bin");

    while (sim_time < MAX_SIM_TIME)
    {
        dut->clk ^= 1;
        rdata_A = A_buffer.eval(dut->clk, 1, 0, 0);

        for (int i = 0; i < 5; i++)
        {
            rdata_s_raw[i] = tasks[i](dut->clk, dut->addr_S, 0, 0);
            if (dut -> addr_S & 0x01) 
                dut->rdata_A = (rdata_A_raw >> 16) & 0xFFFF;
            else
                dut->rdata_A = rdata_A_raw & 0xFFFF;
        }


        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
