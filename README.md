# iiitb_pwm_gen -> Pulse Width Modulated Wave Generator with Variable Duty Cycle

This project simulates the designed Pulse Width Modulated Wave Generator with Variable Duty Cycle. We can generate PWM wave and varry its DUTYCYCLE in steps of 10%

*Note: Circuit requires further optimization to improve performance. Design yet to be modified.*

- [1. Introduction to PWM Generator](#1-Introduction-to-PWM-Generator)
- [2. Applications](#2-Applications)
- [3. Blocked Diagram of PWM GENERATOR](#3-Blocked-Diagram-of-PWM-GENERATOR)
- [4. Functional Simulation](#4-Functional-Simulation)
  - [4.1 About iverilog](#41-About-iverilog)
  - [4.2 About GTKWave](#42-About-GTKWave)
  - [4.3 Installing iverilog and GTKWave](#43-Installing-iverilog-and-GTKWave)
  - [4.4 Functional Simulation Process](#44-Functional-Simulation-Process)
  - [4.5 Functional Characteristics](#45-Functional-Characteristics)
- [5. SYNTHESIS](#5-SYNTHESIS)
  - [5.1 About Synthesys](#51-About-Synthesys)
  - [5.2 Synthesizer](#52-Synthesizer)
- [6. GATE LEVEL SIMULATION](#6-GATE-LEVEL-SIMULATION)
  - [6.1 About GLS](#61-About-GLS)
  - [6.2 Running GLS](#62-Running-GLS)
  - [6.3 Observations from GLS Waveforms](#63-Observations-from-GLS-Waveforms)
- [7. PHYSICAL DESIGN](#7-PHYSICAL-DESIGN)
  - [7.1 Overview of Physical Design flow](#71-Overview-of-Physical-Design-flow)
  - [7.2 Opensource EDA tools](#72-Opensource-EDA-tools)
  - [7.3 Openlane](#73-Openlane)
  - [7.4 Magic](#74-Magic)
  - [7.5 Generating Layout with existing library cells](#75-Generating-Layout-with-existing-library-cells)
  - [7.6 Customizing the layout](#76-Customizing-the-layout)
  - [7.7 Generating Layout which inculdes custom made sky130_vsdinv](#77-Generating-Layout-which-inculdes-custom-made-sky130_vsdinv)
  - [7.8 Identifing custom made sky130_vsdinv](#78-Identifing-custom-made-sky130_vsdinv)
  - [7.9 Reports](#79-Reports)
- [8. Future work](#8-Future-work)
- [9. Contributors ](#9-Contributors)
- [10. Acknowledgments](#10-Acknowledgments)
- [11. Contact Information](#11-Contact-Information)
- [12. References](#12-References)

## 1. Introduction to PWM Generator
Pulse Width Modulation is a famous technique used to create modulated electronic pulses of the desired width. The duty cycle is the ratio of how long that PWM signal stays at the high position to the total time period.
<p align="center">
  <img width="800" height="500" src="/Images/pwm.jpeg">
</p>

## 2. Applications

Pulse Width Modulated Wave Generator can be used to 

- control the brightness of the LED
- drive buzzers at different loudnes
- control the angle of the servo motor
- encode messages in telecommunication
- used in speed controlers of motors

## 3. Blocked Diagram of PWM GENERATOR

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

## 4. Functional Simulation
### 4.1 About iverilog 
Icarus Verilog is an implementation of the Verilog hardware description language.
### 4.2 About GTKWave
GTKWave is a fully featured GTK+ v1. 2 based wave viewer for Unix and Win32 which reads Ver Structural Verilog Compiler generated AET files as well as standard Verilog VCD/EVCD files and allows their viewing

### 4.3 Installing iverilog and GTKWave

#### For Ubuntu

Open your terminal and type the following to install iverilog and GTKWave
```
$   sudo apt-get update
$   sudo apt-get install iverilog gtkwave
```


### 4.4 Functional Simulation Process
To clone the Repository and download the Netlist files for Simulation, enter the following commands in your terminal.
```
$   sudo apt install -y git
$   git clone https://github.com/sanampudig/iiitb_pwm_gen
$   cd iiitb_pwm_gen
$   iverilog iiitb_pwm_gen.v iiitb_pwm_gen_tb.v
$   ./a.out
$   gtkwave pwm.vcd
```

### 4.5 Functional Characteristics

<img width="1237" alt="image" src="https://user-images.githubusercontent.com/110079648/185279592-9702ac31-2086-4306-af10-21de2ba8df0d.png">


Simulation Results while increasing Dutycycle
<img width="1037" alt="image" src="https://user-images.githubusercontent.com/110079648/185279131-14e40063-f6b1-4b14-8295-ee147363301e.png">

Simulation Results while decreasing Dutycycle
<img width="1248" alt="image" src="https://user-images.githubusercontent.com/110079648/185279340-1f8f628f-98e1-44d6-867d-7fb52bb5387e.png">


## 5. SYNTHESIS
### 5.1 About Synthesys
**Synthesis**: Synthesis transforms the simple RTL design into a gate-level netlist with all the constraints as specified by the designer. In simple language, Synthesis is a process that converts the abstract form of design to a properly implemented chip in terms of logic gates.

Synthesis takes place in multiple steps:
- Converting RTL into simple logic gates.
- Mapping those gates to actual technology-dependent logic gates available in the technology libraries.
- Optimizing the mapped netlist keeping the constraints set by the designer intact.

### 5.2 Synthesizer

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



## 6. GATE LEVEL SIMULATION
### 6.1 About GLS
GLS is generating the simulation output by running test bench with netlist file generated from synthesis as design under test. Netlist is logically same as RTL code, therefore, same test bench can be used for it.We perform this to verify logical correctness of the design after synthesizing it. Also ensuring the timing of the design is met.
### 6.2 Running GLS
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

### 6.3 Observations from GLS Waveforms
Output characteristics of Functional simulation is matched with output of Gate Level Simulation. 

## 7. PHYSICAL DESIGN

### 7.1 Overview of Physical Design flow
Place and Route (PnR) is the core of any ASIC implementation and Openlane flow integrates into it several key open source tools which perform each of the respective stages of PnR.
Below are the stages and the respective tools that are called by openlane for the functionalities as described:

![image](https://user-images.githubusercontent.com/110079648/187492890-1c91bb6d-596e-47da-b4c6-592d25bbec10.png)


### 7.2 Opensource EDA tools

OpenLANE utilises a variety of opensource tools in the execution of the ASIC flow:
Task | Tool/s
------------ | -------------
RTL Synthesis & Technology Mapping | [yosys](https://github.com/YosysHQ/yosys), abc
Floorplan & PDN | init_fp, ioPlacer, pdn and tapcell
Placement | RePLace, Resizer, OpenPhySyn & OpenDP
Static Timing Analysis | [OpenSTA](https://github.com/The-OpenROAD-Project/OpenSTA)
Clock Tree Synthesis | [TritonCTS](https://github.com/The-OpenROAD-Project/OpenLane)
Routing | FastRoute and [TritonRoute](https://github.com/The-OpenROAD-Project/TritonRoute) 
SPEF Extraction | [SPEF-Extractor](https://github.com/HanyMoussa/SPEF_EXTRACTOR)
DRC Checks, GDSII Streaming out | [Magic](https://github.com/RTimothyEdwards/magic), [Klayout](https://github.com/KLayout/klayout)
LVS check | [Netgen](https://github.com/RTimothyEdwards/netgen)
Circuit validity checker | [CVC](https://github.com/d-m-bailey/cvc)

#### OpenLANE design stages

1. Synthesis
	- `yosys` - Performs RTL synthesis
	- `abc` - Performs technology mapping
	- `OpenSTA` - Performs static timing analysis on the resulting netlist to generate timing reports
2. Floorplan and PDN
	- `init_fp` - Defines the core area for the macro as well as the rows (used for placement) and the tracks (used for routing)
	- `ioplacer` - Places the macro input and output ports
	- `pdn` - Generates the power distribution network
	- `tapcell` - Inserts welltap and decap cells in the floorplan
3. Placement
	- `RePLace` - Performs global placement
	- `Resizer` - Performs optional optimizations on the design
	- `OpenDP` - Perfroms detailed placement to legalize the globally placed components
4. CTS
	- `TritonCTS` - Synthesizes the clock distribution network (the clock tree)
5. Routing
	- `FastRoute` - Performs global routing to generate a guide file for the detailed router
	- `CU-GR` - Another option for performing global routing.
	- `TritonRoute` - Performs detailed routing
	- `SPEF-Extractor` - Performs SPEF extraction
6. GDSII Generation
	- `Magic` - Streams out the final GDSII layout file from the routed def
	- `Klayout` - Streams out the final GDSII layout file from the routed def as a back-up
7. Checks
	- `Magic` - Performs DRC Checks & Antenna Checks
	- `Klayout` - Performs DRC Checks
	- `Netgen` - Performs LVS Checks
	- `CVC` - Performs Circuit Validity Checks

  - 
### 7.3 Openlane
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

### 7.4 Magic
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

### 7.5 Generating Layout with existing library cells
**NON-INTERACTIVE MODE:** Here we are generating the layout in the non-interactive mode or the automatic mode. In this we cant interact with the flow in the middle of each stage of the flow.The flow completes all the stages starting from synthesis until you obtain the final layout and the reports of various stages which specify the violations and problems if present during the flow.

- Open terminal in home directory

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
#### layout - without sky130_vsdinv
- The final layout obtained after the completion of the flow in non-interactive mode is shown below:

<img width="1404" alt="image" src="https://user-images.githubusercontent.com/110079648/187451636-8cc1c492-ef3a-45d4-9466-2790b02bf80f.png">

### 7.6 Customizing the layout
#### sky130_vsdinv cell creation

Here we are going to customise our layout by including our custom made sky130_vsdinv cell into our layout.

- 1 . CREATING THE SKY130_VSDINV CELL LEF FILE

   -You need to first get the git repository of the vsdstdccelldesign.To get the    repository type the following command:


```
$ git clone https://github.com/nickson-jose/vsdstdcelldesign
```

<img width="875" alt="image" src="https://user-images.githubusercontent.com/110079648/187428540-c5fc6ace-76d6-45d0-8133-4dccb649a1b3.png">

<img width="603" alt="image" src="https://user-images.githubusercontent.com/110079648/187429095-09758379-48fb-435a-bf32-5f5d5b0c232c.png">

- Now you need to copy your tech file sky130A.tech to this folder.

- Next run the magic command to open the sky130_vsdinv.mag file.Use the following command:

```
$ magic -T sky130A.tech sky130_inv.mag 
```
- One can zoom into Magic layout by selecting an area with left and right mouse click followed by pressing "z" key.
- Various components can be identified by using the what command in tkcon window after making a selection on the component.
- The image showing the invoked magic tool using the above command:



#### layout of inverter cell

<img width="1401" alt="image" src="https://user-images.githubusercontent.com/110079648/187430540-b10c0584-7e3a-42d0-a8ac-1829bdf1ef0b.png">

- The next step is setting `port class` and `port use` attributes. The "class" and "use" properties of the port have no internal meaning to magic but are used by the LEF and DEF format read and write routines, and match the LEF/DEF CLASS and USE properties for macro cell pins. These attributes are set in tkcon window (after selecting each port on layout window. A keyboard shortcut would be,repeatedly pressing s till that port gets highlighed).

The tkcon command window of the port classification is shown in the image below:

<img width="476" alt="image" src="https://user-images.githubusercontent.com/110079648/192549705-8aeb6d36-2195-4152-b09e-04a48cfd1301.png">



#### Generating lef file
- In the next step, use `lef write` command to write the LEF file with the same nomenclature as that of the layout `.mag` file. This will create a **sky130_vsdinv.lef** file in the same folder.
   

in tkcon terminal type the following command to generate **.lef** file

```
% lef write sky130_vsdinv
```

<img width="499" alt="image" src="https://user-images.githubusercontent.com/110079648/187432010-5506b422-3aac-4f9d-a6b5-9d25019be775.png">

Copy the generated lef file to designs/iiit_pwm_gen/src
Also copy lib files from vsdcelldesign/libs to designs/iiit_pwm_gen/src

<img width="1396" alt="image" src="https://user-images.githubusercontent.com/110079648/187434252-1ef1d250-157d-4298-b24b-4b350fd1cba7.png">

- Next modify the `config.json` file in our design to folloing code:

<img width="712" alt="image" src="https://user-images.githubusercontent.com/110079648/192551224-ba918ff7-a617-4fbc-9a53-81f10a3d02b5.png">

```
{
  "DESIGN_NAME": "iiitb_pwm_gen",
  "VERILOG_FILES": "dir::src/iiitb_pwm_gen.v",
  "CLOCK_PORT": "clk",
  "CLOCK_NET": "clk",
  "FP_SIZING": "relative",
  "LIB_SYNTH" : "dir::src/sky130_fd_sc_hd__typical.lib",
  "LIB_FASTEST" : "dir::src/sky130_fd_sc_hd__fast.lib",
  "LIB_SLOWEST" : "dir::src/sky130_fd_sc_hd__slow.lib",
  "LIB_TYPICAL":"dir::src/sky130_fd_sc_hd__typical.lib",
  "TEST_EXTERNAL_GLOB":"dir::../sd_fsm/src/*",
  "SYNTH_DRIVING_CELL":"sky130_vsdinv",
  "pdk::sky130*": {
    "FP_CORE_UTIL": 35,
    "CLOCK_PERIOD": 24,
    "scl::sky130_fd_sc_hd": {
      "FP_CORE_UTIL": 30
    }
  }
}

```
this config file is avilable in repo under name `config1.json`.

### 7.7 Generating Layout which inculdes custom made sky130_vsdinv

#### invkoing openlane

Goto openlane directory and open terminal there

```
$ sudo make mount
```
<img width="723" alt="image" src="https://user-images.githubusercontent.com/110079648/187436509-69de182c-6681-4761-b298-ae0f79d0d05a.png">

- INTERACTIVE MODE: We need to run the openlane now in the interactive mode to include our custom made lef file before synthesis.Such that the openlane recognises our lef files during the flow for mapping.

- Running openlane in interactive mode: The commands to the run the flow in interactive mode is given below:


```
$ ./flow.tcl -interactive
```

Loading the package file

```
% package require openlane 0.9
```

- Preparing the design and including the lef files: The commands to prepare the design and overwite in a existing run folder the reports and results along with the command to include the lef files is given below:

```
% prep -design iiitb_pwm_gen
```
<img width="1401" alt="image" src="https://user-images.githubusercontent.com/110079648/187437865-3302f063-dccb-495a-8f64-22459ab565e1.png">

Include the below command to include the additional lef (i.e sky130_vsdinv) into the flow:

```
% set lefs [glob $::env(DESIGN_DIR)/src/*.lef]
% add_lefs -src $lefs
```
<img width="747" alt="image" src="https://user-images.githubusercontent.com/110079648/187438840-95daa5e5-140d-45f4-b5d0-4752660d5fb6.png">

#### Synthesis
Logic synthesis uses the RTL netlist to perform HDL technology mapping. The synthesis process is normally performed in two major steps:

- GTECH Mapping – Consists of mapping the HDL netlist to generic gates what are used to perform logical optimization based on AIGERs and other topologies created from the generic mapped netlist.

- Technology Mapping – Consists of mapping the post-optimized GTECH netlist to standard cells described in the PDK

to synthesize the code run the following command
```
% run_synthesis
```
<img width="743" alt="image" src="https://user-images.githubusercontent.com/110079648/187439336-5be0c15d-df77-42c3-97d8-21ebbf28467e.png">

#### Statistics after synthesis



> post synthesis stat

![image](https://user-images.githubusercontent.com/110079648/192553423-55ac3c34-2cc3-4d47-833a-9fce83e89bd1.png)

#### Calculation of Flop Ratio

 ```
  
        	      Number of D Flip flops 
  Flop ratio =      -------------------------
                      Total Number of cells
		     
```

![image](https://user-images.githubusercontent.com/110079648/192553505-3de38cb4-31e6-4cd7-8de5-90636a214caa.png)


#### Floorplan

Goal is to plan the silicon area and create a robust power distribution network (PDN) to power each of the individual components of the synthesized netlist. In addition, macro placement and blockages must be defined before placement occurs to ensure a legalized GDS file. In power planning we create the ring which is connected to the pads which brings power around the edges of the chip. We also include power straps to bring power to the middle of the chip using higher metal layers which reduces IR drop and electro-migration problem.

  * **1. Importance of files in increasing priority order:**

        1. `floorplan.tcl` - System default envrionment variables
        2. `conifg.tcl`
        3. `sky130A_sky130_fd_sc_hd_config.tcl`
        
      * **2. Floorplan envrionment variables or switches:**

        1. ```FP_CORE_UTIL``` - floorplan core utilisation
        2. ```FP_ASPECT_RATIO``` - floorplan aspect ratio
        3. ```FP_CORE_MARGIN``` - Core to die margin area
        4. ```FP_IO_MODE``` - defines pin configurations (1 = equidistant/0 = not equidistant)
        5. ```FP_CORE_VMETAL``` - vertical metal layer
        6. ```FP_CORE_HMETAL``` - horizontal metal layer
           
        ```Note: Usually, vertical metal layer and horizontal metal layer values will be 1 more than that specified in the file```

- Following command helps to run floorplan

```
% run_floorplan
```

<img width="747" alt="image" src="https://user-images.githubusercontent.com/110079648/187440792-b16a0732-5f81-42ce-a703-9a4f14b6f29b.png">

**floorplan**

<img width="1034" alt="image" src="https://user-images.githubusercontent.com/110079648/187441298-2b97c006-d5c4-4574-9187-0006c24add4c.png">

#### Placement
Place the standard cells on the floorplane rows, aligned with sites defined in the technology lef file. Placement is done in two steps: Global and Detailed. In Global placement tries to find optimal position for all cells but they may be overlapping and not aligned to rows, detailed placement takes the global placement and legalizes all of the placements trying to adhere to what the global placement wants.

run the following command to run the placement

```
% run_placement
```
<img width="741" alt="image" src="https://user-images.githubusercontent.com/110079648/187442263-78757478-6ee7-4b45-b056-8e333cd3f71e.png">

**layout after floorplan**

<img width="1091" alt="image" src="https://user-images.githubusercontent.com/110079648/187442955-3044bdd4-d194-4436-a07b-5aafb8ad4113.png">


#### CTS

Clock tree synteshsis is used to create the clock distribution network that is used to deliver the clock to all sequential elements. The main goal is to create a network with minimal skew across the chip. H-trees are a common network topology that is used to achieve this goal.

run the following command to perform CTS
```
% run_cts
```


#### Routing

Implements the interconnect system between standard cells using the remaining available metal layers after CTS and PDN generation. The routing is performed on routing grids to ensure minimal DRC errors.

run the following command to run the routing

```
% run_routing
```
<img width="900" alt="image" src="https://user-images.githubusercontent.com/110079648/187443941-3166fcf5-0f9b-4a33-9eff-ff2a4795a8ba.png">

**layout after Routing**

<img width="1115" alt="image" src="https://user-images.githubusercontent.com/110079648/187444627-f46468d6-a0fb-4f2b-9215-9a1f3b33bf2d.png">

<img width="1400" alt="image" src="https://user-images.githubusercontent.com/110079648/187444803-1776099a-ebcc-422b-a0ac-a723d93c0eb6.png">


### 7.8 Identifing custom made sky130_vsdinv

in tkcon type the follow command to check where sky130_vsdinv exist or not
```
% getcell sky130_vsdinv
```
<img width="1201" alt="image" src="https://user-images.githubusercontent.com/110079648/187445444-627a4fd3-97a2-4c48-96bb-d2c99435cab0.png">

<img width="713" alt="image" src="https://user-images.githubusercontent.com/110079648/187445684-2ea3630b-720f-4cdd-93ce-b59483dcf221.png">

Seven sky130_vsdinv cells present in design

sky130_vsdinv _ _138_ _

sky130_vsdinv _ _158_ _

sky130_vsdinv _ _167_ _

sky130_vsdinv _ _169_ _

sky130_vsdinv _ _170_ _

sky130_vsdinv _ _171_ _

sky130_vsdinv _ _172_ _

<img width="1262" alt="image" src="https://user-images.githubusercontent.com/110079648/187447519-0028b1fa-bfb5-4360-bef3-ab980b24bd15.png">

<img width="543" alt="image" src="https://user-images.githubusercontent.com/110079648/187447979-27aaaeb0-1da4-41df-aaaa-df5e17e0e976.png">


### 7.9 Reports

<img width="365" alt="image" src="https://user-images.githubusercontent.com/110079648/187456325-b861497f-b683-4532-a0dd-ae74932f3210.png">

<img width="282" alt="image" src="https://user-images.githubusercontent.com/110079648/187456402-e3dc80ec-0413-43dd-8dc1-de23ab4aa120.png">

<img width="652" alt="image" src="https://user-images.githubusercontent.com/110079648/187456862-d3c4ea27-ad68-4ee0-9dcb-c61a1db4877c.png">

<img width="321" alt="image" src="https://user-images.githubusercontent.com/110079648/187457004-a00ceb95-83bc-48d7-bf4a-0c1d138e3bcf.png">



## 8. Future work
working on **GLS for post-layout netlist**.




## 9. Contributors 

- **Sanampudi Gopala Krishna Reddy** 
- **Kunal Ghosh** 



## 10. Acknowledgments


- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd.
- Nickson Jose, SoC Physical Design Engineer, Intel.
- Vinay Rayapati, Postgraduate Student, International Institute of Information Technology, Bangalore
- Gogireddy Ravi Kiran Reddy, Postgraduate Student, International Institute of Information Technology, Bangalore

## 11. Contact Information

- Sanampudi Gopala Krishna Reddy, Postgraduate Student, International Institute of Information Technology, Bangalore  svgkr7@gmail.com
- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd. kunalghosh@gmail.com

## 12. References
- FPGA4Student
 https://www.fpga4student.com/2017/08/verilog-code-for-pwm-generator.html
