proc start {m} {vsim -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -L secureip work.glbl $m}
start MmultTestbench
file copy -force ../../../software/mmult/mmult.mif bios_mem.mif
add wave MmultTestbench/*
add wave MmultTestbench/mem_arch/*
add wave MmultTestbench/mem_arch/dcache/*
add wave MmultTestbench/mem_arch/icache/*
add wave MmultTestbench/DUT/the_controller/*
add wave MmultTestbench/DUT/the_datapath/*
add wave MmultTestbench/DUT/the_uart/*
add wave MmultTestbench/DUT/the_datapath/the_PC/*
add wave MmultTestbench/DUT/the_datapath/the_regfile/*
add wave MmultTestbench/DUT/the_datapath/the_regfile/the_registers
add wave MmultTestbench/DUT/the_datapath/the_IF_Control/*
run 3000us
