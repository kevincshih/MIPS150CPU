proc start {m} {vsim -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -L secureip work.glbl $m}
start ControlTestbench
add wave ControlTestbench/*
add wave ControlTestbench/DUT/*
run 1000us