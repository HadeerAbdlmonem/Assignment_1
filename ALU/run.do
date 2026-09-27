vlib work
vlog ALU.v test_ALU.sv +cover -covercells
vsim -voptargs=+acc work.alu_4bit_tb -cover
add wave *
coverage save alu_4bit_tb.ucdb -onexit -du work.alu_4bit_tb
run -all
