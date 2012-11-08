start BiosTestbench
file copy -force ../../../software/bios150v3/bios150v3.mif imem_blk_ram.mif
file copy -force ../../../software/bios150v3/bios150v3.mif dmem_blk_ram.mif
add wave BiosTestbench/*
add wave BiosTestbench/CPU/*
add wave BiosTestbench/CPU/the_datapath/*
add wave BiosTestbench/CPU/the_controller/*
add wave BiosTestbench/CPU/the_datapath/the_imem/*
add wave BiosTestbench/CPU/the_datapath/the_regfile/*
add wave BiosTestbench/CPU/the_datapath/the_regfile/the_registers/*
add wave BiosTestbench/CPU/the_datapath/the_PC/*
add wave BiosTestbench/CPU/the_uart/*
add wave BiosTestbench/CPU/the_uart/uareceive/*
add wave BiosTestbench/CPU/the_uart/uatransmit/*
add wave BiosTestbench/uart/*
add wave BiosTestbench/uart/uareceive/*
add wave BiosTestbench/uart/uatransmit/*
run 2500us
