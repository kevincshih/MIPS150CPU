proc start {m} {vsim -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -L secureip work.glbl $m}
start BiosTestbench
file copy -force ../../../software/bios150v3/bios150v3.mif bios_mem.mif
add wave BiosTestbench/*
add wave BiosTestbench/DUT*
add wave BiosTestbench/DUT/the_datapath/*
add wave BiosTestbench/DUT/the_controller/*
add wave BiosTestbench/DUT/the_datapath/the_regfile/*
add wave BiosTestbench/DUT/the_datapath/the_regfile/the_registers/*
add wave BiosTestbench/DUT/the_datapath/the_PC/*
add wave BiosTestbench/DUT/the_uart/*
add wave BiosTestbench/DUT/the_uart/uareceive/*
add wave BiosTestbench/DUT/the_uart/uatransmit/*
add wave BiosTestbench/uart/*
add wave BiosTestbench/uart/uareceive/*
add wave BiosTestbench/uart/uatransmit/*
run 10000us
