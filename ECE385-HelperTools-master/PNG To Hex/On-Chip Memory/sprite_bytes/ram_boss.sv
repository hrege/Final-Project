/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  bossROM
(
		input [3599:0] read_address,
		input Clk,

		output logic [7:0] data_Out
);

// mem has width of 8 bits and a total of 2499 addresses
logic [7:0] mem [0:3599];

initial
begin
	 $readmemh("boss.txt", mem);
end	


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
