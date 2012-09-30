proc start {m} {vsim -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -L secureip work.glbl $m}
start EchoTestbench
add wave EchoTestbench/*
add wave EchoTestbench/uart/*
add wave EchoTestbench/uart/uatransmit/*
add wave EchoTestbench/uart/uareceive/*
add wave EchoTestbench/top/*
add wave EchoTestbench/top/uart/*
add wave EchoTestbench/top/uart/uareceive/*
add wave EchoTestbench/top/uart/uatransmit/*
run 10ms
