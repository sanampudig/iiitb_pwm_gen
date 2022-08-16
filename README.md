# iiitb_pwm_gen -> Pulse Width Modulated Wave Generator with Variable Duty Cycle

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

This PWM generator generates 10Mhz signal. We can control duty cycles in steps of 10%. The default duty cycle is 50%. Along with clock signal we provide another two external signals to increase and decrease the duty cycle.


<p align="center">
  <img width="800" height="400" src="/Images/BasicBlockedDeagram.jpeg">
</p>

In this specific circuit, we mainly require a n-bit counter and comparator. Duty given to the comparator is compared with the current value of the counter. If current value of counter is lower than duty then comparator results in output high. Similarly, If current value of counter is higher than duty is then comparator results in output low.
As counter starts at zero, initially comparator gives high output and when counter crosses duty it becomes low. Hence by controlling duty, we can control duty cycle.

<p align="center">
  <img width="800" height="300" src="/Images/BlockDiagram.jpeg">
</p>

As the comparator is a combinational circuit and the counter is sequential, while counting from 011 to 100 due to improper delays there might be an intermediate state like 111 which might be higher or lower than duty. This might cause a glitch. To avoid these glitches output of the comparator is passed through a D flipflop.

## About iverilog 
Icarus Verilog is an implementation of the Verilog hardware description language.
## About GTKWave
GTKWave is a fully featured GTK+ v1. 2 based wave viewer for Unix and Win32 which reads Ver Structural Verilog Compiler generated AET files as well as standard Verilog VCD/EVCD files and allows their viewing

### Installing iverilog and GTKWave

#### For Ubuntu

Open your terminal and type the following to install iverilog and GTKWave
```
$   sudo apt-get update
$   sudo apt-get install iverilog gtkwave
```


### Functional Simulation
To clone the Repository and download the Netlist files for Simulation, enter the following commands in your terminal.
```
$   sudo apt install -y git
$   git clone https://github.com/sanampudig/iiitb_pwm_gen
$   cd iiitb_pwm_gen
$   iverilog iiitb_pwm_gen.v iiitb_pwm_gen_tb.v
$   ./a.out
$   gtkwave pwm.vcd
```

## Functional Characteristics
Simulation Results while increasing Dutycycle
<p align="center">
  <img width="800" height="300" src="/Images/incPWM.jpeg">
</p>

Simulation Results while decreasing Dutycycle
<p align="center">
  <img width="800" height="300" src="/Images/decPWM.jpeg">
</p>


### SYNTHESIS
**Synthesis**: Synthesis transforms the simple RTL design into a gate-level netlist with all the constraints as specified by the designer. In simple language, Synthesis is a process that converts the abstract form of design to a properly implemented chip in terms of logic gates.

Synthesis takes place in multiple steps:
- Converting RTL into simple logic gates.
- Mapping those gates to actual technology-dependent logic gates available in the technology libraries.
- Optimizing the mapped netlist keeping the constraints set by the designer intact.

**Synthesizer**: It is a tool we use to convert out RTL design code to netlist. Yosys is the tool I've used in this project.
## synthesis of verilog code

#### About Yosys
Yosys is a framework for Verilog RTL synthesis. It currently has extensive Verilog-2005 support and provides a basic set of synthesis algorithms for various application domains.

- more at https://yosyshq.net/yosys/

To install yosys follow the instructions in  this github repository

https://github.com/YosysHQ/yosys

Now you need to create a yosys_run.sh file , which is the yosys script file used to run the synthesis.
The contents of the yosys_run file are given below:

```
# read design

read_verilog iiitb_pwm_gen.v

# generic synthesis
synth -top iiitb_pwm_gen

# mapping to mycells.lib
dfflibmap -liberty /home/svgkr7/Desktop/iiitb_pwm_gen/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
abc -liberty /home/svgkr7/Desktop/iiitb_pwm_gen/lib/sky130_fd_sc_hd__tt_025C_1v80.lib -script +strash;scorr;ifraig;retime,{D};strash;dch,-f;map,-M,1,{D}
clean
flatten
# write synthesized design
write_verilog -noattr iiitb_pwm_gen_synth.v

```


- note: Identify the .lib file path in cloned folder and change the path in highlighted text to indentified path

<img width="1119" alt="image" src="https://user-images.githubusercontent.com/110079648/182905357-064fec34-3c2b-4997-a0b7-30453f505ddd.png">

Now, in the terminal of your verilog files folder, run the following commands:


#### to synthesize
```
$   yosys
$   yosys>    script yosys_run.sh
```

#### to see diffarent types of cells after synthesys
```
$   yosys>    stat
```
#### to generate schematics
```
$   yosys>    show
```


## Contributors 

- **Sanampudi Gopala Krishna Reddy** 
- **Kunal Ghosh** 



## Acknowledgments


- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd.

## Contact Information

- Sanampudi Gopala Krishna Reddy, Postgraduate Student, International Institute of Information Technology, Bangalore  svgkr7@gmail.com
- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd. kunalghosh@gmail.com

## References:
- FPGA4Student
 https://www.fpga4student.com/2017/08/verilog-code-for-pwm-generator.html
