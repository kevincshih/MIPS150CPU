start asmTestbench
file copy -force ../../../software/asmtest/asmtest.mif imem_blk_ram.mif
file copy -force ../../../software/asmtest/asmtest.mif dmem_blk_ram.mif
add wave asmTestbench/*
add wave asmTestbench/CPU/*
add wave asmTestbench/CPU/the_datapath/*
add wave asmTestbench/CPU/the_controller/*
add wave asmTestbench/CPU/the_datapath/the_imem/*
add wave asmTestbench/CPU/the_datapath/the_regfile/*
add wave asmTestbench/CPU/the_datapath/the_regfile/the_registers/*
add wave asmTestbench/CPU/the_datapath/the_PC/*
add wave asmTestbench/CPU/the_uart/*
add wave asmTestbench/CPU/the_uart/uareceive/*
add wave asmTestbench/CPU/the_uart/uatransmit/*
add wave asmTestbench/uart/*
add wave asmTestbench/uart/uareceive/*
add wave asmTestbench/uart/uatransmit/*
run 3000us
