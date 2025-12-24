module RISC_processor
(

    input clk,
    input rst
);

// ===== Wires =====
wire [31:0] PC, Next_PC, PC_plus_4;
wire [15:0] instruction;
wire [2:0] rs, rt, rd;
wire [3:0] funct, opcode;
wire [31:0] reg_data1, reg_data2, immediate_extended;
wire [31:0] ALU_input2, ALU_result;
wire [31:0] mem_data;
wire [2:0] write_reg;
wire [31:0] Reg_Write_Data;
wire Zero;

// Control signals
wire RegWrite, ALUSrc, MemToReg, MemRead, MemWrite, Branch, RegDst;
wire [1:0] ALUOp;
wire [3:0] ALU_Ctrl;

// ===== PC =====
PC pc_inst(
    .clk(clk),
    .rst(rst),
    .in(Next_PC),
    .out(PC)
);

assign PC_plus_4 = PC + 4;//??????????????????????????????

// ===== Instruction Memory =====
instruction_MEM imem(
    .read_address(PC),
    .instruction(instruction)
);

// ===== Instruction Decode =====
assign opcode = instruction[15:12];
assign rs     = instruction[11:9];
assign rt     = instruction[8:6];
assign rd     = instruction[5:3];
assign funct  = instruction[3:0];
assign immediate_extended = {{29{instruction[2]}}, instruction[2:0]}; // sign-extend 3-bit immediate

// ===== Control Unit =====
main_control_unit main_ctrl(      /////no jump?????
    .opcode(),
    .reg_dst(opcode),
    .jump(RegWrite),  //?????????????
    .branch(ALUSrc),
    .reg_write(MemToReg),
    .mem_read(MemRead),
    .mem_write(MemWrite),
    .mem_to_reg(Branch),
    .alu_op(RegDst),
    .alu_src(ALUOp)
);

ALU_control alu_ctrl(
    .alu_op(ALUOp),
    .funct(funct),
    .ALUcontrol(ALU_Ctrl)
);

// ===== Register File =====
Register_file reg_file(
    .clk(clk),
    .RegWrite(RegWrite),
    .rs(rs),
    .rt(rt),
    .rd(write_reg),
    .Write_data(Reg_Write_Data),
    .Read_data1(reg_data1),
    .Read_data2(reg_data2)
);

// ===== ALU Input MUX =====
MUX2 #(32) alu_mux(
    .in0(reg_data2),
    .in1(immediate_extended),
    .sel(ALUSrc),
    .out(ALU_input2)
);

// ===== ALU =====
ALU alu_inst(
    .A(reg_data1),
    .B(ALU_input2),
    .ALUcontrol(ALU_Ctrl),
    .Result(ALU_result),
    .Zero(Zero)  /???????????????????
);

// ===== Data Memory =====
DataMemory data_mem(
    .clk(clk),
    .memr(MemRead),
    .memw(MemWrite),
    .address(ALU_result),
    .datain(reg_data2),
    .dataout(mem_data)
);

// ===== Write-Back MUX =====
MUX2 #(32) wb_mux(
    .in0(ALU_result),
    .in1(mem_data),
    .sel(MemToReg),
    .out(Reg_Write_Data)
);

// ===== Write Register MUX =====
MUX2 #(3) reg_dst_mux(
    .in0(rt),
    .in1(rd),
    .sel(RegDst),
    .out(write_reg)
);

// ===== Branch/Next PC =====
wire [31:0] branch_addr;
assign branch_addr = PC_plus_4 + (immediate_extended << 2);

MUX2 #(32) pc_mux(
    .in0(PC_plus_4),
    .in1(branch_addr),
    .sel(Branch & Zero),
    .out(Next_PC)


endmodule
