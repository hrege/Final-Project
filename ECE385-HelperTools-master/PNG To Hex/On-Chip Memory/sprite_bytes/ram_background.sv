/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  backgroundROM
(
		input [307199:0] read_address,
		input Clk,

		output logic [4:0] data_Out
);

// mem has width of 8 bits and a total of 2499 addresses
logic [4:0] mem [0:307199];

initial
begin
	 $readmemh("background.txt", mem);
end	


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
