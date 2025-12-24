module ALU_control(
input  wire               alu_op,
input  wire [4:0]         funct,   
output wire [2:0]      ALUcontrol
);
assign funct= instruction[4:0];   // last 5bits from instruction
assign ALUcontrol = (alu_op)?     :       ;

endmodule