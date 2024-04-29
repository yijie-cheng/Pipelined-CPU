# Verilog Pipelined-CPU Simulation

The Verilog source code for a Pipelined-CPU with 2-bit Dynamic Branch Predictor simulation.

Developer: Yi-Jie Cheng

Course: NTU CSIE 3340 Computer Architecture, Fall 2023

Instructor: Chia-Lin Yang

## Overview

The CPU simulation project includes multiple modules that simulate different aspects of a CPU within a pipelined architecture. The modules are designed to handle various tasks such as branch prediction, control signal generation, ALU operations, and data forwarding among others.

### Modules

- **Branch_Predictor**: A 2-bit dynamic branch predictor that uses a state machine to predict branch decisions.
- **Control**: Generates control signals based on opcode inputs, managing operations like ALU operation, memory read/write, and branch decisions.
- **ALU_Control**: Determines ALU control signals from function codes and ALU operation codes.
- **ALU**: Performs arithmetic and logic operations, providing output and a zero flag.
- **Pipeline Registers**: (`IF_ID`, `ID_EX`, `EX_MEM`, `MEM_WB`) These modules handle the transfer of data between different stages of the pipeline.
- **MUX32**: A 32-bit multiplexer for selecting inputs based on control signals.
- **Adder**: Simple addition operation module.
- **Imm_Gen**: Generates immediate values from instruction bits.
- **Hazard_Detection**: Detects and manages data hazards by controlling the pipeline behavior.
- **Forwarding_Unit**: Manages data forwarding to resolve data hazards.
- **CPU**: Top-level module that integrates all components and controls the data and instruction flow.

### Features

- 2-bit dynamic branch prediction with a state transition table.
- Detailed control signal management based on opcodes.
- ALU supporting various arithmetic and logic operations.
- Implementation of forwarding and hazard detection to handle pipeline data dependencies.


## Development Environment

- **OS**: MacOS
- **Compiler**: Icarus Verilog (iverilog)

## Setup and Running

1. Ensure Icarus Verilog is installed on your system. If not, you can install it using Homebrew: ```brew install icarus-verilog```

2. Clone this repository: ```git clone https://github.com/your-username/verilog-cpu-simulation.git; cd verilog-cpu-simulation```

3. Copy testcase to root directory: ```cp testcases/instruction_n.txt instruction.txt```

4. Compile and run the simulation: ```iverilog -o cpu_simulation code/src/*.v code/supplied/*.v; vvp cpu_simulation```


