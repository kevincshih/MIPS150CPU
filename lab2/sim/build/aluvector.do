proc start {m} {vsim -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -L secureip work.glbl $m}
set MODULE ALUTestVectorTestbench
start $MODULE
add wave $MODULE/*
add wave $MODULE/DUT1/*
add wave $MODULE/DUT2/*
run 100us
