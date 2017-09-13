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

