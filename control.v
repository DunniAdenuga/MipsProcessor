`include "mips.h" // various defines

/*Control signals to recognise type of instuction*/
module control(input [31:0] instruction, output reg [10:0] val);
always@(instruction) begin
	if((instruction[`op] == `SPECIAL) && (instruction[`function] == `ADD)) begin//add
		val = 11'b10000010100;
		//$display("Add Instruction");
		end
	else if((instruction[`op] == `SPECIAL) && (instruction[`function] == `SUB)) //sub
		val = 11'b10000110100;
	else if((instruction[`op] == `SPECIAL) && (instruction[`function] == `AND)) //and
		val = 11'b10000000100;
	else if((instruction[`op] == `SPECIAL) && (instruction[`function] == `OR)) //or
		val = 11'b10000001100;
	else if((instruction[`op] == `SPECIAL) && (instruction[`function] == `SLT)) //slt
		val = 11'b10000111100;
	else if(instruction[`op] == `ADDI)//addi
		val = 11'b00000010110;
	else if(instruction[`op] == `ADDIU)//addiu
		val = 11'b00000010110;
	else if(instruction[`op] == `ORI)//ori
		val = 11'b00000001110;
	else if(instruction[`op] == `LW)//lw
		val = 11'b00011010110;
	else if(instruction[`op] == `SW)//sw
		val = 11'b00000010011;
	else if(instruction[`op] == `BEQ)//beq
		val = 11'b00100110000;
	else if(instruction[`op] == `BNE)//bne
		val = 11'b00100110000;
	else if(instruction[`op] == `J) begin//j
		val = 11'b01000000000;
		//$display("Jump Instruction");
		//$display("control bits - %x", val);
		end
	else if(instruction[`op] == `JR)//jr
		val = 11'b01000000000;
	else if(instruction[`op] == `JAL)//jal
		val = 11'b01000000100;
	else begin
		//$display("instruction not supported, instruction - %x", instruction);
		//$display("instruction opcode - %x", instruction[`op]);	
		val = 11'b0;	
	end
	end
endmodule
////////////

/*Helper Module*/
module shift(input [31:0] addr, input [31:0] instruction, output reg [31:0] jumpAddr);
reg [31:0] next_addr;
always@(instruction)begin
	next_addr = addr + 4;
	jumpAddr = {next_addr[31:28], instruction[25:0] << 2};
end
endmodule
////////////


/*Determines next address depending on control from instruction*/
module mux_Jump(input val, input [31:0] jumpAddr, input [31:0] addrFromAdder, output reg [31:0] next_addr);
always@(*) begin
	if(val == 1)
		next_addr = jumpAddr;
	else
		next_addr = addrFromAdder;
end
endmodule
////////////
