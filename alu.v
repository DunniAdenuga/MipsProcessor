module signExtend(input [15:0] instruc, output reg [31:0] signExtendReadData);
	always @(*) begin
		signExtendReadData = {{16{instruc[15]}},instruc[15:0]};
		end
endmodule
//////////////////////////////////////////////////



module muxForALU(input alusrc, input [31:0] readData2, input [31:0] signExtendReadData, output reg [31:0] muxResult);
always @(*) begin
//$display("alusrc, %08x" , alusrc);
if(alusrc == 0)
	muxResult = readData2;
else
	muxResult = signExtendReadData;
end
endmodule

/*Arithmetic Logic Unit - performs arithmetic operations based on control signals*/
module alu(input [2:0] aluOp,input [31:0] readData, input [31:0] readData2, output reg [31:0] aluResult);
// aluOp comes from the control signal
always@(*) begin
	if(aluOp == 3'b010)//add
		aluResult = readData + readData2;
	else if(aluOp == 3'b110)//subtract
		aluResult = readData - readData2;
	else if(aluOp == 3'b001)//or
		aluResult = readData | readData2;
	else if(aluOp == 3'b000)begin//and
		aluResult = readData & readData2;
		end
	//else if(aluOp == 3'b111)//slt
		//aluResult = 
	//$display("in alu");
	//$display("in alu: aluOp - %08d readData - %08d readData2 - %08d aluResult - %08d", aluOp, readData, readData2, aluResult);
	end
endmodule
/////////////////////////

