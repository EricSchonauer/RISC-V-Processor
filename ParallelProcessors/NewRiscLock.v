module NewRiscLock(clk, rst, start, out1, out2, lockOut, go, address, wrData, wren, RAM_out, startPC, PC, S);
	input [31:0] startPC;
	input clk, rst, start;
	output reg [31:0] out1, out2;
	
	output reg [31:0] PC;
	
	// component instantiations
	output reg [8:0] address;
	output reg [31:0] wrData;
	output reg wren;
	input [31:0] RAM_out;
	
	// lock/unlock signals
	output reg [1:0] lockOut;
	input go;
	
	reg [31:0] ALU_in1, ALU_in2;
	reg [2:0] funct3;
	reg upperBit, lowerBit, cOrI;
	wire [31:0] ALU_out;
	ALU RiscALU(ALU_in1, ALU_in2, funct3, upperBit, lowerBit, cOrI, ALU_out);
	
	reg wrenReg;
	reg [4:0] readReg1, readReg2;
	wire [31:0] regOut1, regOut2;
	reg [4:0] writeReg;
	reg [31:0] writeData;
	RegisterFile RegFile(clk, rst, wrenReg, readReg1, readReg2, regOut1, regOut2, writeReg, writeData);

	
	// parameters for states
	output reg [5:0] S; 
	reg [5:0] NS;
	
	parameter	ST = 6'd0,			// RENUMBER WHEN DONE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
					FETCH1 = 6'd1,
					FETCH2 = 6'd2,
					FETCH3 = 6'd3,
					DONE = 6'd59,
					DECODE = 6'd4,
					
					INT_IMM = 6'd5,
					INT_REG = 6'd6,
					
					JAL = 6'd7,
					JALR = 6'd8,

					LUI = 6'd11,
					AUIPC = 6'd12,
					
					LOADS1 = 6'd13,
					LOADS2 = 6'd14,
					LOADS3 = 6'd15,
					
					STORES = 6'd16,
					
					BRANCHES = 6'd17,
					
					LOCK = 6'd18,
					UNLOCK = 6'd19,
					
					PCUPDATE = 6'd40,
					
					OTHERERROR = 6'd60,
					PCERROR = 6'd61,
					FUNCT3ERROR = 6'd62,
					OPCERROR = 6'd63;
					
	
	

	// sets it to next state
	always @ (posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
			S <= ST;
		else
		begin
			S <= NS;
		end
	end
	
	
	// state changing logic
	always @ (*)
	begin
		case(S)
			ST:
				begin
					if (start == 1'b1)
						NS = FETCH1;
					else
						NS = ST;
				end
			FETCH1: NS = FETCH2;
			FETCH2: NS = FETCH3;
			FETCH3: NS = DECODE;
			DONE: NS = DONE;
			DECODE:
				begin
					case(opcode)
						7'b0010011: NS = INT_IMM;	// integer immediate instructions
						7'b0110011: NS = INT_REG;	// integer register instructions
						
						7'b0110111: NS = LUI;
						7'b0010111: NS = AUIPC;
						
						7'b1101111: NS = JAL;
						
						7'b1100111: NS = JALR;
						
						7'b0000011: NS = LOADS1;
						
						7'b0100011: NS = STORES;
						
						7'b1100011: NS = BRANCHES;
						
						7'b0000111: NS = LOCK;
						7'b0000001: NS = UNLOCK;
						
						7'd0: NS = DONE;
						default: NS = OPCERROR;
					endcase
				end
				
			INT_IMM: NS = PCUPDATE;
			INT_REG: NS = PCUPDATE;
			
			LUI: NS = PCUPDATE;
			AUIPC: NS = PCUPDATE;
			
			JAL: NS = FETCH1;
			JALR: NS = FETCH1;
			
			LOADS1: NS = LOADS2;
			LOADS2: NS = LOADS3;
			LOADS3: NS = PCUPDATE;
			
			STORES: NS = PCUPDATE;
			
			BRANCHES: NS = FETCH1;
			
			LOCK:
				begin
					if (go == 1'b1)
						NS = PCUPDATE;
					else
						NS = LOCK;
				end
			UNLOCK: NS = PCUPDATE;
			
			PCUPDATE: NS = FETCH1;

			OTHERERROR: NS = OTHERERROR;
			PCERROR: NS = PCERROR;
			FUNCT3ERROR: NS = FUNCT3ERROR;
			OPCERROR: NS = OPCERROR;
			default: NS = OTHERERROR;
		endcase
	end
	
	
	// based on state control signals are set combinationally
	always @ (*)
	begin
		case(S)
					ST: 
						begin
							// reset control signals
							wren = 1'b0;
							cOrI = 1'b0;
							wrenReg = 1'b0;
							addrCon = 1'b1;
							ALU_or_RAM_or_PC = 2'd2;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
					FETCH1: 
						begin
							// reset control signals
							wren = 1'b0;
							cOrI = 1'b0;
							wrenReg = 1'b0;
							addrCon = 1'b1;
							ALU_or_RAM_or_PC = 2'd2;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
					FETCH2: 
						begin
							// reset control signals
							wren = 1'b0;
							cOrI = 1'b0;
							wrenReg = 1'b0;
							addrCon = 1'b1;
							ALU_or_RAM_or_PC = 2'd2;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
					FETCH3:
						begin
							// reset control signals
							wren = 1'b0;
							cOrI = 1'b0;
							wrenReg = 1'b0;
							addrCon = 1'b1;
							ALU_or_RAM_or_PC = 2'd2;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
					DECODE:
						begin
							// reset control signals
							wren = 1'b0;
							cOrI = 1'b0;
							wrenReg = 1'b0;
							addrCon = 1'b1;
							ALU_or_RAM_or_PC = 2'd2;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
					
					INT_IMM:
						begin
							cOrI = 1'b0;	// we want int operations
							ALU_in1_con = 1'b0;	// we are using an immediate
							ALU_or_RAM_or_PC = 2'd2; 	// want regfile to write data from ALU not RAM
							wrenReg = 1'b1;	// enable writing to register
							PCcon = 2'd0;
							
							wren = 1'b0;
							addrCon = 1'b1;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
					INT_REG:
						begin
							cOrI = 1'b0;
							ALU_in1_con = 1'b1;
							ALU_or_RAM_or_PC = 2'd2;
							wrenReg = 1'b1;
							PCcon = 2'd0;
							
							wren = 1'b0;
							addrCon = 1'b1;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
						
					JAL:
						begin
							wrenReg = 1'b1;
							ALU_or_RAM_or_PC = 2'd1;	// writes PC+1 to register
							AUIPC_en = 1'b1;
							
							JAL_or_JALR = 1'b0;
							PCcon = 2'd2;
							
							wren = 1'b0;
							cOrI = 1'b0;
							addrCon = 1'b1;
							ALU_in1_con = 1'b0;
							RAM_form = 2'd0;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
					JALR:
						begin
							wrenReg = 1'b1;
							ALU_or_RAM_or_PC = 2'd1;	// writes PC+1 to register
							AUIPC_en = 1'b1;
							
							JAL_or_JALR = 1'b1;
							cOrI = 1'b0;	// allows for adding of register and imm. in the ALU
							PCcon = 2'd2;
							
							wren = 1'b0;
							addrCon = 1'b1;
							ALU_in1_con = 1'b0;
							RAM_form = 2'd0;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
						
					LUI:
						begin
							wrenReg = 1'b1;
							ALU_or_RAM_or_PC = 2'd0; // writeReg already set to bits 11 to 7
							RAM_form = 2'd1;
							
							wren = 1'b0;
							cOrI = 1'b0;
							addrCon = 1'b1;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
					AUIPC:
						begin
							wrenReg = 1'b1;
							AUIPC_en = 1'b0;
							ALU_or_RAM_or_PC = 2'd1; // writeReg already set to bits 11 to 7
							
							wren = 1'b0;
							cOrI = 1'b0;
							addrCon = 1'b1;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
						
					LOADS1:
						begin
							L_S = 1'b1;
							addrCon = 1'b0;
							ALU_or_RAM_or_PC = 2'd0;
							RAM_form = 2'd2;
							wrenReg = 1'b1;
							
							wren = 1'b0;
							cOrI = 1'b0;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							AUIPC_en = 1'b1;
							lockOut = 2'd0;
						end
					LOADS2:
						begin
							L_S = 1'b1;
							addrCon = 1'b0;
							ALU_or_RAM_or_PC = 2'd0;
							RAM_form = 2'd2;
							wrenReg = 1'b1;
							
							wren = 1'b0;
							cOrI = 1'b0;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							AUIPC_en = 1'b1;
							lockOut = 2'd0;
						end
					LOADS3:
						begin
							L_S = 1'b1;
							addrCon = 1'b0;
							ALU_or_RAM_or_PC = 2'd0;
							RAM_form = 2'd2;
							wrenReg = 1'b1;
							
							wren = 1'b0;
							cOrI = 1'b0;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							AUIPC_en = 1'b1;
							lockOut = 2'd0;
						end
						
					STORES:
						begin
							wrenReg = 1'b0;
							wren = 1'b1;
							L_S = 1'b0;
							addrCon = 1'b0;
							
							cOrI = 1'b0;
							ALU_or_RAM_or_PC = 2'd2;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							lockOut = 2'd0;
						end
						
					BRANCHES:
						begin
							cOrI = 1'b1;
							PCcon = 2'd1;
							ALU_in1_con = 1'b1;
							
							wren = 1'b0;
							wrenReg = 1'b0;
							addrCon = 1'b1;
							ALU_or_RAM_or_PC = 2'd2;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
						
					LOCK:
						begin
							wren = 1'b0;
							cOrI = 1'b0;
							wrenReg = 1'b0;
							addrCon = 1'b1;
							ALU_or_RAM_or_PC = 2'd2;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd1;
						end
					UNLOCK:
						begin
							wren = 1'b0;
							cOrI = 1'b0;
							wrenReg = 1'b0;
							addrCon = 1'b1;
							ALU_or_RAM_or_PC = 2'd2;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd2;
						end
					
					PCUPDATE:
						begin
							wren = 1'b0;
							cOrI = 1'b0;
							wrenReg = 1'b0;
							addrCon = 1'b1;
							ALU_or_RAM_or_PC = 2'd2;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
					
					DONE:
						begin
							wren = 1'b0;
							cOrI = 1'b0;
							wrenReg = 1'b0;
							addrCon = 1'b1;
							ALU_or_RAM_or_PC = 2'd2;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
						
					default:
						begin
							// reset control signals
							wren = 1'b0;
							cOrI = 1'b0;
							wrenReg = 1'b0;
							addrCon = 1'b1;
							ALU_or_RAM_or_PC = 2'd2;
							ALU_in1_con = 1'b0;
							PCcon = 2'd0;
							JAL_or_JALR = 1'b0;
							RAM_form = 2'd0;
							AUIPC_en = 1'b1;
							L_S = 1'b0;
							lockOut = 2'd0;
						end
				
		endcase
	end
	
	
	always @ (posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
		begin
			// reset control signals
			PC <= startPC; //32'd0;
			ins <= 32'd0;
			out1 <= 32'd0;
			out2 <= 32'd0;
		end
		else
		begin
				case(S)
					FETCH2: ins <= RAM_out; // nothing happens? NOT TRUE
					FETCH3: ins <= RAM_out;
					
					JAL: PC <= PC + update;
					JALR: PC <= PC + update;
					BRANCHES: PC <= PC + update;
					
					PCUPDATE:
						begin
							PC <= PC + update;
						end
					
					DONE:
						begin
							ins[19:15] <= 5'd31;
							ins[24:20] <= 5'd30;
							out1 <= regOut1;
							out2 <= regOut2;
						end
				endcase
		end
	end
	
	
	
	
	
	/* combinational logic for control signals */
	reg addrCon;	// controls whether the PC or address for LW/SW ins. is sent into the RAM
	reg [1:0] ALU_or_RAM_or_PC; // controls what goes into writeData for register
	reg ALU_in1_con; // controls whether an immediate from the ins. or regOut2 is sent into ALU
	reg [6:0] opcode;
	reg [31:0] ins;
	reg [1:0]PCcon;	// controls whether the pc should be updated by a jump or only by 1
	reg [31:0] update;
	reg JAL_or_JALR;
	reg [1:0] RAM_form;	// decides the format for the output of the RAM, whether you want the LUI imm., a byte, a half or a word
	reg AUIPC_en;
	reg L_S;	// decides whether to use added value for load or store as RAM address to be accessed
	
	always @ (*) // decides what should be stored into the RAM as far as size (word, half, byte)
	begin
		case(ins[14:12])	// based on the funct 3 spot
			3'b000: wrData = {24'd0, regOut2[7:0]};
			3'b001: wrData = {16'd0, regOut2[15:0]};
			3'b010: wrData = regOut2;
			
			default: wrData = 32'd0;
		endcase
	end
	
	
	// deciding RAM address fetch from addrCon
	always @ (*)
	begin
		if (addrCon == 1'b1)
			address = PC[8:0];
		else
			if (L_S == 1'b1)
				address = ins[31:20] + regOut1;	// values for load address
			else
				address = {20'd0, ins[31:25], ins[11:7]} + regOut1;	// values for store address
	end
	
	
	// decides what is written into regFile
	always @ (*)
	begin
		if (ALU_or_RAM_or_PC == 2'b10)
			writeData = ALU_out;
		else if (ALU_or_RAM_or_PC == 2'b01)
			if (AUIPC_en == 1'b1)
				writeData = PC + 32'd1;
			else
				writeData = PC + {ins[31:12], 12'd0};
		else 
		begin
			if (RAM_form == 2'd0) 
				writeData = ins;
			else if (RAM_form == 2'd1)
				writeData = {ins[31:12], 12'd0};
			else
				case (ins[14:12])	// based on the funct 3 spot
					3'b000:
						begin
							writeData = {RAM_out[7], RAM_out[7], RAM_out[7], RAM_out[7], 
							RAM_out[7], RAM_out[7], RAM_out[7], RAM_out[7], RAM_out[7], 
							RAM_out[7], RAM_out[7], RAM_out[7], RAM_out[7], RAM_out[7], 
							RAM_out[7], RAM_out[7], RAM_out[7], RAM_out[7], RAM_out[7], 
							RAM_out[7], RAM_out[7], RAM_out[7], RAM_out[7], RAM_out[7], 
							RAM_out[7:0]};
						end
					3'b001:
						begin
							writeData = {RAM_out[15], RAM_out[15], RAM_out[15], RAM_out[15], 
							RAM_out[15], RAM_out[15], RAM_out[15], RAM_out[15], RAM_out[15], 
							RAM_out[15], RAM_out[15], RAM_out[15], RAM_out[15], RAM_out[15], 
							RAM_out[15], RAM_out[15], RAM_out[15:0]};
						end
					3'b010: writeData = RAM_out;
					3'b100: writeData = {24'd0, RAM_out[7:0]};
					3'b101: writeData = {16'd0, RAM_out[15:0]};
					
					default: writeData = 32'd0;
				endcase
		end
	end
	
	always @ (*)
	begin
		if (ALU_in1_con == 1'b1)
			ALU_in1 = regOut2;
		else
			ALU_in1 = ins[31:20];	// immediate for integer ALU insructions
			
		ALU_in2 = regOut1;	// always
	end
	
	
	// deciding readReg1/2, and writeReg
	// also wires for ALU control (except for cOrI)
	// wires opcode
	always @ (*)
	begin
		readReg1 = ins[19:15];
		readReg2 = ins[24:20];
		writeReg = ins[11:7];
		funct3 = ins[14:12];
		lowerBit = ins[5];
		upperBit = ins[30];	// essentially represents the funct7 spot
		opcode = ins[6:0];
	end
	
	
	// decides which way the PC should be updated
	always @ (*)
	begin
		if (PCcon == 2'd2) // in the case of some kind of jump
		begin
			if (JAL_or_JALR == 1'b0)
				update = {ins[31], ins[31], ins[31], ins[31], ins[31], ins[31], ins[31], 
					ins[31], ins[31], ins[31], ins[31], ins[31], ins[19:12], ins[20], ins[30:21], 1'b0};
			else
				update = {ALU_out[31:1], 1'b0}; //ALU_out;
		end
		else if (PCcon == 2'd1)	// in the case of a branch the logic in the ALU decides update
		begin
			if (ALU_out == 32'd1)
				update = {ins[31], ins[31], ins[31], ins[31], ins[31], ins[31], ins[31], 	// sign extension
					ins[31], ins[31], ins[31], ins[31], ins[31], ins[31], ins[31], ins[31], ins[31], 
					ins[31], ins[31], ins[31], ins[31], ins[7], ins[30:25], ins[11:8], 1'b0};
			else
				update = 32'd1;
		end
		else	// no branch or jump
			update = 32'd1;
	end
	
endmodule






// taken from the internet and modified slightly, give credit
// HOW MANY CLOCK CYCLES PER TURNOVER? Just 1
module RegisterFile(clk, rst, writeControl, readReg1, readReg2, readData1, readData2, writeReg, writeData);
	input clk, rst, writeControl;
	input [4:0] readReg1, readReg2, writeReg;
	input [31:0] writeData;
	output [31:0] readData1, readData2;
	
	reg [31:0] regs [0:31];	// 31:0 means 32 bits but 0:31 means 32 registers
									// (reg address still designated by 5 bits)
	
	assign readData1 = regs[readReg1];
	assign readData2 = regs[readReg2];
	
	always @ (posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
		begin
			regs[0] <= 32'd0;		
			regs[1] <= 32'd0;
			regs[2] <= 32'd0;
			regs[3] <= 32'd0;
			regs[4] <= 32'd0;
			regs[5] <= 32'd0;
			regs[6] <= 32'd0;
			regs[7] <= 32'd0;
			regs[8] <= 32'd0;
			regs[9] <= 32'd0;
			regs[10] <= 32'd0;
			regs[11] <= 32'd0;
			regs[12] <= 32'd0;
			regs[13] <= 32'd0;
			regs[14] <= 32'd0;
			regs[15] <= 32'd0;
			regs[16] <= 32'd0;
			regs[17] <= 32'd0;
			regs[18] <= 32'd0;
			regs[19] <= 32'd0;
			regs[20] <= 32'd0;
			regs[21] <= 32'd0;
			regs[22] <= 32'd0;
			regs[23] <= 32'd0;
			regs[24] <= 32'd0;
			regs[25] <= 32'd0;
			regs[26] <= 32'd0;
			regs[27] <= 32'd0;
			regs[28] <= 32'd0;
			regs[29] <= 32'd0;
			regs[30] <= 32'd0;
			regs[31] <= 32'd0;
		end
	
		else 
		begin
			if (writeControl == 1'b1)
			begin
				if (writeReg != 5'd0)	// checks so that reg0 can't be overwritten as its
					regs[writeReg] <= writeData;	// hardwired to 0
			end
		end
	end

endmodule


module ALU(in1, b, funct3, upperBit, lowerBit, cOrI, out);
	input signed [31:0] in1, b;	// in1/a will be the imm value or the value at rs2 or shamt
								// in2/b will be the rs1 value
								// remember that no matter what (except for shamt), both 32 bits have
								// been sign extended and are signed
								
	reg [31:0] a;
		
	
	input [2:0] funct3;	// this is the funct3 in the risc manual
	input upperBit;	// this is the upper control bit in the funct7 spot to differentiate
							// between ADD/SUB and and the different kinds of right shifts 
							// (bit 30 of total 32 bits)
							
	input lowerBit;	// this is another control bit (bit 5), it is part of the opcode and
							// differentiates between immediate and register operations
							// this bit only really decides whether or not the upperBit will
							// change anything, as the upperBit does nothing for when you have ADDI
							// as opposed to ADD
							
	input cOrI;	// this is to decide if the integer instructions or conditionals 
					// for branch instructions are to be executed
							
	output reg [31:0] out;
	
	reg unsigned [4:0] shamt;
	reg unsigned [31:0] aUns;
	reg unsigned [31:0] bUns;
	
	// sign extends the immediate value (when lowerBit == 1'b0)
	wire signed [31:0] aImm = {in1[11], in1[11], in1[11], in1[11], in1[11], in1[11], 
		in1[11], in1[11], in1[11], in1[11], in1[11], in1[11], in1[11], in1[11], in1[11],
		in1[11], in1[11], in1[11], in1[11], in1[11], in1[11:0]};
	
	always @ (*)
		case(cOrI)
			1'b0:	// INTEGER INSTRUCTIONS
				begin
					if (lowerBit == 1'b0)
						a = aImm;
					else
						a = in1;
				
					// this is so aImm can be sign extended and then treated as unsigned
					shamt = a[4:0];
					aUns = a[31:0];
					bUns = b[31:0];
					
					case(funct3)
						3'b000:					// ADD/ADDI/SUB
							begin
								case(lowerBit)
									1'b0: out = a + b;	// ADDI
									1'b1:
										begin
										case(upperBit)
											1'b0:	out = a + b;	// ADD
											1'b1: out = b - a;	// SUB, not sure which way subtraction should be
										endcase
										end
								endcase			
							end		
						3'b001: out = b << shamt;	// SLL/SLLI; the same operation but shamt is either 
															// shamt or the value in rs2
						3'b010:					// SLT/SLTI
							begin
								if (b[31] == a[31] && a[31] == 1'b0)
								begin
									if (b < a)
										out = 32'd1;
									else 
										out = 32'd0;
								end
								else if (b[31] == 1'b1 && a[31] == 1'b0)
									out = 32'd1;
								else if (a[31] == 1'b1 && b[31] == 1'b0)
									out = 32'd0;
								else if (b[31] == a[31] && a[31] == 1'b1)
								begin
									if (b[30:0] < a[30:0])
										out = 32'd1;
									else 
										out = 32'd0;
								end
								else
										out = 32'd0;
							end
						3'b011: 					// SLTIU/SLTU
							begin
								if (bUns < aUns)
									out = 32'd1;
								else 
									out = 32'd0;
							end
						3'b100: out = a ^ b;	// XOR/XORI
						3'b101: 		// SR--; the same operation but shamt is either 
										// shamt or the value in rs2
							case(upperBit)
								1'b0: out = b >> shamt;		// SRL/I
								1'b1: out = b >>> shamt;	// SRA/I
							endcase
						3'b110: out = b | a;	// OR/I
						3'b111: out = b & a;	// AND/I
					endcase
				end
			1'b1:	// CONDITIONALS FOR BRANCH INSTRUCTIONS, 1 for true, 0 for false
				begin
					a = in1;
					
					// this is so aImm can be sign extended and then treated as unsigned
					shamt = a[4:0];
					aUns = a[31:0];
					bUns = b[31:0];
				
					case(funct3)
						3'b000:
							begin
								if (b == a)
									out = 32'd1;
								else 
									out = 32'd0;
							end
						3'b001:
							begin
								if (b != a)
									out = 32'd1;
								else 
									out = 32'd0;
							end
						3'b100:
							begin
								if (b[31] == a[31] && a[31] == 1'b0)
								begin
									if (b < a)
										out = 32'd1;
									else 
										out = 32'd0;
								end
								else if (b[31] == 1'b1 && a[31] == 1'b0)
									out = 32'd1;
								else if (a[31] == 1'b1 && b[31] == 1'b0)
									out = 32'd0;
								else if (b[31] == a[31] && a[31] == 1'b1)
								begin
									if (b[30:0] < a[30:0])
										out = 32'd1;
									else 
										out = 32'd0;
								end
								else
										out = 32'd0;
							end
						3'b101:
							begin
								if (b[31] == a[31] && a[31] == 1'b0)
								begin
									if (b >= a)
										out = 32'd1;
									else 
										out = 32'd0;
								end
								else if (b[31] == 1'b1 && a[31] == 1'b0)
									out = 32'd0;
								else if (a[31] == 1'b1 && b[31] == 1'b0)
									out = 32'd1;
								else if (b[31] == a[31] && a[31] == 1'b1)
								begin
									if (b[30:0] >= a[30:0])
										out = 32'd1;
									else 
										out = 32'd0;
								end
								else
										out = 32'd0;
							end
						3'b110:
							begin
								if (bUns < aUns)
									out = 32'd1;
								else 
									out = 32'd0;
							end
						3'b111:
							begin
								if (bUns >= aUns)
									out = 32'd1;
								else 
									out = 32'd0;
							end
							
						default: out = 32'd0;
					endcase
				end
		endcase
	
endmodule
