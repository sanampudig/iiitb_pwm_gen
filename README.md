# iiitb_pwm_gen --- Pulse Width Modulated Wave Generator with Variable Duty Cycle

This project simulates the designed Pulse Width Modulated Wave Generator with Variable Duty Cycle. We can generate PWM wave and varry its DUTYCYCLE in steps of 10%. 

*Note: Circuit requires further optimization to improve performance. Design yet to be modified.*

## Introduction
Pulse Width Modulation is a famous technique used to create modulated electronic pulses of the desired width. The duty cycle is the ratio of how long that PWM signal stays at the high position to the total time period.
<p align="center">
  <img width="800" height="500" src="/Images/pwm.jpeg">
</p>
## Applications
Pulse Width Modulated Wave Generator can be used to 

- control the brightness of the LED
- drive buzzers at different loudnes
- control the angle of the servo motor
- encode messages in telecommunication
- used in speed controlers of motors

## Blocked Diagram of PWM GENERATOR


PWM Generator
Pulse Width Modulation is a famous technique used to create modulated electronic pulses of the desired width. The duty cycle is the ratio of how long that PWM signal stays at the high position to the total time period.
In this specific circuit, we mainly require a n-bit counter and comparator. Duty given to the comparator is compared with the current value of the counter. If current value of counter is lower than duty then comparator results in output high. Similarly, If current value of counter is higher than duty is then comparator results in output low.
As counter starts at zero, initially comparator gives high output and when counter crosses duty it becomes low. Hence by controlling duty, we can control duty cycle.
As the comparator is a combinational circuit and the counter is sequential, while counting from 011 to 100 due to improper delays there might be an intermediate state like 111 which might be higher or lower than duty. This might cause a glitch. To avoid these glitches output of the comparator is passed through a D flipflop.

### Functional Simulation
To clone the Repository and download the Netlist files for Simulation, enter the following commands in your terminal.
```
$   sudo apt install -y git
$   git clone https://github.com/sanampudig/iiitb_pwm_gen
$   cd iiitb_pwm_gen
$  iverilog iverilog iiitb_pwm_gen.v iiitb_pwm_gen_tb.v
$  ./a.out
$  gtkwave pwm.vcd
```


