module instruction_MEM(

input wire [31:0] read_address,

output wire[31:0] instruction
):

reg [19:0] i_mem [0:255];          //  256x20 instruction memory.
instruction= i_mem[read_address];

endmodule