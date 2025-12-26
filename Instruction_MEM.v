module instruction_MEM(

input wire [31:0] read_address,
output reg[31:0] instruction
);

reg [19:0] i_mem [0:255];          //  256x20 instruction memory.
integer i;

 initial begin
         //=====initialization=======
        i_mem[0] = 32'h20080005; // addi $t0, $zero, 5
        i_mem[1] = 32'h20090003; // addi $t1, $zero, 3
        i_mem[2] = 32'h01095020; // add  $t2, $t0, $t1
        i_mem[3] = 32'h012A5822; // sub  $t3, $t1, $t2
        i_mem[4] = 32'h08000004; // j    4 (infinite loop)

        // Fill rest with NOPs
                for (i = 5; i < 256; i = i + 1)
            i_mem[i] = 32'h00000000;
   // end
  end

  assign  instruction= i_mem[read_address];

endmodule
