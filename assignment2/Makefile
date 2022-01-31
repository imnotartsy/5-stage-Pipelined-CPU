EXEC_TIME=100ns

%:
    -rm $@.vcd $@.wlf
    vcom -quiet -2008 $@.vhdl $@_tb.vhdl
    vsim -quiet -c work.$@_TB -do "log -r /*; run $(EXEC_TIME); exit" -wlf $@.wlf
    wlf2vcd $@.wlf -o $@.vcd



# vcom -quiet -2008 shiftleft2.vhd shiftleft2_tb.vhd
# vsim -quiet -c work.shiftleft2_tb -do "log -r /*; run 100ns; exit" -wlf shiftleft2.wlf
    wlf2vcd $@.wlf -o $@.vcd