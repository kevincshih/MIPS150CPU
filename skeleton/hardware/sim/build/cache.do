proc start {m} {vsim -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -L secureip work.glbl $m}
start CacheTestBench
add wave CacheTestBench/*
add wave CacheTestBench/mem_arch/*
add wave CacheTestBench/mem_arch/dcache/*
run -all
