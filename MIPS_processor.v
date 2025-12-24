module MIPS_processor
(

    input clk,
    input rst
);

// ===== Wires =====
wire [31:0] PC, Next_PC, PC_plus_4 ,four;                             // all for pc part
wire [31:0] instruction;
wire [4:0]  rsA, rtA, write_reg;
wire [5:0]  funct, opcode;
wire [31:0] rsV, rtV, immediate_extended;
wire [31:0] ALU_input2, ALU_result;
wire [31:0] mem_data;
wire [4:0]  write_reg;                                                 //between mux and reg 
wire [31:0] RegWrite_Data;
wire Zero;

// Control signals
wire RegWrite, mem_read, mem_write, mem_to_reg, alu_src, branch, jump, reg_dst;
wire [1:0] alu_op;
wire [3:0] ALUcontrol;

// ===== PC =====
PC pc_inst(
    .clk(clk),
    .rst(rst),
    .in(Next_PC),
    .out(PC)
);

assign four = 4;
add  addpc(
     .a(PC),
     .b(four),
     .sum(PC_plus_4)
);
//assign PC_plus_4 = PC + 4;//??????????????????????????????

// ===== Instruction Memory =====
instruction_MEM imem(
    .read_address(PC),
    .instruction(instruction)
);

// ===== Instruction Decode =====
assign opcode = instruction[31:26];
assign rs     = instruction[25:21];
assign rt     = instruction[20:16];
assign rd     = instruction[15:11];
assign imm    = instruction[15:0];
assign funct  = instruction[5:0];



// ===== Control Unit =====
main_control_unit main_ctrl(
    .opcode(opcode),
    .reg_dst(reg_dst),
    .jump(jump), 
    .branch(branch),
    .RegWrite(RegWrite),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .alu_src(alu_src)
);

ALU_control ALUcontrol(
    .alu_op(alu_op),
    .funct(funct),
    .ALUcontrol(ALUcontrol)
);

// ======= write register mux======
MUX2 regMux(
    .sel(reg_dst),
    .in0(rt),
    .in1(rd),
    .out(write_reg)
);


// ===== Register File =====
Register_file reg_file(
    .clk(clk),
    .RegWrite(RegWrite),            // enable 
    .rsA(rsA),
    .rtA(rtA),
    .write_reg(write_reg),          // the  address of destination reg (rd || rt)
    .RegWrite_data(RegWrite_Data),
    .rsV(rsV),
    .rtV(rtV)
);

sign_extd se(
    .extd(),//?????????????????????????????
    .in(imm),
    .out(immediate_extended)
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
    .ALUcontrol(ALUcontrol),
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
    .out(RegWrite_Data)
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
