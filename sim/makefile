.PHONY: build run RUN clean
VERILOG=$(wildcard ../rtl/*.sv)
CSOURCE=$(wildcard *.cpp)

build:
# 	clear
	verilator --trace -cc $(VERILOG) --exe $(CSOURCE) --top-module calc_top -Mdir obj_dir
	$(MAKE) -C obj_dir -f Vcalc_top.mk Vcalc_top

buildtest:
	verilator -CFLAGS "-DAS_TEST" --trace -cc $(VERILOG) --exe $(CSOURCE) --top-module calc_top -Mdir obj_dir   
	$(MAKE) -C obj_dir -f Vcalc_top.mk Vcalc_top

run: build
	./obj_dir/Vcalc_top
gen: 
	python3 ./psrc/SAgen.py
RUN: run

see:
	gtkwave waveform.vcd

clean:
	rm -rf obj_dir waveform.vcd