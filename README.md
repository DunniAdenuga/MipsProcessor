# A Single Cycle MipsProcessor 

Readme sufficiently explains the design, compilation, execution, and testing methodology. 
The code contains module-level comments and inline comments where appropriate.

##Design
This program was designed in a modularized format. Each module handles a specific function. For example, the control module is designed to only assign control signals to different type of instructions. Every related module is stored in a single file. For example the dataMemory module is stored in the dataMemory file which also has the mux after the data memory. This makes it easy to easily locate essential modules while following the single processor diagram.

##Compilation
It is important to have the specified Makefile and add_test.s. Then, you `make`. This creates the file add_test.v with the necessary instructions for testing the processor. This program makes use of the "mips.h" file too.
To compile, you run:
	`iverilog main.v pcRegister.v registers.v alu.v control.v dataMemory.v`

##Execution
After compiling, run:
	`./a.out`
To see more detailed graphical results, you should run:
	`gtkwave test.vcd`
Sample Result:
##Testing
	The Single Mips processor was successfully tested with the add immediate unsigned(ADDIU) and syscall instructions. These instructions test the ability of the instruction memory, arithmetic logic unit, the control module and registers module.
A testbench module in the main.v file combines and connects every module sufficiently using wires to send results between modules. 
	Also, some modules were individually tested. The pc register, adder and instruction memory were tested by reading in a list of instructions in a "mem.in" file and printing it to the terminal. The control module was tested by reading in a "jump.in" file with a jump instruction and when the control module encountered the jump instruction, it sends a jump signal that set the next address to the jump address that caused an infinite loop.
	The ALU and registers module were tested by reading in 1 to a register and 2 to the other register. The ALU reads the ALUOp and is able to sum the values in the registers. And the registers reads in this result. Then we're able to print out the aluResult from a0.
