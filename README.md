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
  	- [7.5.1 Layout without VSDINV](#Layout-without-sky130_vsdinv)
  - [7.6 Customizing the layout](#76-Customizing-the-layout)
  	- [7.6.1 VSD INV cell creation](#761-sky130_vsdinv-cell-creation)
	- [7.6.2 layout of inverter cell](#762-layout-of-inverter-cell)
	- [7.6.3 Generating lef file](#763-Generating-lef-file)
		* [layout after placement](#layout-after-placement)
  - [7.7 Generating Layout which inculdes custom made sky130_vsdinv](#77-Generating-Layout-which-inculdes-custom-made-sky130_vsdinv)
  	- [7.7.1 invkoing openlane, running the flow in Interactive mode, loading package](#771-invkoing-openlane)
	- [7.7.2 Preparing the design](#772-Preparing-the-design)
	- [7.7.3 Synthesis](#773-Synthesis)
		* [Statistics after synthesis](#Statistics-after-synthesis)
		* [Calculation of Flop Ratio](#Calculation-of-Flop-Ratio)
	- [7.7.4 Floorplan](#774-Floorplan)
	- [7.7.5 Placement](#775-Placement)
		* [sky130_vsdinv after placement](#sky130_vsdinv-after-placement)
	- [7.7.6 CTS](#776-CTS)
		* [Clock SKEW report](#Clock-SKEW-report)
		* [Setup timing report](#Setup-timing-report)
		* [Hold timing report](#Hold-timing-report)
		* [Total Negative Slack](#Total-Negative-Slack)
		* [Wrost Neagative Slack](#Wrost-Neagative-Slack)
		* [Wrost Slack](#Wrost-Slack)
		* [Area report](#Area-report)
		* [Power Report](#Power-Report)
		* [Slew Report](#Slew-Report)
		
	- [7.7.7 Routing](#777-Routing)
		*[layout after Routing](#layout-after-Routing)
	- [](#)
	
  - [7.8 Identifing custom made sky130_vsdinv](#78-Identifing-custom-made-sky130_vsdinv)

- [8. Performance Calculation using OpenSTA](#8-Performance-Calculation-using-OpenSTA)

- [9. Parameters](#9-Parameters)
   - [9.1 Post-synthesis Gate count for your design](#91-Post-synthesis-Gate-count-for-your-design)
   - [9.2 Area of design](#92-Area-of-design)
   - [9.3 Performance GHz/MHz achieved](#93-Performance-achieved)
   - [9.4 flip-flop to standard cell ratio](#94-flip-flop-to-standard-cell-ratio)
   - [9.5 total power consumed](#95-total-power-consumed)

- [9. Contributors ](#9-Contributors)

- [10. Tapeout](#10-Tapeout)

- [11. Acknowledgments](#10-Acknowledgments)

- [12. Contact Information](#11-Contact-Information)

- [13. References](#12-References)

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


> Simulation Results while increasing Dutycycle

<img width="1037" alt="image" src="https://user-images.githubusercontent.com/110079648/185279131-14e40063-f6b1-4b14-8295-ee147363301e.png">

> Simulation Results while decreasing Dutycycle

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

- Run the following commands to syhthesize

```
$   yosys
$   yosys>    script yosys_run.sh
```

- To see diffarent types of cells after synthesys
```
$   yosys>    stat
```
- To generate schematics
```
$   yosys>    show
```
Now the synthesized netlist is written in `iiitb_pwm_gen_synth.v` file.



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

- Simulation Results while increasing Dutycycle

<img width="956" alt="image" src="https://user-images.githubusercontent.com/110079648/185278249-ebab1137-f668-4008-830e-33053b598396.png">

- Simulation Results while decreasing Dutycycle

<img width="1167" alt="image" src="https://user-images.githubusercontent.com/110079648/185278406-2b7c17cd-46fa-4636-a3de-b0f84d06aa1f.png">

### 6.3 Observations from GLS Waveforms
Output characteristics of **Functional simulation** is matched with output of **Gate Level Simulation**. 




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



### 7.3 Openlane
OpenLane is an automated RTL to GDSII flow based on several components including OpenROAD, Yosys, Magic, Netgen, CVC, SPEF-Extractor, CU-GR, Klayout and a number of custom scripts for design exploration and optimization. The flow performs full ASIC implementation steps from RTL all the way down to GDSII.

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

more at https://github.com/The-OpenROAD-Project/OpenLane
#### Openlane Installation instructions 
```
$   apt install -y build-essential python3 python3-venv python3-pip
```
- Docker installation process: https://docs.docker.com/engine/install/ubuntu/

- Goto home directory->
```
$   git clone https://github.com/The-OpenROAD-Project/OpenLane.git
$   cd OpenLane/
$   sudo make
```
- To test the Openlane
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
Goto home directory

```
$   git clone https://github.com/RTimothyEdwards/magic
$   cd magic/
$   ./configure
$   sudo make
$   sudo make install
```
Type **magic** terminal to check whether it installed succesfully or not. type **exit** to exit magic.

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

Open terminal in home directory
```
$   cd OpenLane/designs/iiitb_pwm_gen/run
$   ls
```
Select most run directoy from list 


Example:
<img width="848" alt="image" src="https://user-images.githubusercontent.com/110079648/186496088-a9884959-fb45-49d3-aab2-f7d5447e2f0f.png">

```
$  cd RUN_2022.08.24_18.20.10
```
Run following instruction
```
$   cd results/final/def
```
Update the highlited text with appropriate path 
<img width="1008" alt="image" src="https://user-images.githubusercontent.com/110079648/186496602-1468f119-e922-436e-9324-bc76dfcfa640.png">

```
$   magic -T /home/parallels/Desktop/OpenLane/pdks/sky130A/libs.tech/magic/sky130A.tech lef read ../../../tmp/merged.max.lef def read iiitb_pwm_gen.def &
```
Layout will be open in new window
#### Layout without sky130_vsdinv
- The final layout obtained after the completion of the flow in non-interactive mode is shown below:

<img width="1404" alt="image" src="https://user-images.githubusercontent.com/110079648/187451636-8cc1c492-ef3a-45d4-9466-2790b02bf80f.png">

### 7.6 Customizing the layout
#### 7.6.1 sky130_vsdinv cell creation

Here we are going to customise our layout by including our custom made sky130_vsdinv cell into our layout.

-  CREATING THE SKY130_VSDINV CELL LEF FILE

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



#### 7.6.2 layout of inverter cell

<img width="1401" alt="image" src="https://user-images.githubusercontent.com/110079648/187430540-b10c0584-7e3a-42d0-a8ac-1829bdf1ef0b.png">

- The next step is setting `port class` and `port use` attributes. The "class" and "use" properties of the port have no internal meaning to magic but are used by the LEF and DEF format read and write routines, and match the LEF/DEF CLASS and USE properties for macro cell pins. These attributes are set in tkcon window (after selecting each port on layout window. A keyboard shortcut would be,repeatedly pressing s till that port gets highlighed).

The tkcon command window of the port classification is shown in the image below:

<img width="476" alt="image" src="https://user-images.githubusercontent.com/110079648/192549705-8aeb6d36-2195-4152-b09e-04a48cfd1301.png">



#### 7.6.3 Generating lef file
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

#### 7.7.1 invkoing openlane

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
#### 7.7.2 Preparing the design
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

#### 7.7.3 Synthesis
Logic synthesis uses the RTL netlist to perform HDL technology mapping. The synthesis process is normally performed in two major steps:

- GTECH Mapping – Consists of mapping the HDL netlist to generic gates what are used to perform logical optimization based on AIGERs and other topologies created from the generic mapped netlist.

- Technology Mapping – Consists of mapping the post-optimized GTECH netlist to standard cells described in the PDK

To synthesize the code run the following command
```
% run_synthesis
```
<img width="743" alt="image" src="https://user-images.githubusercontent.com/110079648/187439336-5be0c15d-df77-42c3-97d8-21ebbf28467e.png">

#### Statistics after synthesis



> Post synthesis stat

![image](https://user-images.githubusercontent.com/110079648/192553423-55ac3c34-2cc3-4d47-833a-9fce83e89bd1.png)

#### Calculation of Flop Ratio

 ```
  
              Number of D Flip flops 
Flop ratio = -------------------------
              Total Number of cells
		     
```

![image](https://user-images.githubusercontent.com/110079648/192553505-3de38cb4-31e6-4cd7-8de5-90636a214caa.png)


#### 7.7.4 Floorplan

Goal is to plan the silicon area and create a robust power distribution network (PDN) to power each of the individual components of the synthesized netlist. In addition, macro placement and blockages must be defined before placement occurs to ensure a legalized GDS file. In power planning we create the ring which is connected to the pads which brings power around the edges of the chip. We also include power straps to bring power to the middle of the chip using higher metal layers which reduces IR drop and electro-migration problem.


* 1. Importance of files in increasing priority order:

	`floorplan.tcl` - System default envrionment variables
	`conifg.tcl`
	`sky130A_sky130_fd_sc_hd_config.tcl`
* 2. Floorplan envrionment variables or switches:

	`FP_CORE_UTIL` - floorplan core utilisation
	`FP_ASPECT_RATIO` - floorplan aspect ratio
	`FP_CORE_MARGIN` - Core to die margin area
	`FP_IO_MODE` - defines pin configurations (1 = equidistant/0 = not equidistant)
	`FP_CORE_VMETAL` - vertical metal layer
	`FP_CORE_HMETAL` - horizontal metal layer
- Note: Usually, vertical metal layer and horizontal metal layer values will be 1 more than that specified in the file



- Following command helps to run floorplan

```
% run_floorplan
```

<img width="747" alt="image" src="https://user-images.githubusercontent.com/110079648/187440792-b16a0732-5f81-42ce-a703-9a4f14b6f29b.png">

- Post the floorplan run, a .def file will have been created within the results/floorplan directory. We may review floorplan files by checking the floorplan.tcl. The system defaults will have been overriden by switches set in conifg.tcl and further overriden by switches set in sky130A_sky130_fd_sc_hd_config.tcl.

- To view the floorplan: Magic is invoked after moving to the results/floorplan directory,then use the floowing command:

```
magic -T /home/parallels/Desktop/OpenLane/pdks/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.nom.lef def read iiitb_pwm_gen.def &

```

**floorplan**

<img width="1034" alt="image" src="https://user-images.githubusercontent.com/110079648/187441298-2b97c006-d5c4-4574-9187-0006c24add4c.png">

**Die area (post floor plan)**

<img width="551" alt="image" src="https://user-images.githubusercontent.com/110079648/192584657-c9e1b04b-5c9d-4d31-8c4a-70049b009954.png">

**Core area (post floor plan)**

<img width="533" alt="image" src="https://user-images.githubusercontent.com/110079648/192584775-e62d14c8-223b-4cf7-a466-eee10f1f0560.png">


#### 7.7.5 Placement
Place the standard cells on the floorplane rows, aligned with sites defined in the technology lef file. Placement is done in two steps: Global and Detailed. In Global placement tries to find optimal position for all cells but they may be overlapping and not aligned to rows, detailed placement takes the global placement and legalizes all of the placements trying to adhere to what the global placement wants.

- The next step in the OpenLANE ASIC flow is placement. The synthesized netlist is to be placed on the floorplan. Placement is perfomed in 2 stages:

* Global Placement: It finds optimal position for all cells which may not be legal and cells may overlap. Optimization is done through reduction of half parameter wire length.
* Detailed Placement: It alters the position of cells post global placement so as to legalise them.


run the following command to run the placement

```
% run_placement
```
<img width="741" alt="image" src="https://user-images.githubusercontent.com/110079648/187442263-78757478-6ee7-4b45-b056-8e333cd3f71e.png">

- Post placement: the design can be viewed on magic within `results/placement` directory. Run the follwing command in that directory:

```
magic -T /home/parallels/Desktop/OpenLane/pdks/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.nom.lef def read iiitb_pwm_gen.def &
```
#### layout after placement

<img width="1091" alt="image" src="https://user-images.githubusercontent.com/110079648/187442955-3044bdd4-d194-4436-a07b-5aafb8ad4113.png">

#### sky130_vsdinv after placement

<img width="1399" alt="image" src="https://user-images.githubusercontent.com/110079648/192588435-aa5e227d-196b-4691-a0d8-63f8e04d60d3.png">


#### 7.7.6 CTS

- Clock tree synteshsis is used to create the clock distribution network that is used to deliver the clock to all sequential elements. The main goal is to create a network with minimal skew across the chip. H-trees are a common network topology that is used to achieve this goal.


- The purpose of building a clock tree is enable the clock input to reach every element and to ensure a zero clock skew. H-tree is a common methodology followed in CTS. Before attempting a CTS run in TritonCTS tool, if the slack was attempted to be reduced in previous run, the netlist may have gotten modified by cell replacement techniques. Therefore, the verilog file needs to be modified using the `write_verilog` command. Then, the synthesis, floorplan and placement is run again


- Run the following command to perform CTS
```
% run_cts
```

#### Clock SKEW report

<img width="534" alt="image" src="https://user-images.githubusercontent.com/110079648/192589320-602d0a94-7580-4417-91ab-7c6f05148b3f.png">

#### Setup timing report

<img width="1011" alt="image" src="https://user-images.githubusercontent.com/110079648/192590586-7e3c1c38-45ce-4317-ba40-6561a8afabd1.png">

#### Hold timing report

<img width="783" alt="image" src="https://user-images.githubusercontent.com/110079648/192590869-702a2f8e-7c14-4090-b05b-3a9909b69fac.png">

- Total Negative Slack

<img width="518" alt="image" src="https://user-images.githubusercontent.com/110079648/192591116-75ef37cc-61aa-46ea-9bf0-c4ec5621e81d.png">

- Wrost Neagative Slack

<img width="531" alt="image" src="https://user-images.githubusercontent.com/110079648/192591204-d3d00b2b-22b6-4b52-b20a-541b8f214f63.png">

- Wrost Slack

<img width="528" alt="image" src="https://user-images.githubusercontent.com/110079648/192592043-0e273efa-e6e6-4408-bb0a-e67329476b06.png">

- Area report

<img width="540" alt="image" src="https://user-images.githubusercontent.com/110079648/192591302-34e469ce-dbee-480d-b40d-b5b87b6dedc9.png">

- Power Report

<img width="707" alt="image" src="https://user-images.githubusercontent.com/110079648/192591791-74c945e2-2aea-467d-81df-ebea40dc7eeb.png">

- Slew Report

<img width="655" alt="image" src="https://user-images.githubusercontent.com/110079648/192592127-b1de95ba-4c7f-4269-bc34-32dc7bda1c16.png">


#### 7.7.7 Routing

Implements the interconnect system between standard cells using the remaining available metal layers after CTS and PDN generation. The routing is performed on routing grids to ensure minimal DRC errors.

- 1. OpenLANE uses the TritonRoute tool for routing. There are 2 stages of routing:

* Global routing: Routing region is divided into rectangle grids which are represented as course 3D routes (Fastroute tool).
* Detailed routing: Finer grids and routing guides used to implement physical wiring (TritonRoute tool).

- Features of TritonRoute:

* Honouring pre-processed route guides
* Assumes that each net satisfies inter guide connectivity
* Uses MILP based panel routing scheme
* Intra-layer parallel and inter-layer sequential routing framework

Run the following command to run the routing

```
% run_routing
```
<img width="900" alt="image" src="https://user-images.githubusercontent.com/110079648/187443941-3166fcf5-0f9b-4a33-9eff-ff2a4795a8ba.png">


**Do know in routing stage**

- `run_routing` - To start the routing
- The options for routing can be set in the `config.tcl` file.
The optimisations in routing can also be done by specifying the routing strategy to use different version of `TritonRoute Engine`. There is a trade0ff between the optimised route and the runtime for routing.
The routing stage must have the `CURRENT_DEF` set to `pdn.def`.
The two stages of routing are performed by the following engines:
Global Route : Fast Route
Detailed Route : Triton Route
Fast Route generates the routing guides, whereas Triton Route uses the Global Route and then completes the routing with some strategies and optimisations for finding the best possible path connect the pins.
- Layout in magic tool post routing: the design can be viewed on magic within `results/routing` directory. Run the follwing command in that directory:

```
magic -T /home/parallels/Desktop/OpenLane/pdks/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.nom.lef def read iiitb_pwm_gen.def &
```
#### layout after Routing

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

## 8. Performance Calculation using OpenSTA

Static timing analysis (STA) is a method of validating the timing performance of a design by checking all possible paths for timing violations. STA breaks a design down into timing paths, calculates the signal propagation delay along each path, and checks for violations of timing constraints inside the design and at the input/output interface.

> How does STA work?
When performing timing analysis, STA first breaks down the design into timing paths. Each timing path consists of the following elements:

Startpoint The start of a timing path where data is launched by a clock edge or where the data must be available at a specific time. Every startpoint must be either an input port or a register clock pin.

Combinational logic network Elements that have no memory or internal state. Combinational logic can contain AND, OR, XOR, and inverter elements, but cannot contain flip-flops, latches, registers, or RAM.

Endpoint The end of a timing path where data is captured by a clock edge or where the data must be available at a specific time. Every endpoint must be either a register data input pin or an output port.

![image](https://user-images.githubusercontent.com/110079648/192609459-b3458347-940f-4ce0-860f-9d6cde5c106e.png)

- To run STA in `Openlane` and type `sta` to enter openSTA

![image](https://user-images.githubusercontent.com/110079648/192609736-c70c3957-961b-44cb-ba32-9dd52882a7ec.png)

- Run the following commands

```
%	read_liberty -min /home/parallels/Desktop/OpenLane/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v56.lib
%	read_liberty -max /home/parallels/Desktop/OpenLane/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v56.lib
%	read_verilog /home/parallels/Desktop/OpenLane/pdks/sky130A/iiitb_pwm_gen.v
%	link_design iiitb_pwm_gen
%	read_sdc /home/parallels/Desktop/OpenLane/pdks/sky130A/iiitb_pwm_gen.sdc
%	set_propagated_clock [all_clocks]
%	report_checks

```

- To report the particular path use the following command

```
%	report_checks -from _247_ -to _244_
%	report_check -from  _247_ -to _245_
```
![image](https://user-images.githubusercontent.com/110079648/192610890-1ef7afec-a5e6-46d2-bffb-afa8d31345c4.png)


### Performance Caluculation:

```	

                                                      1
Maximum Possible Operating Frequency = -----------------------------
					  Clock period - Setup Slack
					  
					          1
				      = ---------------------  
				            65ns - 61.36ns
				            
				      = 0.274725275 GHz
```


## 9. Parameters
### 9.1 Post synthesis Gate count for your design 
Number of cells: 179
![image](https://user-images.githubusercontent.com/110079648/192614205-ded3aef5-5389-4730-9c67-6d235ad987fe.png)

### 9.2 Area of design
Area=6586.0834 micrometre^2
![image](https://user-images.githubusercontent.com/110079648/192614487-c9d961ba-4534-4c8a-8e56-83618b5b782f.png)

### 9.3 Performance achieved
Performance = 0.274725275 GHz
<img width="139" alt="image" src="https://user-images.githubusercontent.com/110079648/192614686-614212f3-da88-4a75-b1c0-010343529f23.png">

### 9.4 flip flop to standard cell ratio
flip-flop to standard cell ratio = 40/179 = 0.2235
![image](https://user-images.githubusercontent.com/110079648/192614813-a890facf-edfd-4648-8077-27f32ecc60e8.png)

### 9.5 total power consumed
Total power = 0.137mW
![image](https://user-images.githubusercontent.com/110079648/192615310-d901b639-e4ba-4487-b931-14eecec689cb.png)

## 10. Tapeout

## 11. Contributors 

- **Sanampudi Gopala Krishna Reddy** 
- **Kunal Ghosh** 



## 12. Acknowledgments


- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd.
- Nickson Jose, SoC Physical Design Engineer, Intel.
- Vinay Rayapati, Postgraduate Student, International Institute of Information Technology, Bangalore
- Gogireddy Ravi Kiran Reddy, Postgraduate Student, International Institute of Information Technology, Bangalore

## 13. Contact Information

- Sanampudi Gopala Krishna Reddy, Postgraduate Student, International Institute of Information Technology, Bangalore  svgkr7@gmail.com
- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd. kunalghosh@gmail.com

## 14. References
- FPGA4Student
 https://www.fpga4student.com/2017/08/verilog-code-for-pwm-generator.html



```
$ sudo make mount
```


```
$ sta
```

<img width="1392" alt="image" src="https://user-images.githubusercontent.com/110079648/192580358-4d0d3fa7-7344-4986-a84d-76e723e30557.png">


```
%	read_liberty -min /home/parallels/Desktop/OpenLane/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v56.lib
%	read_liberty -max /home/parallels/Desktop/OpenLane/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_n40C_1v56.lib
%	read_verilog /home/parallels/Desktop/OpenLane/pdks/sky130A/iiitb_pwm_gen.v
%	link_design iiitb_pwm_gen
%	read_sdc /home/parallels/Desktop/OpenLane/pdks/sky130A/iiitb_pwm_gen.sdc
%	set_propagated_clock [all_clocks]
%	report_checks
```
......
```
%	report_checks -from _247_ -to _244_
%	report_check -from  _247_ -to _245_
```
