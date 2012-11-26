start EchoTestbench
file copy -force ../../../software/echo/echo.mif imem_blk_ram.mif
file copy -force ../../../software/echo/echo.mif dmem_blk_ram.mif
add wave EchoTestbench/*
add wave EchoTestbench/CPU/*
add wave EchoTestbench/CPU/the_datapath/*
add wave EchoTestbench/CPU/the_controller/*
add wave EchoTestbench/CPU/the_datapath/the_imem/*
add wave EchoTestbench/CPU/the_datapath/the_regfile/*
add wave EchoTestbench/CPU/the_datapath/the_regfile/the_registers/*
add wave EchoTestbench/CPU/the_datapath/the_PC/*
add wave EchoTestbench/CPU/the_uart/*
add wave EchoTestbench/CPU/the_uart/uareceive/*
add wave EchoTestbench/CPU/the_uart/uatransmit/*
add wave EchoTestbench/uart/*
add wave EchoTestbench/uart/uareceive/*
add wave EchoTestbench/uart/uatransmit/*
run 3000us
