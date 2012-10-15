start EchoTestbench
file copy -force ../../../software/echo/echo.mif imem_blk_ram.mif
file copy -force ../../../software/echo/echo.mif dmem_blk_ram.mif
add wave EchoTestbench/*
add wave EchoTestbench/CPU/*
add wave EchoTestbench/CPU/the_datapath/*
add wave EchoTestbench/CPU/the_datapath/the_imem/*
add wave EchoTestbench/CPU/the_datapath/the_regfile/*
add wave EchoTestbench/CPU/the_datapath/the_PC/*
run 1000us
