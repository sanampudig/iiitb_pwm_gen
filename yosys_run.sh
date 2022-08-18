# read design
# read_liberty -lib /media/psf/Home/Stark/Education/ASIC/iiitb_pwm_gen/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog iiitb_pwm_gen.v

# generic synthesis
synth -top iiitb_pwm_gen

# mapping to mycells.lib

dfflibmap -liberty /media/psf/Home/Stark/Education/ASIC/iiitb_pwm_gen/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
abc -liberty /media/psf/Home/Stark/Education/ASIC/iiitb_pwm_gen/lib/sky130_fd_sc_hd__tt_025C_1v80.lib -script +strash;scorr;ifraig;retime,{D};strash;dch,-f;map,-M,1,{D}
clean
flatten
# write synthesized design
write_verilog -noattr iiitb_pwm_gen_synth.v
# stat
# show
