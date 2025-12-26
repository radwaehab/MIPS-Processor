module main_control_unit(

input  reg [5:0] opcode,
output reg        jump,
output reg        branch,
output reg        reg_dst,
output reg        reg_write,
output reg        mem_read,
output reg        mem_write,
output reg        mem_to_reg,
output reg        alu_op,
output reg        alu_src,
output reg        extd
);

always @*
  begin
    // ============initialization=============
                       jump         = 0;
                       branch       = 0;
                       reg_dst      = 0;
                       reg_write    = 0;
                       mem_read     = 0;
                       mem_write    = 0;
                       mem_to_reg   = 0;
                       alu_op       = 0;
                       alu_src      = 0;
                       extd         = 0;
                   //    PMC_En       = 0;//?
                     //  JMN_En       = 0;//?
                       //SWI_En       = 0;//?


    case(opcode)
        6'b000000 : begin                    //R_type=0
                       reg_dst    =1;
                       reg_write  =1;
                       alu_op     =2'b10;
                     end

        6'b000001 : begin                     //ADDI=1
                       reg_write   =1;
                       alu_op      =2'b00;
                       alu_src     =1;
                       extd        =1;
                     end

        6'b000010 : begin                    //ANDI=2
                       reg_write   =1;
                       alu_op      =2'b10;
                       alu_src     =1;
                     end
                     
        6'b000011 : begin                    //LW=3
                       reg_write   =1;
                       mem_read    =1;
                       mem_to_reg  =1;
                       alu_op      =2'b00;//add
                       alu_src     =1;
                       extd        =1;
                     end
                     
        6'b000100 : begin                    //SW=4
                       mem_write   =1;
                       alu_op      =2'b00;
                       alu_src     =1;
                       extd        =1;
                     end
                     
        6'b000101 : begin                    //BEQ=5 
                       alu_op      =2'b01;//sub
                       extd        =1;
                     end

        6'b000110 : begin                    //J=6
                       jump        =1;
                     end
        default   :    begin
                       jump         = 0;
                       branch       = 0;
                       reg_dst      = 0;
                       reg_write    = 0;
                       mem_read     = 0;
                       mem_write    = 0;
                       mem_to_reg   = 0;
                       alu_op       = 0;
                       alu_src      = 0;
                       extd         = 0;
                    //   PMC_En       = 0;//?
                      // JMN_En       = 0;//?
                      // SWI_En       = 0;//?
                     end
    endcase
  end
  endmodule
