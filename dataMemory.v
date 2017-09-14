/*Works like RAM*/
module dataMemory(input clock, input [31:0] address, input [31:0] writeData, input memRead, input memWrite, output reg [31:0] readData );
//reg [31:0] data [32'h80000000:32'h7FFF0000];
reg [31:0] data [32'h7fff0000:32'h7fffffff];

integer i;
initial begin
for (i = 0; i < 32; i++) ////std::bad alloc
	data[i] = 0;
end

always@(posedge clock) begin
if(memRead) begin
	//read from address and assign to readData
	readData = data[address];
end

if(memWrite) begin
	//write writeData to writeAddress 
	data[address] = writeData;
end	
end	

endmodule
////////////////////

module muxAfterDataMemory(input memToReg, input [31:0] readData, input[31:0] aluResult, output reg [31:0] writeData);
always @ (*) begin
	if(memToReg)
		writeData = readData;
	else
		writeData = aluResult;
end
endmodule
