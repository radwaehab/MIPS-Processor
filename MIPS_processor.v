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
wire [31:0] rsV, rtV, immediate_extended, instr26 ;
wire [31:0] ALU_input2, ALU_result;
wire [31:0] mem_data;
wire [31:0] RegWrite_Data;
wire Zero;

// Control signals
wire RegWrite, mem_read, mem_write, mem_to_reg, alu_src, branch, jump, reg_dst, extd;
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
//assign immediate_extended = {{29{instruction[2]}}, instruction[2:0]}; // sign-extend 3-bit immediate


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
    .alu_src(alu_src),
    .extd(extd)
);

ALU_control ALUctrl(
    .alu_op(alu_op),
    .funct(funct),
    .ALUcontrol(ALUcontrol)
);

// ======= write register mux======
mux regMux(
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
    .extd(extd),
    .in(imm),
    .out(immediate_extended)
);


// ===== ALU =====

mux aluMux(
    .sel(alu_src),
    .in0(rtV),
    .in1(immediate_extended),
    .out(ALU_input2)
);

ALU alu_inst(
    .A(rsV),
    .B(ALU_input2),
    .ALUcontrol(ALUcontrol),
    .Result(ALU_result),
    .Zero(Zero)
);

// ===== Data Memory =====
data_MEM dmem(
    .clk(clk),
    .memr(mem_read),
    .memw(mem_write),
    .address(ALU_result),
    .datain(rtV),
    .dataout(mem_data)
);

// ===== Write-Back MUX =====
mux #(32) wbMux(
    .sel(mem_to_reg),
    .in0(ALU_result),
    .in1(mem_data),
    .out(RegWrite_Data)
);

// ===== Branch/Next PC/jump =====
wire [31:0] immshift, branch_addr, pcMux_result, jaddress;

assign immshift   = (immediate_extended << 2);
assign instr28 = (instr26 << 2);
assign jaddress= {PC_plus_4[31:28], instruction[25:0], 2'b00};

add branch_add(
    .a(PC_plus_4),
    .b(immshift),
    .sum(branch_addr)
);

mux #(32) pcMux(
    .sel(Branch & Zero),
    .in0(PC_plus_4),
    .in1(branch_addr),
    .out(pcMux_result)
);

mux #(32) jMux(
    .sel(jump),
    .in0(pcMux_result),
    .in1(jaddress),
    .out(Next_PC)
);

endmodule
