vlib work
vlog adder.v test.sv +cover -covercells
vsim -voptargs=+acc work.adder_tb -cover
add wave *
coverage save adder_tb.ucdb -onexit -du work.adder
run -all
