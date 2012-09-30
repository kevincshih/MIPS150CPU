proc start {m} {vsim -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -L secureip work.glbl $m}
start Testbench
add wave Testbench/*
add wave Testbench/uart1/*
add wave Testbench/uart1/uareceive/*
add wave Testbench/uart1/uatransmit/*
add wave Testbench/uart2/*
add wave Testbench/uart2/uareceive/*
add wave Testbench/uart2/uatransmit/*
run 10ms
