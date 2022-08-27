# iiitb_pwm_gen -> Pulse Width Modulated Wave Generator with Variable Duty Cycle

This project simulates the designed Pulse Width Modulated Wave Generator with Variable Duty Cycle. We can generate PWM wave and varry its DUTYCYCLE in steps of 10%

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

<img width="1237" alt="image" src="https://user-images.githubusercontent.com/110079648/185279592-9702ac31-2086-4306-af10-21de2ba8df0d.png">


Simulation Results while increasing Dutycycle
<img width="1037" alt="image" src="https://user-images.githubusercontent.com/110079648/185279131-14e40063-f6b1-4b14-8295-ee147363301e.png">

Simulation Results while decreasing Dutycycle
<img width="1248" alt="image" src="https://user-images.githubusercontent.com/110079648/185279340-1f8f628f-98e1-44d6-867d-7fb52bb5387e.png">


### SYNTHESIS
**Synthesis**: Synthesis transforms the simple RTL design into a gate-level netlist with all the constraints as specified by the designer. In simple language, Synthesis is a process that converts the abstract form of design to a properly implemented chip in terms of logic gates.

Synthesis takes place in multiple steps:
- Converting RTL into simple logic gates.
- Mapping those gates to actual technology-dependent logic gates available in the technology libraries.
- Optimizing the mapped netlist keeping the constraints set by the designer intact.

**Synthesizer**: It is a tool we use to convert out RTL design code to netlist. Yosys is the tool I've used in this project.

#### About Yosys
Yosys is a framework for Verilog RTL synthesis. It currently has extensive Verilog-2005 support and provides a basic set of synthesis algorithms for various application domains.

- more at https://yosyshq.net/yosys/

To install yosys follow the instructions in  this github repository

https://github.com/YosysHQ/yosys

Now you need to create a yosys_run.sh file , which is the yosys script file used to run the synthesis.
The contents of the yosys_run file are given below:

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
Now the synthesized netlist is written in "iiitb_pwm_gen_synth.v" file.
### GATE LEVEL SIMULATION(GLS)
GLS is generating the simulation output by running test bench with netlist file generated from synthesis as design under test. Netlist is logically same as RTL code, therefore, same test bench can be used for it.We perform this to verify logical correctness of the design after synthesizing it. Also ensuring the timing of the design is met.
Folllowing are the commands to run the GLS simulation:
```
iverilog -DFUNCTIONAL -DUNIT_DELAY=#1 ../verilog_model/primitives.v ../verilog_model/sky130_fd_sc_hd.v iiitb_pwm_gen_synth.v iiitb_pwm_gen_tb.v
./a.out
gtkwave pwm.vcd
```
The gtkwave output for the netlist should match the output waveform for the RTL design file. As netlist and design code have same set of inputs and outputs, we can use the same testbench and compare the waveforms.
#### GLS Waveforms
<img width="1219" alt="image" src="https://user-images.githubusercontent.com/110079648/185278697-7a63d943-ca46-4a22-87f4-4e0750bd0a5c.png">

Simulation Results while increasing Dutycycle

<img width="956" alt="image" src="https://user-images.githubusercontent.com/110079648/185278249-ebab1137-f668-4008-830e-33053b598396.png">

Simulation Results while decreasing Dutycycle

<img width="1167" alt="image" src="https://user-images.githubusercontent.com/110079648/185278406-2b7c17cd-46fa-4636-a3de-b0f84d06aa1f.png">

#### Observation:
Output characteristics of Functional simulation is matched with output of Gate Level Simulation. 

## PHYSICAL DESIGN
#### Openlane
OpenLane is an automated RTL to GDSII flow based on several components including OpenROAD, Yosys, Magic, Netgen, CVC, SPEF-Extractor, CU-GR, Klayout and a number of custom scripts for design exploration and optimization. The flow performs full ASIC implementation steps from RTL all the way down to GDSII.

more at https://github.com/The-OpenROAD-Project/OpenLane
#### Installation instructions 
```
$   apt install -y build-essential python3 python3-venv python3-pip
```
Docker installation process: https://docs.docker.com/engine/install/ubuntu/

goto home directory->
```
$   git clone https://github.com/The-OpenROAD-Project/OpenLane.git
$   cd OpenLane/
$   sudo make
```
To test the open lane
```
$ sudo make test
```
It takes approximate time of 5min to complete. After 43 steps, if it ended with saying **Basic test passed** then open lane installed succesfully.

#### Magic
Magic is a venerable VLSI layout tool, written in the 1980's at Berkeley by John Ousterhout, now famous primarily for writing the scripting interpreter language Tcl. Due largely in part to its liberal Berkeley open-source license, magic has remained popular with universities and small companies. The open-source license has allowed VLSI engineers with a bent toward programming to implement clever ideas and help magic stay abreast of fabrication technology. However, it is the well thought-out core algorithms which lend to magic the greatest part of its popularity. Magic is widely cited as being the easiest tool to use for circuit layout, even for people who ultimately rely on commercial tools for their product design flow.

More about magic at http://opencircuitdesign.com/magic/index.html

Run following commands one by one to fulfill the system requirement.

```
$   sudo apt-get install m4
$   sudo apt-get install tcsh
$   sudo apt-get install csh
$   sudo apt-get install libx11-dev
$   sudo apt-get install tcl-dev tk-dev
$   sudo apt-get install libcairo2-dev
$   sudo apt-get install mesa-common-dev libglu1-mesa-dev
$   sudo apt-get install libncurses-dev
```
**To install magic**
goto home directory

```
$   git clone https://github.com/RTimothyEdwards/magic
$   cd magic/
$   ./configure
$   sudo make
$   sudo make install
```
type **magic** terminal to check whether it installed succesfully or not. type **exit** to exit magic.

**Generating Layout**


Open terminal in home directory
```
$   cd OpenLane/
$   cd designs/
$   mkdir iiitb_pwm_gen
$   cd iiitb_pwm_gen/
$   wget https://raw.githubusercontent.com/sanampudig/iiitb_pwm_gen/main/config.json
$   mkdir src
$   cd src/
$   wget https://raw.githubusercontent.com/sanampudig/iiitb_pwm_gen/main/iiitb_pwm_gen.v
$   cd ../../../
$   sudo make mount
$   ./flow.tcl -design iiitb_pwm_gen
```
<img width="733" alt="image" src="https://user-images.githubusercontent.com/110079648/186494386-7895f02b-1120-435e-92a6-fdc55fe6de3b.png">

To see the layout we use a tool called magic which we installed earlier.

open terminal in home directory
```
$   cd OpenLane/designs/iiitb_pwm_gen/run
$   ls
```
select most run directoy from list 


example:
<img width="848" alt="image" src="https://user-images.githubusercontent.com/110079648/186496088-a9884959-fb45-49d3-aab2-f7d5447e2f0f.png">

```
$  cd RUN_2022.08.24_18.20.10
```
run following instruction
```
$   cd results/final/def
```
update the highlited text with appropriate path 
<img width="1008" alt="image" src="https://user-images.githubusercontent.com/110079648/186496602-1468f119-e922-436e-9324-bc76dfcfa640.png">

```
$   magic -T /home/parallels/Desktop/OpenLane/pdks/sky130A/libs.tech/magic/sky130A.tech lef read ../../../tmp/merged.max.lef def read iiitb_pwm_gen.def &
```
layout will be open in new window
#### layout

<img width="889" alt="image" src="https://user-images.githubusercontent.com/110079648/186497274-c053b6a9-33e3-40d1-b94e-8ffb237ddb13.png">







## Future work:
working on **GLS for post-layout netlist**.




## Contributors 

- **Sanampudi Gopala Krishna Reddy** 
- **Kunal Ghosh** 



## Acknowledgments


- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd.
- Vinay Rayapati, Postgraduate Student, International Institute of Information Technology, Bangalore
- Gogireddy Ravi Kiran Reddy, Postgraduate Student, International Institute of Information Technology, Bangalore

## Contact Information

- Sanampudi Gopala Krishna Reddy, Postgraduate Student, International Institute of Information Technology, Bangalore  svgkr7@gmail.com
- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd. kunalghosh@gmail.com

## References:
- FPGA4Student
 https://www.fpga4student.com/2017/08/verilog-code-for-pwm-generator.html
