module Parallel(rst, clk, start, out11, out12, out21, out22, lockOwn, PC1out, PC2out, state1, state2, go1, go2, data1, data2, writeEnable1, writeEnable2);
	input rst, clk, start;
	output [31:0] out11, out12, out21, out22;
	
	// processor instantiation
	wire [1:0] lock1, lock2;
	output reg go1, go2;
	wire [8:0] address1, address2;
	wire [31:0] wrData1, wrData2;
	wire wren1, wren2;
	wire [31:0] RAM_out1, RAM_out2;
	
	output [31:0] PC1out, PC2out;
	output [5:0] state1, state2;
	NewRiscLock processor1(clk, rst, start, out11, out12, lock1, go1, address1, wrData1, wren1, RAM_out1, 32'd0, PC1out, state1);
	NewRiscLock processor2(clk, rst, start, out21, out22, lock2, go2, address2, wrData2, wren2, RAM_out2, 32'd20, PC2out, state2);
	
	// RAM instantiation
	output reg writeEnable1, writeEnable2;
	wire q1, q2;
	//output reg [8:0] addr1, addr2;
	output reg [31:0] data1, data2;
	SharedRAM RAM(address1, address2, clk, data1, data2, writeEnable1, writeEnable2, RAM_out1, RAM_out2);
	
	
	output reg [1:0] lockOwn;
	always @ (posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
		begin
			lockOwn <= 2'd0;
		end
		else
		begin
			// unlock
			if (lock1 == 2'd2 && lockOwn == 2'd1)
			begin
				lockOwn <= 2'd0;
			end
			else if (lock2 == 2'd2 && lockOwn == 2'd2)
			begin
				lockOwn <= 2'd0;
			end
			
			// lock
			else if (lock1 == 2'd1 && lockOwn == 2'd0)
			begin
				lockOwn <= 2'd1;
			end
			else if (lock2 == 2'd1 && lockOwn == 2'd0)
			begin
				lockOwn <= 2'd2;
			end
			
			else
				lockOwn <= lockOwn;
		end
	end
	
	always @ (*)
	begin
		if (lockOwn == 2'd0)
		begin
			go1 = 1'b0;
			go2 = 1'b0;
			writeEnable1 = wren1;
			writeEnable2 = wren2;
		end
		else if (lockOwn == 2'd1)
		begin
			writeEnable1 = wren1;
			writeEnable2 = 1'b0;
			go1 = 1'b1;
			go2 = 1'b0;
		end
		else if (lockOwn == 2'd2)
		begin
			writeEnable1 = 1'b0;
			writeEnable2 = wren2;
			go1 = 1'b0;
			go2 = 1'b1;
		end
		else
		begin
			writeEnable1 = 1'b0;
			writeEnable2 = 1'b0;
			go1 = 1'b0;
			go2 = 1'b0;
		end
		
		data1 = wrData1;
		data2 = wrData2;
	end
	
endmodule
