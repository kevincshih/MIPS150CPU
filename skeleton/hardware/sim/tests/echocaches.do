start EchoTestbenchCaches
file copy -force ../../../software/echo/echo.mif bios_mem.mif
file copy -force ../../../software/echo/echo.mif isr_mem.mif
add wave EchoTestbenchCaches/*
add wave EchoTestbenchCaches/mem_arch/*
add wave EchoTestbenchCaches/mem_arch/dcache/*
add wave EchoTestbenchCaches/mem_arch/icache/*
add wave EchoTestbenchCaches/DUT/the_controller/*
add wave EchoTestbenchCaches/DUT/the_datapath/*
add wave EchoTestbenchCaches/DUT/the_uart/*
add wave EchoTestbenchCaches/DUT/the_datapath/the_PC/*
add wave EchoTestbenchCaches/DUT/the_datapath/the_regfile/*
add wave EchoTestbenchCaches/DUT/the_datapath/the_regfile/the_registers
add wave EchoTestbenchCaches/DUT/the_datapath/the_IF_Control/*
run 500us
