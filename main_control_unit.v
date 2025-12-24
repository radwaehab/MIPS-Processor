module main_control_unit(

input  reg  [5:0] opcode,

output wire        branch,
output wire        reg_dst,
output wire        reg_write,
output wire        mem_read,
output wire        mem_write,
output wire        mem_to_reg,
output wire        alu_op,
output wire        alu_src

);

always @*
  begin
    case(opcode= instruction[31:26])
       begin
        
       end
  end

endmodule