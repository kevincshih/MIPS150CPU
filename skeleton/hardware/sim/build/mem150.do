proc start {m} {vsim -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -L secureip work.glbl $m}
start Memory150TestBench
add wave Memory150TestBench/*
add wave Memory150TestBench/mem_arch/*
add wave Memory150TestBench/mem_arch/dcache/*
add wave Memory150TestBench/mem_arch/icache/*
add wave Memory150TestBench/mem_arch/req_con/*
run -all
