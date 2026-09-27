vlib work
vlog periority_enc.v test_periority_enc.sv +cover -covercells
vsim -voptargs=+acc work.priority_enc_tb -cover
add wave *
coverage save periority_enc_tb.ucdb -onexit -du work.priority_enc_tb
run -all
