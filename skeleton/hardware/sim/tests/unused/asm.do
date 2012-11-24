start asmTestbench
file copy -force ../../../software/asmtest/asmtest.mif bios_mem.mif
add wave asmTestbench/*
add wave asmTestbench/DUT/*
add wave asmTestbench/DUT/the_datapath/*
add wave asmTestbench/DUT/the_controller/*
add wave asmTestbench/DUT/the_datapath/the_imem/*
add wave asmTestbench/DUT/the_datapath/the_regfile/*
add wave asmTestbench/DUT/the_datapath/the_regfile/the_registers/*
add wave asmTestbench/DUT/the_datapath/the_PC/*
add wave asmTestbench/DUT/the_uart/*
add wave asmTestbench/DUT/the_uart/uareceive/*
add wave asmTestbench/DUT/the_uart/uatransmit/*
add wave asmTestbench/uart/*
add wave asmTestbench/uart/uareceive/*
add wave asmTestbench/uart/uatransmit/*
run 1000us
