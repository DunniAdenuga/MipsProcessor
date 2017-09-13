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
integer i;
initial begin

for (i =0; i < 32; i++)
	register[i] = 0;
	end
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

