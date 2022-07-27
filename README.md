# iiitb_pwm_gen - pulse width modulated wave generator with variable duty cycle

PWM Generator
Pulse Width Modulation is a famous technique used to create modulated electronic pulses of the desired width. The duty cycle is the ratio of how long that PWM signal stays at the high position to the total time period.
In this specific circuit, we mainly require a n-bit counter and comparator. Duty given to the comparator is compared with the current value of the counter. If current value of counter is lower than duty then comparator results in output high. Similarly, If current value of counter is higher than duty is then comparator results in output low.
As counter starts at zero, initially comparator gives high output and when counter crosses duty it becomes low. Hence by controlling duty, we can control duty cycle.
As the comparator is a combinational circuit and the counter is sequential, while counting from 011 to 100 due to improper delays there might be an intermediate state like 111 which might be higher or lower than duty. This might cause a glitch. To avoid these glitches output of the comparator is passed through a D flipflop.

$ sudo apt install -y git
$ git clone https://github.com/sanampudig/iiitb_pwm_gen
$ cd iiitb_pwm_gen
$ iverilog iverilog iiitb_pwm_gen.v iiitb_pwm_gen_tb.v
$ ./a.out
$ gtkwave pwm.vcd
