# read design

read_verilog iiitb_pwm_gen.v

# generic synthesis
synth -top iiitb_pwm_gen

# mapping to mycells.lib
dfflibmap -liberty /home/svgkr7/Desktop/iiitb_pwm_gen/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
abc -liberty /home/svgkr7/Desktop/iiitb_pwm_gen/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
clean
flatten
# write synthesized design
write_verilog -assert iiitb_pwm_gen_synth.v
