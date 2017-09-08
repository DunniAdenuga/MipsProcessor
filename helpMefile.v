`include "mips.h" // various defines
/*instruction types locations*/
`define regDst  10
`define jump  9
`define branch  8
`define memRead  7
`define memToReg  6
`define aluOP  5:3 //i need this and the next two after it to fully access aluOP
`define regWrite  2
`define aluSrc  1
`define memWrite  0

module pcRegister(input clock, input  [31:0] next_addr, output reg [31:0] addr);

initial begin
	addr = 32'h00400020;
	end
always @(posedge clock)//negedge would have worked too ? clock usage was not specified
	addr <= next_addr;
endmodule
////////////

module adder(input [31:0] addr, output reg [31:0] out);

always@(addr)
	out <= addr + 4; //I got error for using assign

endmodule
////////////

module memory(input [31:0] addr, output reg [31:0] instruction);

reg [31:0] mem [32'h100000:32'h101000]; // ask why this instead of [3:0]
reg [31:0] word_addr;

initial begin
	$readmemh("add_test.v", mem);
end
always @(addr)
begin
	word_addr = addr >> 2; // ask difference btwn read and word address and need for this >>2
	instruction = mem[word_addr];
end
endmodule
////////////

module control(input [31:0] instruction, output reg [10:0] val);
always@(instruction) begin
	if((instruction[`op] == `SPECIAL) && (instruction[`function] == `ADD)) begin//add
		val = 11'b10000010100;
		$display("Add Istruction");
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
		$display("Jump Instruction");
		$display("control bits - %x", val);
		end
	else if(instruction[`op] == `JR)//jr
		val = 11'b01000000000;
	else if(instruction[`op] == `JAL)//jal
		val = 11'b01000000100;
	else begin
		$display("instruction not supported, instruction - %x", instruction);
		$display("instruction opcode - %x", instruction[`op]);	
		val = 11'b0;	
	end
	end
endmodule
////////////

module shift(input [31:0] addr, input [31:0] instruction, output reg [31:0] jumpAddr);
reg [31:0] next_addr;
always@(instruction)begin
	next_addr = addr + 4;
	jumpAddr = {next_addr[31:28], instruction[25:0] << 2};
end
endmodule
////////////

module mux_Jump(input val, input [31:0] jumpAddr, input [31:0] addrFromAdder, output reg [31:0] next_addr);
always@(*) begin
	if(val == 1)
		next_addr = jumpAddr;
	else
		next_addr = addrFromAdder;
end
endmodule
////////////

module muxForRegisters(input [31:0] instruction, input RegDst, output reg [4:0] writeReg);
always @(*) begin
	if(RegDst == 1)
		writeReg = instruction[15:11]; //instruction[15-11]
	else
		writeReg = instruction[20:16]; //instruction[20-16]
	end
endmodule

module registers(input [4:0] rd1, input [4:0] rd2, input[4:0] writeRegister, input [31:0] rr, input write, output reg [31:0] data1, output reg [31:0] data2, output reg [31:0] v0, output reg [31:0] a0);
reg [31:0] register [31:0];

always @(*) begin
v0 = register[`v0];
a0 = register[`a0];
data1 = register[rd1];
data2 = register[rd2];
	if(write)
		register[writeRegister] = rr;
end
endmodule
/////////////////////////////////////////////////

module signExtend(input [15:0] instruc, output reg [31:0] signExtendReadData);
	always @(*) begin
		signExtendReadData = {{16{instruc[15]}},instruc[15:0]};
		end
endmodule


module muxForALU(input aluSrc, input [31:0] readData2, input [31:0] signExtendReadData, output reg [31:0] muxResult);
always @(*) begin
if(aluSrc == 0)
	muxResult = readData2;
else
	muxResult = signExtendReadData;
end
endmodule

module alu(input [2:0] aluOp,input [31:0] readData, input [31:0] readData2, output reg [31:0] aluResult);
// aluOp comes from the control signal
always@(*) begin
	if(aluOp == 3'b010)//add
		aluResult = readData + readData2;
	else if(aluOp == 3'b110)//subtract
		aluResult = readData - readData2;
	else if(aluOp == 3'b001)//or
		aluResult = readData | readData2;
	else if(aluOp == 3'b000)//and
		aluResult = readData & readData2;
	//else if(aluOp == 3'b111)//slt
		//aluResult = 
	end
endmodule
/////////////////////////

module syscall(input [31:0] v0, input [31:0] a0);
always@(*) begin
	if(v0 == 1)
		$display("a0 - %x",a0);
	else if(v0 == 10)
		$finish;
end
endmodule

//module dataMemory(input [31:0] address, input [31:0] writeData, input [31:0] readData, input memRead, input memWrite);

//endmodule
////////////////////

module testbench;
reg clock = 0;
wire [31:0] current_addr;
wire [31:0] add_addr;
wire [31:0] jump_addr;
wire [10:0] val;
wire [31:0] next_addr;
wire [31:0] next_addr2;
wire [31:0] instruction;


adder add(current_addr, add_addr);
memory mem(current_addr, instruction);
control con(instruction, val);
shift shi(current_addr, instruction, jump_addr);
mux_Jump m(val[`jump], jump_addr, add_addr, next_addr);//checks jump
pcRegister pc(clock, next_addr, current_addr);

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,testbench);	
    $monitor("instruction = %08x, val - control bits = %08x", instruction, val);
end

always
  begin                     // inline clock generator
    #10; clock = ~clock;
    if(instruction == 0)
	$finish;
  end

endmodule
