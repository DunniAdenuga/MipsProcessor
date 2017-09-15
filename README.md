# A Single Cycle MipsProcessor 

## Design
This program was designed in a modularized format. Each module handles a specific function. For example, the control module is designed to only assign control signals to different type of instructions. Every related module is stored in a single file. For example the dataMemory module is stored in the dataMemory file which also has the mux after the data memory. This makes it easy to easily locate essential modules while following the single processor diagram. In the smooth design vein, the naming convention for the modules and internal variables is very descriptive. For example, muxes are named after the module they relate to like the "muxForAlu" module. This signifies that the result from this mux interacts directly with the ALU. 

Some of the modules implemented include the pcRegister, which is assigned the duty of evaluating the address for the next instruction,  the adder module computes the value of the next address while the memory module performs the function of reading the instruction from the specified address. The ALU contains the ALU control and performs the functionality of combining the values of specified registers depending on the operation specified by the instruction. The registers module holds data and writes it out when it receives the right signal. The control module send the appropriate signals as specified in an instruction. These modules were designed to function individually. The testbench module combines their functionality by wiring results from different modules into modules where they're required as shown in the diagram below. 

![alt text](https://github.com/DunniAdenuga/MipsProcessor/blob/master/designPic.png)

## Compilation
It is important to have the specified Makefile and add_test.s (assembly code instructions for adding two numbers). Then, you `make`. This creates the file *add_test.v* with the necessary instructions for testing the processor. This program makes use of the "mips.h" file too.
To compile, you run: 
                  `iverilog main.v pcRegister.v registers.v alu.v control.v dataMemory.v`

## Execution
After compiling, run: 
                      `./a.out`

To see more detailed graphical results, you should run:  `gtkwave test.vcd`

### Sample Result:

![alt text](https://github.com/DunniAdenuga/MipsProcessor/blob/master/Execution.png)

![alt text](https://github.com/DunniAdenuga/MipsProcessor/blob/master/GTKWave.png)

## Testing
The Single Mips processor was successfully tested with the add immediate unsigned(ADDIU) and syscall instructions. These instructions test the ability of the instruction memory, arithmetic logic unit, the control module and registers module.
A testbench module in the main.v file combines and connects every module sufficiently using wires to send results between modules.  Also, some modules were individually tested. The pc register, adder and instruction memory were tested by reading in a list of instructions in a *mem.in* file and printing it to the terminal. The control module was tested by reading in a "jump.in" file with a jump instruction and when the control module encountered the jump instruction, it sends a jump signal that set the next address to the jump address that caused an infinite loop. The ALU and registers module were tested by reading in 1 to a register and 2 to the other register. The ALU reads the **ALUOp** and is able to sum the values in the registers. And the registers reads in this result. Then we're able to print out the aluResult from **a0**.

