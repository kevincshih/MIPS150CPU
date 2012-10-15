proc start {m} {vsim -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -L secureip work.glbl $m}
start EchoTestbench
add wave EchoTestbench/*
add wave EchoTestbench/CPU/*
add wave EchoTestbench/CPU/the_datapath/the_imem/*
add wave EchoTestbench/CPU/the_datapath/the_regfile/*
add wave EchoTestbench/CPU/the_datapath/the_PC/*
run 1000us
