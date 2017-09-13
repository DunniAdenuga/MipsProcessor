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

module syscall(input[31:0] instruction, input [31:0] v0, input [31:0] a0);
always@(*) begin
if(instruction == 32'h0000000C) begin
	//$display("here, v0 - %d, a0 - %d", v0, a0);
	if(v0 == 1)
		$display("a0 - %x",a0);
	else if(v0 == 10) begin
		//$display("here222");
		$finish;
		end
end
end
endmodule
////////////////////////////////////////////////////////

module testbench;
reg clock = 0;
wire [31:0] current_addr;
wire [31:0] add_addr;
wire [31:0] jump_addr;
wire [10:0] val;
wire [31:0] next_addr;
wire [31:0] next_addr2;
wire [31:0] instruction;
wire [4:0] writeReg;
wire [31:0] dataMemResult;
wire [31:0] rr; //setting to aluResult for first test but should actually come from mux of dataMem and aluResult
wire [31:0] aluResult;
wire [31:0] readData1;
wire [31:0] readData2;
wire [31:0] a0;
wire [31:0] v0;
wire [31:0] signExtendData;
wire [31:0] muxAluResult;

adder add(current_addr, add_addr);
memory mem(current_addr, instruction);
control con(instruction, val);
shift shi(current_addr, instruction, jump_addr);
mux_Jump m(val[`jump], jump_addr, add_addr, next_addr);//checks jump
pcRegister pc(clock, next_addr, current_addr);
muxForRegisters muxForR(instruction, val[`regDst], writeReg);
//change aluResult to rr
registers regis(instruction[25:21],instruction[20:16],writeReg, aluResult, val[`regWrite], readData1, readData2, v0, a0);
syscall sys(instruction, v0, a0);
signExtend sE(instruction[15:0], signExtendData);
muxForALU muxForA(val[`aluSrc], readData2, signExtendData, muxAluResult);
alu al(val[`aluOP], readData1, muxAluResult, aluResult);
//dataMemory dm(clock, aluResult, readData2, val[`memRead], val[`memWrite], dataMemResult);
//muxAfterDataMemory mADM(val[`memToReg], dataMemResult,aluResult, rr);

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,testbench);	
    //$monitor("instruction = %08x, val - control bits = %08x", instruction, val);
end

always
  begin                     // inline clock generator
    #10; clock = ~clock;
    /*if(instruction == 32'h0000000C) begin
	$display("here");
	$display("v0 - %x",v0);
	$display("a0 - %x",a0);
	if(v0 == 1)
		$display("a0 - %x",a0);
	else if(v0 == 10)
		$finish;
	end*/
    if(instruction == 0)
	$finish;
  end

endmodule
