vlib work
vlog DSP.v test_DSP.sv +cover -covercells
vsim -voptargs=+acc work.dsp_tb -cover
add wave *
coverage save test_DSP.ucdb -onexit -du work.dsp_tb
run -all
