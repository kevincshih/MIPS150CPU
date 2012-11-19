proc start {m} {vsim -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -L secureip work.glbl $m}
start RegFileTestbench
add wave RegFileTestbench/*
add wave RegFileTestbench/DUT/*
run 1000us
